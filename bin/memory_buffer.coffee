cluster = require "cluster"
http = require "http"
numCPUs = (require "os").cpus().length

qs = require 'qs'

mongo = require "mongo"
console.log "start"

store = "sssstore"



if cluster.isMaster
  # Fork workers.
  i = 0
  while i < numCPUs
    cluster.fork()
    i++
  cluster.on "exit", (worker, code, signal) ->
    console.log "worker " + worker.process.pid + " died"
else
  buffer = []
  http.createServer (req, res) ->
    if req.method is "POST"
      data = ""
      req.on "data", (chunk) ->
        data += chunk
      req.on "end", ->
        res.writeHead 200,
          "Content-Type": "application/json"
        do res.end
        buffer.push qs.parse data
    else
      console.log "get"
      do res.end
  .listen 10000

  setInterval ()->
    _buffer = []
    [buffer,_buffer] = [_buffer,buffer]
    mongo.log.create _buffer, (err, args...)->
      console.log "e", err if err
  ,5000