###
define((require) ->
  $           = require('jquery')
  _           = require('underscore')
  Backbone    = require('backbone')
  dummy       = require('handlebars')
  dummy       = require('plugins/backbone.layoutmanager')
  dummy       = require('templates')
  asdf
###

define(['jquery', 'underscore', 'backbone', 'handlebars', 'templates', 'jqueryUniqueElementId', 'backboneValidation'], 
  ($, _, Backbone, views) ->
    # Global location for config settings and module creation
    # Mix Backbone.Events, modules, and view management into the app object.
    # Mediator is a global pub/sub object
    Mediator = {}
    _.extend(Mediator, Backbone.Events)
    app = {
      root: "/"
      views: {}
      models: {}
      collections: {}
      Templates: window.Templating
      getTemplate: (templateName, context) ->
        return app.Templates.tpl(templateName + '.us', context)
      Mediator: Mediator

      module: (additionalProps) ->
        return _.extend({
          Views: {},
          additionalProps
        })

      # Manages transitions between views
      AppView: 
        # Keep track of all the views so we can destroy them later
        views: {}

        # Sets the main view in the page (not the header/footer)
        setMainView: (view) ->
          this.setView(view, $('#main'))

        setView: (view, el) ->
          # Destroy (includes removing from DOM) any old view at that el
          uniqueElId = el.uid()
          oldView = this.views[uniqueElId]
          oldView.destroy()  if oldView

          # Insert into the DOM.
          el.empty().html(view.el)

          view.render()

          # Cache the refererence.
          this.views[uniqueElId] = view
          return view

        setHeader: (header) ->
          return @header if @header 
          @header = header
          $('#header').html(header.el)
          header.render()
          return header
    }
    _.extend(Backbone.Validation.callbacks, {
      valid: (view, attr, selector) ->
        view.$('[' + selector + '~=' + attr + ']')
            .removeClass('invalid')
            .removeAttr('data-error');
        errorLabel = $('#' + attr + 'ErrorLabel')
        if (errorLabel)
          errorLabel.text('')
      invalid: (view, attr, error, selector) ->
        view.$('[' + selector + '~=' + attr + ']')
            .addClass('invalid')
            .attr('data-error', error);
        errorLabel = $('#' + attr + 'ErrorLabel')
        if (errorLabel)
          errorLabel.text(error)
    })

    # Watch for changes in less files
    less.env = 'development'; # Forces refresh on @import changes
    less.watch()
    return app
)


### If we ever want to go back to fetching templates asynchronously
fetch: (path) ->
  path = path + ".html"
  unless JST[path]
    $.ajax({
      url: venmo.root + path
      async: false
    }).then (contents) ->
      JST[path] = _.template(contents)
  return JST[path]
###

