console.log("ASDASD in uploade.coffee");

$(()->
  console.log("ASDASD in uploade.coffee");
  addIframe = ->
    $("iframe").remove()
    subframe = document.createElement("iframe")
    document.body.appendChild subframe
    subframe.src = "iframe.html"
  addIframe()
  checkForSubmit = ->
    timeout = setInterval(->
      console.log $("iframe")
      if $("iframe").contents().length is 0
        clearInterval timeout
        addIframe()
    , 100)

  $("#submitBtn2").click (event) ->
    console.log "ASDASDSADSAD"
    event.preventDefault()
    fileName = $("#uploadFile").val().replace(/C:\\fakepath\\/i, "")
    console.log fileName
    $.ajax
      url: "/gets3credentials/" + fileName + "/" + artworkName
      dataType: "text"
      success: (res, status) ->
        console.log res
        return
        if res is "fail"
          console.log "FAIL"
          return
        res = JSON.parse(JSON.parse(res))
        console.log res
        $("#s3_AWSAccessKeyId").val res.s3KeyId
        $("#s3_signature").val res.s3Signature
        $("#s3_policy").val res.s3PolicyBase64
        $("#s3_success_action_redirect").val res.s3Redirect
        $("#s3_key").val res.s3Key
        $("#s3_acl").val res.s3Acl
        $("#s3_Content-Type").val res.s3ContentType
        $("#uploadForm").submit()
        checkForSubmit()

      error: (res, status, error) ->
        console.log "error", res, status, error
)
