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
  d = Date.now()
  fn = ()->
    l = new mongo.log
      uuid:"uuid"
      event:"event"
      time: d
      attr:
        a:[1,2,3]
      userattr:
        b:1
        c:2
    l.save e
  setInterval fn, 3
