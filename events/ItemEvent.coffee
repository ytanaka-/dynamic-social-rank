module.exports.ItemEvent = (app) ->

  async  = require 'async'
  _      = require 'underscore'
  debug  = require('debug')('events/item')
  URL    = require 'url'
  client = require 'cheerio-httpcli'

  Stream = app.get("models").Stream
  Item   = app.get("models").Item

  VoteEvent = app.get('events').VoteEvent app

  # 役割持ちすぎ感ハンパない
  addItem: (url, stream, callback) ->
    # Streamに既にURLが登録済みかどうかCheck
    Item.checkRegisteredURLAndStream url,stream,(err)->
      if err
        debug(err)
        return callback(err)

      # urlからmetadataを抽出
      client.fetch url,(err,$,res)->
        if err
          debug(err)
          return callback(err)

        tags = []
        keywordString = $("meta[name='keywords']").attr("content")
        tags = keywordString.split(',') if keywordString

        item = new Item
          title: $('title').text()
          description: $("meta[property='og:description']").attr("content")
          url: url
          site_url: URL.parse(url).hostname
          thumbnail: $("meta[property='og:image']").attr("content")
          tags: tags
          stream: stream._id

        #save
        item.save (err)->
          if err
            debug(err)
            return callback(err)

          # itemを追加した場合、vote(up)を行う item._idはnewされた時点で決まっているので、そのまま使える
          VoteEvent.vote item._id,stream,"up",(err)->
            if err
              debug err
              return callback(err)
            callback(null)