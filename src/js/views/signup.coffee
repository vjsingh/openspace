define ["views/AppView", 'app', 'helpers', 'models/User'], (AppView, app) ->
  class app.views.Signup extends AppView
    templateName: "signup1"

    initialize: () ->
      this.model =  new app.models.User()
      Backbone.Validation.bind(this)

    events:
      'keyup input[type!="submit"]': 'inputChanged'
      'click input[name="submitEmail"]': 'submitEmail'
      'click input[name="submitName"]': 'submitName'

    inputChanged: (evt) ->
      el = $(evt.currentTarget)
      name = el.attr('name')
      this.model.set({
        email: el.val()
        error: () ->
          console.log 'got error'
      })

    setSignupStage: (signupNum) =>
      this.$el.html(app.getTemplate("signup#{signupNum}"))
    
    submitEmail: (evt) =>
      console.log 'in submitmeail'
      evt.preventDefault()
      if this.model.isValid('email')
        this.setSignupStage(2)

    submitName: (evt) ->
      evt.preventDefault()
      this.setSignupStage(3)

    signupFailed: (req, status, err) ->
      console.log(req, status, err)
      $('#signupText').html(makeTemplate('#signupFailed'))
      $('#tryAgainBtn').click((e) ->
      $('#signupText').html(makeTemplate('#signingUp'))
        registerUser()
      )

    registerUser: () ->
      $.ajax({
        type: 'POST'
        url: '/register'
        data: {user: user.toJSON()}
        dataType: 'json'
        timeout: 2000
        success: (data) ->
          if (data == 'success')
            $('#signupText').html(makeTemplate('#signupSucceeded'))
          else
            signupFailed()
        error: (req, status, err) ->
          signupFailed(req, status, err)
      })


