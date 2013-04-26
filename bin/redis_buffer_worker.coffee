cluster = require "cluster"
numCPUs = (require "os").cpus().length

qs = require 'qs'

mongo = require "mongo"


rclient = require('redis-url').connect("redis://rg:cedfe4f4028846458d4f808d57e31e1a@bright-daffodil-533.redisgreen.net:11042/");
console.log "start"

store = "sssstore"

getval = (done) ->
  rclient.lpop store, (err, result) ->
    console.log "e", err if err
    if result
      l = new mongo.log qs.parse result
      l.save (err,r) ->
        console.log "e", err if err
      setTimeout getval, 0
    else
      setTimeout getval, 1000

if cluster.isMaster
  # Fork workers.
  i = 0
  while i < numCPUs
    cluster.fork()
    i++
  cluster.on "exit", (worker, code, signal) ->
    console.log "worker " + worker.process.pid + " died"
else
  getval()