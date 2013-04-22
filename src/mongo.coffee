mongoose = require 'mongoose'

config = require 'config'

if config.mongodb.replset?.length > 0
  sets = ( "#{n.host}:#{n.port}"for n in config.mongodb.replset )
  uri = "#{config.mongodb.user}:#{config.mongodb.password}@" +
  (sets.join ",")+ 
  "/#{config.mongodb.database}"
else
  uri = "mongodb://#{config.mongodb.user}:#{config.mongodb.password}@#{config.mongodb.host}:#{config.mongodb.port}/#{config.mongodb.database}"

mongoose.connect uri
log = new mongoose.Schema
  uuid        : {type:String,required:true, index: true }
  event       : {type:String,required:true, index: true }
  time        : {type:Date,required:true, index: true }
  userattr    : {}
  attr        : {}

exports.log = mongoose.model 'logs', log