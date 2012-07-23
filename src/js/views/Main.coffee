define ["views/AppView", 'app'], (AppView, app) ->
    class app.views.Main extends AppView
        templateName: "layout",

        context: () ->
            return {
              some_value: 1
            }
