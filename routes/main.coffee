#
# httpリクエスト用ルーティング設定
#

module.exports = (app) ->
  debug = require('debug')('routes/main')

  # include events
  StreamEvent = app.get('events').StreamEvent app
  ItemEvent   = app.get('events').ItemEvent app
  VoteEvent   = app.get('events').VoteEvent app


  app.get '/', (req,res,next)-> StreamEvent.index req,res,next

  # 各streamのトップ
  app.get '/:stream', (req,res,next)-> StreamEvent.index req,res,next

  app.get '/:stream/list', (req,res,next)-> StreamEvent.list req,res,next

  # streamにitemを追加
  app.post '/:stream/add', (req,res,next)-> StreamEvent.addItemByStream req,res,next

  app.post '/:stream/create', (req,res,next)-> StreamEvent.createStream req,res,next
  app.post '/:stream/vote', (req,res,next)-> VoteEvent.voteByHttpRequest req,res,next