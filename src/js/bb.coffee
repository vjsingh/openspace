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
