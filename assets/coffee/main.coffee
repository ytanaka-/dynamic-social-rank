$ ->
  ### Configration & Initialize ###
  _.templateSettings =
    interpolate: /\{\{(.+?)\}\}/g

  stream = (window.location.pathname).substr(1)
  socket = io.connect "#{location.protocol}//#{location.hostname}?stream=#{stream}"

  httpApi = httpApiWrapper(stream)
  ioApi   = ioApiWrapper(socket)

  # ゼッタイリファクタしろよ？ゼッタイだぞ？
  window.ioApi = ioApi

  streamItems = new StreamItems()
  streamItemsView = new StreamItemsView
    collection:streamItems

  # 初回読み込み用メソッド
  refresh = (callback)->
    httpApi.getStreamItemList (err,data)->
      if err
        console.error err
        return alert "Initialize Error.Please Reload."

      newStreamItems = []
      for item in data.items
        newStreamItems.push new StreamItem(item)
      streamItems.reset newStreamItems

      return callback() if callback

  # marionette
  Main = new Backbone.Marionette.Application()
  Main.addRegions
    items: '#Items'

  Main.addInitializer (options)->
    Main.items.show streamItemsView

  # 初回読み込み
  if not _.isEmpty stream
    refresh ->
      Main.start()


  ## EventHandlers 要リファクタ ##

  # 更新の通知が来たらrefreshを呼ぶ
  socket.on "notifyNewItems",(data)->
    refresh()

  # url post
  $("form").submit ->
    post_item_url = $('#m').val()
    if post_item_url
      # @todo
      # 要切り分け
      socket.emit 'post_item',{ post_item_url: post_item_url }
      $('#m').val('')
    return false

