window.httpApiWrapper = (currentStream)->

  getStreamItemList:(callback)->
    $.getJSON "/#{currentStream}/list"
    .success (data)->
      callback null,data
    .error (err)->
      callback err,null