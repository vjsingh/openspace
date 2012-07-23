define ["views/AppView", 'app', 'views/signup'], (AppView, app) ->
  class app.views.ArtistHome extends AppView
    templateName: "ArtistHome"

    postRender: () ->
      this.addView(new app.views.Signup(), '#signup')

    uploadFile: (evt) ->
      event.preventDefault()
      _file = $("#fileId").val().replace(/.+[\\\/]/, "")

      _file = 'adsf'
      $.ajax(
        url: "/gets3credentials/" + _file
        dataType: "text"
        success: (res, status) ->
          res = JSON.parse(JSON.parse(res)) # TODO: WTF
          $('#s3_AWSAccessKeyId').val(res.s3KeyId);
          $('#s3_signature').val(res.s3Signature);
          $('#s3_policy').val(res.s3PolicyBase64);

          #$('#s3_success_action_redirect').val(res.s3Redirect);
          $('#s3_success_action_status').val(res.s3RedirectStatus);
          #$('#s3_key').val('${filename}');
          $('#s3_key').val(res.s3Key);
          $('#s3_acl').val(res.s3Acl);
          $('#s3_Content-Type').val(res.s3ContentType);
          formData = $('#uploadForm').serialize();
          #top.GLOBAL_sendFormData(formData);
          top.GLOBAL_sendFormData();
          checkForSubmit();
          #$('#uploadForm').submit();
          #$('#uploadForm').submit(function() {return false;});
  
          error: (res, status, error) -> #do some error handling here
            console.log('error', res, status, error)
      )


###
Old Iframe stuff
  function addIframe() {
   $('iframe').remove();
   var subframe = document.createElement('iframe');
   document.body.appendChild(subframe);
   $('iframe').hide();
   subframe.src = "iframe.html";
  };
  addIframe();
  checkForSubmit = function() {
   var timeout = setInterval(function() {
    if ($('iframe').contents().length != 0) {
     // Not received yet
    } else {
     // Got a response!
     clearInterval(timeout);
     addIframe();
    }
   }, 100);
  }
####
