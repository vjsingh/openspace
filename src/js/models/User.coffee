define ['models/AppModel', 'app', 'jqueryCookie'], (AppModel, app) ->
  class app.models.User extends AppModel
    defaults:
      access_token: null

    initialize: =>
      @bind('change:access_token', @getUserAttributes)
      @load()

    authenticated: ->
      Boolean(@get("access_token"))

    # Saves session information to cookie
    save: () ->
      # Expire in 15 minutes
      $.cookie('user_id', @get('user_id'), {expires: .01})
      $.cookie('access_token', @get('access_token'), {expires: .01})

    # Loads session information from cookie
    load: ->
      @set
        access_token: $.cookie('access_token')
        user_id: $.cookie('user_id')    

    getUserAttributes: () =>
      # Attempts to load user data using the current access token.
      # Clears user data if access token is null.
      access_token = @get('access_token')
      if access_token != null
        endpoint = '/api/v5/users/'+@get('user_id')
        #callback = (response) -> @get('user_attributes') = response
        request = $.get endpoint, {access_token: access_token}, callback
      else
        #@set('user_attributes') = null

    validation:  
      email: (email) ->
        this.email = null
        return 'Invalid Email!' if !email
        re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
        lcEmail = email.toLowerCase()
        return "Invalid Email!" if !re.test(email)
        return 'Must use a Brown or RISD email' if ( (lcEmail.indexOf('brown.edu') < 0) and (lcEmail.indexOf('risd.edu') < 0) )
      name: (name) ->
        return 'Required!' if !name
        return 'Too Short' if (name.length < 3)
      password: (pass) ->
        return 'Required!' if !pass
        return 'Must be more than 5 characters' if (pass.length < 6)
      password2: (pass2) ->
        return 'Required!' if !pass2
        return "Doesn't Match" if this.get('password') != pass2
      username: (username) ->
        return 'Required!' if !username
        return 'Too Short' if (username.length < 3)

    validateEmail: (email) ->
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
      lcEmail = email.toLowerCase()
      return "Invalid Email!" if !re.test(email)
      return 'Must use a Brown or RISD email' if ( (lcEmail.indexOf('brown.edu') < 0) and (lcEmail.indexOf('risd.edu') < 0) )
      return true

  app.currentUser = new app.models.User()
  return app.models.User
