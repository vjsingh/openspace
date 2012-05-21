User = Backbone.Model.extend({
  validation:  {
    email: (email) ->
      return 'Invalid Email!' if !email
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      lcEmail = email.toLowerCase()
      return "Invalid Email!" if !re.test(email)
      return 'Must use a Brown or RISD email' if ( (lcEmail.indexOf('brown.edu') < 0) and (lcEmail.indexOf('risd.edu') < 0) )
  }
  validateEmail: (email) ->
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    lcEmail = email.toLowerCase()
    return "Invalid Email!" if !re.test(email)
    return 'Must use a Brown or RISD email' if ( (lcEmail.indexOf('brown.edu') < 0) and (lcEmail.indexOf('risd.edu') < 0) )
    return true
})

user = new User()


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
    this.setSignupPage(3) if (this.model.isValid('name') and this.model.isValid('password') and this.model.isValid('password2') and this.model.isValid('username'))

  inputChanged: (event) ->
    obj = {}
    obj[event.target.name] = event.target.value
    this.model.set(obj)

  emailChanged: (event) ->
    email = this.input.val()
    user.set({email: email})
    ###
    returned = user.set({email: email}, {
      error: (model, error) ->
        $('#errorDisplay').html(error)
    })
    if (returned)
      $('#errorDisplay').html("")
    ###
})

$('#uploadForm').hide()
signup = new EmailView({
  el: $('#signup')
  model: user
})

###
addBindings = (view, model) ->
  events = view.events
  el = $(view.el)
  events['click input[type=submit]'] = 'submitForm'
  inputs = []
  for child in el.find('form').children()
    if child.type != 'submit'
      inputs.push(child)
  for input in inputs
      events['keyup input[name=' + input.name + ']'] = 'inputChanged'
  console.log(view.numInputs)
  view.inputChanged = (event) ->
    value = event.target.value
    name = event.target.name
    obj = {}
    obj[name] = value
    returned = user.set(obj, {
      error: (model, error) ->
        event.target.isValid
        $('#' + name + 'ErrorDisplay').html(error)
    })
    if (returned)
      $('#' + name + 'ErrorDisplay').html('')
  view.submitForm = (event) ->
    #Button clicked, you can access the element that was clicked with event.currentTarget
    event.preventDefault()
    email = this.input.val()
    returned = user.set({email: email}, {
      error: (model, error) ->
        $('#errorDisplay').html(error)
    })
    if (returned)
      submitSuccessful(event)
###
