#
# 密なメソッドの退避場所
#
# DynamicRankの仕様
# 新しく追加されたitemはtopへ
# ageられたものはtopへ、sageられたものは1rank下がる（ここは動的にしたい。age/sageの比率で変えるとか）
# メモ
#  1. 新しく追加されたitemは自動的にage+1される
#  2. voteをdateでsortする
#  3. 2を元にrankを計算する
#

module.exports.HelperEvent = (app) ->

  async  = require 'async'
  _      = require 'underscore'
  debug  = require('debug')('events/helper')

  Stream = app.get("models").Stream
  Item   = app.get("models").Item
  Vote   = app.get("models").Vote


  # Streamに登録されたvoteからdynamicRankを作成
  # @todo 要リファクタ！
  createDynamicRank: (stream,callback)->
    if not stream
      return callback new Error "stream is empty"

    # voteを取得し、rankを計算
    Vote.findVoteByStream stream,(err,votes)->
      if err
        debug err
        return callback err

      list = []
      stack = votes

      # 以下は関数型でかっこ良く書けそうな気がする
      async.eachSeries stack, (vote,next)->
        item = vote.item

        # 既にlistにitemが含まれているか
        already_resisted_item = _.find list,(list_item)->
          return list_item if _.isEqual list_item._id,item._id

        if not already_resisted_item
          # topに追加
          list.unshift item

        else
          # itemの格納位置を保存
          item_index = list.indexOf(item)
          # 元々の場所のオブジェクトを削除
          list =  _.without list,item

          if vote.type is "up"
            # 該当するitemを先頭へ
            list.unshift item
          else
            # 元々の位置の１つ後ろに追加
            # @todo 動的に
            list.splice item_index + 1, 0 ,item

        next()
      , (err)->
        callback null,list