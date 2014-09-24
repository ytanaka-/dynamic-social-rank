Dynamic Social Rank(仮)
====

リアルタイムかつインタラクティブに順位を操作可能なソーシャルブックマークサービス。Streamに登録されているアイテムをage/sageすることで、今自分が面白いと思っているもの・必要なものを周知させることができる。

## Description
### DynamicRankの仕様
1. 新しく追加されたitemはtopへ行く
2. ageられたものはtopへ、sageられたものは1Rank下がる（ここは動的にしたい。age/sageの比率で変えるとか）

### システム構成
※だいたい[unific](https://github.com/nikezono/unific)と同じ

1. Server Side  
Node.js, Express, MongoDB, Socket.io
 
2. Client Side  
Backbone.js, Backbone.Marionette

3. その他  
Grunt, Bower

## Usage
また今度書く 