mongoose = require 'mongoose'

itemSchema = new mongoose.Schema
  title: String
  description: String
  url: String
  site_url: String
  thumbnail: String
  tags: [String]
  stream: { type: mongoose.Schema.Types.ObjectId, ref: 'Stream' }
  timestamp: { type: Date, default: Date.now, index: true }


itemSchema.statics =
  # 対象のstreamオブジェクトをキーに持つitemをすべて取得
  findAllByStream: (stream, cb)->
    @find
      stream: stream._id
    .exec(cb)

  findByUrl: (url, cb)->
    @find
      url: url
    .exec(cb)

  findByUrlAndStream: (url,stream, cb)->
    @find
      url: url
      stream: stream._id
    .exec(cb)

  checkRegisteredURLAndStream: (url,stream,cb) ->
    @find
      url: url
      stream: stream
    .exec (err,items) ->
      if err
        return cb new Error err
      if items.length > 0
        return cb new Error "URL(#{url})はStream(#{stream.title})に登録されています"
      cb null


exports.Item = mongoose.model 'Item',itemSchema