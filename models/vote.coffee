mongoose = require 'mongoose'

voteSchema = new mongoose.Schema
  #user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
  item: { type: mongoose.Schema.Types.ObjectId, ref: 'Item' }
  stream: { type: mongoose.Schema.Types.ObjectId, ref: 'Stream'}
  type: String
  date: { type: Date, default: Date.now, index: true }


# Validations
voteSchema.path('type').validate (value) ->
  if value is "up" | value is "down" # もっとかっこいい書き方知りたい・・・
    return true
  return false
, 'Invalid value'

voteSchema.statics =
  findVoteByStream: (stream,cb)->
    @find
      stream: stream._id
    #.sort({'date':1}) # 昇順でソート 元々昇順ぽいのでコメントアウト中
    .populate('item')
    .exec (err,votes)->
      cb err, votes

exports.Vote = mongoose.model 'Vote',voteSchema