# Define our own App view that all views should inherit from
define ['app'], (app) ->
  class AppView extends Backbone.View
    
    # For Garbage collection
    # Format is [ [obj, event, cb], [this.model, 'change', this.render]]
    addedEventBindings: []    
    views: [] # Also for garbage collection

    # Abstraction for adding events on objects that aren't the dom
    # Currently, lets us garbage collect on this.destroy()
    doBind: (obj, event, cb) =>
        obj.on(event, cb, this)
        addedEventBindings.push([obj, event, cb])

    addView: (view, selector) =>
      $(selector).html(view.el)
      view.render()
      this.views.push(view)

    unbindFromAll: () =>
        for eventArr in @addedEventBindings
            [obj, event, cb] = eventArr
            obj.off(event, cb)
        @addedEventBindings = []

    destroy: () =>
        @remove()
        @unbind() # Unbinds all events in events hash and 'this.trigger's
        @unbindFromAll()
        view.destroy() for view in this.views
        this.views = [] #Don't keep around any references, just in case

    render: () =>
        @renderTemplate()
        @postRender() if @postRender

    renderTemplate: (context, templateName) =>
        # Get default context and templateName if none is supplied
        context = @context() if !context
        templateName = @templateName if !templateName

        @$el.html(app.getTemplate(@templateName, context))
        return this

    # Default context for template is model attrs
    context: () =>
        if @model
            return @model.attributes
        else
            return {}

  return AppView
