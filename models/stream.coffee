mongoose = require 'mongoose'

###
mongooseのmodelのmethodsとstaticsの違いがよくわからない
 methodsに関数を追加することはprototypeに関数を追加するのと同義

staticsでも=>だとfindが解決されない問題
ポイントは２つ
１、findは依存先DBを解決した後に呼ばないと駄目
２、staticsに設定することで、thisがstreamSchemaを示す

methodsにしてしまうと、プロトタイプ継承された先のオブジェクトがthisになる
 =>でアローしても１の問題があるので解決されない
###

streamSchema = new mongoose.Schema
  title: String
  description: String


# pre-save hook
streamSchema.pre "save",(next)->
  # mongooseのモデルを取得
  stream = mongoose.model 'Stream'
  stream.find
    title: @title
  .exec (err,data)->
    if not err and data.length is 0
      return next()
    if err
      return next err
    next new Error 'Stream already exists'

streamSchema.statics =
  findByTitle: (title,cb)->
    @findOne
      title:title
    .exec(cb)


exports.Stream = mongoose.model 'Stream',streamSchema