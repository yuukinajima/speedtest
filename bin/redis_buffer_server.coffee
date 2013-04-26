cluster = require "cluster"
http = require "http"
numCPUs = (require "os").cpus().length

rclient = require('redis-url').connect("redis://rg:cedfe4f4028846458d4f808d57e31e1a@bright-daffodil-533.redisgreen.net:11042/");
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
  http.createServer (req, res) ->
    if req.method is "POST"
      data = ""
      req.on "data", (chunk) ->
        data += chunk

      req.on "end", ->
        res.writeHead 200,
          "Content-Type": "application/json"
        do res.end
        rclient.rpush store, data
    else
      console.log "get"
      do res.end
  .listen 10000