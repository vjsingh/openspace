# Arter

## Installation Instructions

Install Node

Run this from the command line:
npm install -g jade vogue coffee-script watchr tplcpl uglify-js nodewatch

Note:If you ever get a 'module \<module\> not found' error, just run npm install -g \<module_name\>

## Developing
To run the local server, just run ./runServer.
Then, simply run ./watchFiles in a separate terminal, and all source files will be compiled as you save them! 
* Notes:
    If a file is not being changed, you must first run ./watchFiles and then save the file
    The script occasionally runs into errors. If it does, just run it again
Less files should be automatically updated in the browser (if not, let me know).

## Project filetree
src has all of our src code. Its split up into js (coffeescript), css (less), and views (jade).  
|-src  
|---css  
|---js  
|-----models
|-----views  
|---views  
|-----templates  

Docs are generated by Docco  
|-docs  

Static has all our compiled src and external libraries/assets.   

* Coffeescript -> js
* Less -> css
* 3rd party libraries and plugins in js/libs js/plugins
* Jade -> HTML+Underscore templates in templates. Then we compile the Underscore templates into js/templates.js

|-static  
|---css  
|---js  
|-----libs  
|-----plugins  
|---views  
|-----templates  

### Watching/Compiling Explanation
When developing, you'll need to run a script to instantly watch and compile all src files (as they're changed) since we're using Coffeescript, Less, and Jade. Everything takes place in the script ./watchFiles

* **Coffeescript**

    We compile all coffeescript from src/js/ into static/js.

* **Less**

    Less is compiled into static/css/

* **Jade/Underscore**

    Our Jade has js/underscore templates in it. Jade is first compiled into Html+underscore. Cs and Less both have watch commands, but jade doesn't. So, compiling Jade happens in Cakefile jade:compile.

    Underscore templates are also compiled in the Cakefile. First, we rename all .html extensions to .us. Then, we use tplcpl to compile all underscore templates into statis/js/templates.js

* **Live Stylesheets Injection**

    We're also trying to use Vogue to automatically inject stylesheets as they're changed into the browser. This works when you change the CSS directly, but inconsistently when the CSS is over-written by our compiled tool (its weird...). Theres an issue filed for it here https://github.com/joyent/node/issues/1986, since Vogue uses fs.watch.

    An alternative would be to try and switch to https://github.com/viatropos/design.io

    If you want to try it, just run 'vogue' from the top level dir and either add this script to index.html "http://localhost:8001/vogue-client.js", or copy this into a bookmarklet and run it:
    javascript:(function()%7Bif%20(typeof%20window.__vogue__!=='undefined')%20return;window.__vogue__%20=%20%7BrootUrl:'http://localhost:8001/',domain:'localhost',port:8001%7D;var%20s%20=%20document.createElement('script');s.setAttribute('src',%20'http://localhost:8001/vogue-client.js');s.setAttribute('type',%20'text/javascript');document.getElementsByTagName('head')%5B0%5D.appendChild(s);%7D)()

* Installing Docco (Optional, generates documentation)

    npm install -g docco
    easy_install Pygments

Then run docco src/js/*.coffee which will generate docs into docs/

# Project Structure
index.html is our main file. We are using requirejs, so all we need to do is include that and then include our requirejs config file
