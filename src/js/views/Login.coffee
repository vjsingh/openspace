define ["views/AppView", 'app', 'helpers', 'models/User'], (AppView, app) ->
    class app.views.Login extends AppView
        templateName: "login"

        context: () ->

        initialize: () ->

        events:
            'click button[type="submit"]': 'submitLoginForm'

        submitLoginForm: (e) ->
            username = $('#id_username').val()
            password = $('#id_password').val()
            app.helpers.ajaxRequest(
                '/login'
                {
                    username: username
                    password: password
                }
                (response) =>
                    accessToken = response.accessToken
                    app.currentUser.set('accessToken', accessToken)
                    app.router.navigate('#home', {trigger: true})
            )

            e.preventDefault()

###
EmailView = Backbone.View.extend({
  initialize: () ->
    this.render()
    this.input = $("#emailForm > input")

    Backbone.Validation.bind(this, {
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



  setSignupPage: (step) ->
    console.log("in setSignupPage")
    template = _.template($('#signup' + step + 'T').html(), {})
    $(this.el).html(template)

  render: () ->
    this.setSignupPage(1)
    #template = _.template($('#emailTemplate').html(), {})
    #$(this.el).html(template)
    #addBindings(this, user)

  events: {
    "click input[name=submitEmail]": "submitEmail"
    "click input[name=submitName]": "submitName"
    #"keyup input[name=email]":  "emailChanged"
    "keyup input":  "inputChanged"
  },
  submitSuccessful: (event) ->
    this.setSignupPage(2) if (event.target.name == 'submitEmail')
    this.setSignupPage(3) if (event.target.name == 'submitName')

  submitEmail: (event)->
    event.preventDefault()
    this.setSignupPage(2) if this.model.isValid('email')

  submitName: (event)->
    #Button clicked, you can access the element that was clicked with event.currentTarget
    event.preventDefault()
    if (this.model.isValid('name') and this.model.isValid('password') and this.model.isValid('password2') and this.model.isValid('username'))
      this.setSignupPage(3)
      $('#signupText').html(makeTemplate('#signingUp'))
      registerUser()

  inputChanged: (event) ->
    obj = {}
    obj[event.target.name] = event.target.value
    this.model.set(obj)

  emailChanged: (event) ->
    email = this.input.val()
    user.set({email: email})
    returned = user.set({email: email}, {
      error: (model, error) ->
        $('#errorDisplay').html(error)
    })
    if (returned)
      $('#errorDisplay').html("")
})
###
