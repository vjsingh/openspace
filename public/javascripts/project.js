// Generated by CoffeeScript 1.3.1
(function() {
  var EmailView, User, makeTemplate, registerUser, signup, signupFailed, user;

  User = Backbone.Model.extend({
    validation: {
      email: function(email) {
        var lcEmail, re;
        this.email = null;
        if (!email) {
          return 'Invalid Email!';
        }
        re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        lcEmail = email.toLowerCase();
        if (!re.test(email)) {
          return "Invalid Email!";
        }
        if ((lcEmail.indexOf('brown.edu') < 0) && (lcEmail.indexOf('risd.edu') < 0)) {
          return 'Must use a Brown or RISD email';
        }
      },
      name: function(name) {
        if (!name) {
          return 'Required!';
        }
        if (name.length < 3) {
          return 'Too Short';
        }
      },
      password: function(pass) {
        if (!pass) {
          return 'Required!';
        }
        if (pass.length < 6) {
          return 'Must be more than 5 characters';
        }
      },
      password2: function(pass2) {
        if (!pass2) {
          return 'Required!';
        }
        if (this.get('password') !== pass2) {
          return "Doesn't Match";
        }
      },
      username: function(username) {
        if (!username) {
          return 'Required!';
        }
        if (username.length < 3) {
          return 'Too Short';
        }
      }
    },
    validateEmail: function(email) {
      var lcEmail, re;
      re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      lcEmail = email.toLowerCase();
      if (!re.test(email)) {
        return "Invalid Email!";
      }
      if ((lcEmail.indexOf('brown.edu') < 0) && (lcEmail.indexOf('risd.edu') < 0)) {
        return 'Must use a Brown or RISD email';
      }
      return true;
    }
  });

  user = new User();

  makeTemplate = function(templ, options) {
    return _.template($(templ).html(), options || {});
  };

  signupFailed = function(req, status, err) {
    console.log(req, status, err);
    $('#signupText').html(makeTemplate('#signupFailed'));
    return $('#tryAgainBtn').click(function(e) {
      $('#signupText').html(makeTemplate('#signingUp'));
      return registerUser();
    });
  };

  registerUser = function() {
    return $.ajax({
      type: 'POST',
      url: '/register',
      data: {
        user: user.toJSON()
      },
      dataType: 'json',
      timeout: 2000,
      success: function(data) {
        if (data === 'success') {
          return $('#signupText').html(makeTemplate('#signupSucceeded'));
        } else {
          return signupFailed();
        }
      },
      error: function(req, status, err) {
        return signupFailed(req, status, err);
      }
    });
  };

  EmailView = Backbone.View.extend({
    initialize: function() {
      this.render();
      this.input = $("#emailForm > input");
      return Backbone.Validation.bind(this, {
        valid: function(view, attr, selector) {
          var errorLabel;
          view.$('[' + selector + '~=' + attr + ']').removeClass('invalid').removeAttr('data-error');
          errorLabel = $('#' + attr + 'ErrorLabel');
          if (errorLabel) {
            return errorLabel.text('');
          }
        },
        invalid: function(view, attr, error, selector) {
          var errorLabel;
          view.$('[' + selector + '~=' + attr + ']').addClass('invalid').attr('data-error', error);
          errorLabel = $('#' + attr + 'ErrorLabel');
          if (errorLabel) {
            return errorLabel.text(error);
          }
        }
      });
    },
    setSignupPage: function(step) {
      var template;
      console.log("in setSignupPage");
      template = _.template($('#signup' + step + 'T').html(), {});
      return $(this.el).html(template);
    },
    render: function() {
      return this.setSignupPage(1);
    },
    events: {
      "click input[name=submitEmail]": "submitEmail",
      "click input[name=submitName]": "submitName",
      "keyup input": "inputChanged"
    },
    submitSuccessful: function(event) {
      if (event.target.name === 'submitEmail') {
        this.setSignupPage(2);
      }
      if (event.target.name === 'submitName') {
        return this.setSignupPage(3);
      }
    },
    submitEmail: function(event) {
      event.preventDefault();
      if (this.model.isValid('email')) {
        return this.setSignupPage(2);
      }
    },
    submitName: function(event) {
      event.preventDefault();
      if (this.model.isValid('name') && this.model.isValid('password') && this.model.isValid('password2') && this.model.isValid('username')) {
        this.setSignupPage(3);
        $('#signupText').html(makeTemplate('#signingUp'));
        return registerUser();
      }
    },
    inputChanged: function(event) {
      var obj;
      obj = {};
      obj[event.target.name] = event.target.value;
      return this.model.set(obj);
    },
    emailChanged: function(event) {
      var email;
      email = this.input.val();
      return user.set({
        email: email
      });
      /*
          returned = user.set({email: email}, {
            error: (model, error) ->
              $('#errorDisplay').html(error)
          })
          if (returned)
            $('#errorDisplay').html("")
      */

    }
  });

  signup = new EmailView({
    el: $('#signup'),
    model: user
  });

  console.log("ASD");

  signup.render();

  /*
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
  */


  console.log("ASDASD in uploade.coffee");

  $(function() {
    var addIframe, checkForSubmit;
    console.log("ASDASD in uploade.coffee");
    addIframe = function() {
      var subframe;
      $("iframe").remove();
      subframe = document.createElement("iframe");
      document.body.appendChild(subframe);
      return subframe.src = "iframe.html";
    };
    addIframe();
    checkForSubmit = function() {
      var timeout;
      return timeout = setInterval(function() {
        console.log($("iframe"));
        if ($("iframe").contents().length === 0) {
          clearInterval(timeout);
          return addIframe();
        }
      }, 100);
    };
    return $("#submitBtn2").click(function(event) {
      var fileName;
      console.log("ASDASDSADSAD");
      event.preventDefault();
      fileName = $("#uploadFile").val().replace(/C:\\fakepath\\/i, "");
      console.log(fileName);
      return $.ajax({
        url: "/gets3credentials/" + fileName + "/" + artworkName,
        dataType: "text",
        success: function(res, status) {
          console.log(res);
          return;
          if (res === "fail") {
            console.log("FAIL");
            return;
          }
          res = JSON.parse(JSON.parse(res));
          console.log(res);
          $("#s3_AWSAccessKeyId").val(res.s3KeyId);
          $("#s3_signature").val(res.s3Signature);
          $("#s3_policy").val(res.s3PolicyBase64);
          $("#s3_success_action_redirect").val(res.s3Redirect);
          $("#s3_key").val(res.s3Key);
          $("#s3_acl").val(res.s3Acl);
          $("#s3_Content-Type").val(res.s3ContentType);
          $("#uploadForm").submit();
          return checkForSubmit();
        },
        error: function(res, status, error) {
          return console.log("error", res, status, error);
        }
      });
    });
  });

}).call(this);
