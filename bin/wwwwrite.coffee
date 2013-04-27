cluster = require "cluster"
numCPUs = (require "os").cpus().length
mongo = require "mongo"
console.log "start"


if cluster.isMaster
  # Fork workers.
  i = 0
  while i < numCPUs
    cluster.fork()
    i++
  cluster.on "exit", (worker, code, signal) ->
    console.log "worker " + worker.process.pid + " died"
else
  e = (err,r) ->
    console.log "e", err if err
  d = 
    uuid:"uuid"
    event:"event"
    time: Date.now()
    attr:
      a:[1,2,3]
    userattr:
      b:1
      c:2

  fn = ()->
    l = new mongo.log d
    l.save e
  timer = setInterval fn, 1
  setTimeout ()->
    clearInterval timer
    console.log "end"
  , 60 * 1000
