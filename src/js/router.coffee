define ["app", 'backbone', 'views/ArtistHome', 'views/Login'], (app, Backbone) ->
  class Router extends Backbone.Router
    routes:
      "home": "index"
      "login": "login"

    index: ->
        app.AppView.setMainView(new app.views.ArtistHome())

    account: ->
        console.log("account")
        app.AppView.setMainView(new app.views.Main())
    login: ->
        #app.AppView.setMainView(new app.views.LoginHomepage())
        app.AppView.setMainView(new app.views.Login())

  return Router
