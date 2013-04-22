cluster = require "cluster"
http = require "http"
numCPUs = (require "os").cpus().length

redis = require "redis"
rclient = redis.createClient null
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