User = Backbone.Model.extend({
  validate: (attrs) ->
    if (attrs.email)
      if (! attrs.email.length < 3)
        return 'Invalid Email'
})

user = new User()

EmailView = Backbone.View.extend({
  initialize: () ->
    _.bindAll(this, 'contentChanged');
    this.render()

  render: () ->
    template = _.template($('#emailTemplate').html(), {})
    $(this.el).html(template)

  events: {
    "click input[type=submit]": "submitEmail"
    "change input.content":  "contentChanged"
  },

  validateEmail: (email) ->
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
    lcEmail = email.toLowerCase()
    return re.test(email) and ( (lcEmail.indexOf('brown.edu') > -1) or (lcEmail.indexOf('risd.edu') > -1) )

  submitEmail: (event)->
    #Button clicked, you can access the element that was clicked with event.currentTarget
    event.preventDefault()
    displayText = ''
    if (this.validateEmail($("#emailForm > input").val()))
      displayText = 'Valid Email!'
    else
      displayText = 'Invalid Email!'
    $('#display').html(displayText)

  contentChanged: (event) ->
    console.log(event, event.currentTarget)
})

$('#uploadForm').hide()
signup = new EmailView(el: $('#signupContainer'))
