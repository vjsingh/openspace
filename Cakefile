{spawn, exec} = require 'child_process'
watch         = require 'nodewatch'
path          = require 'path'

task 'jade:compile', 'compile jade templates', ->
  console.log 'compiling jade'
  exec 'jade src/views/templates/ --out public/views/templates/', (err, stdout, stderr) ->
      err && throw err
      console.log 'Jade templates compiled!'
      invoke 'underscore:renameTemplates'

task 'underscore:renameTemplates', 'Rename underscore templates from html to .us', ->
    exec 'for file in public/views/templates/*.html; do mv ${file} ${file%.html}.us; done;', (err, stdout, stderr) ->
        err && throw err
        console.log 'Underscore templates renamed!'
    invoke 'underscore:compileTemplates'

task 'underscore:compileTemplates', 'Compile and minify all underscore templates', ->
    exec 'tplcpl -t public/views/templates/ -o public/js/templates.js -c', (err, stdout, stderr) ->
        err && throw err
        console.log 'Underscore templates compiled!'

#
# Watch for changes in source files
# 
task 'watch', 'watches for changes in source files', ->
  console.log("Watching files")
  watch.add("./src", true).onChange((file,prev,curr,action) ->
    #console.log(action)
    console.log(file)
    ext = path.extname(file).substr(1)
    if ext == 'jade'
      invoke 'jade:compile'
    else if ext == 'less'
      console.log("updating less")
      #exec 'cp -r ./src/css ./public'
    else if ext == 'coffee'
      # Compile all coffeescript files
      console.log "Updating Coffeescript"
      exec 'coffee --output public/js/ --compile src/js/', (err, stdout, stderr) ->
        console.log err, stdout, stderr

    #console.log(path.extname(file))
    #console.log(prev.mtime.getTime())
    #console.log(curr.mtime.getTime())
  )
