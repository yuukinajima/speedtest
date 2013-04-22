module.exports = 
  mongodb:
    database: "speedtest"
    user: "test"
    password: "testtest"
    replset: [
      host: "speedtest.m0.mongolayer.com",
      port: "27017"
    ,
      host: "speedtest.m1.mongolayer.com",
      port: "27017"
    ]
  redis:
    host: "127.0.0.1"
    port: 6379
    db: 1
