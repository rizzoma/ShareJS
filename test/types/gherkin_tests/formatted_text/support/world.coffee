req = (path) ->
    require('../../../../../' + path)
Model = req('src/server/model')
Doc = req('src/client/doc').Doc
NetworkProxy = require('./network_proxy').NetworkProxy
types = req('src/types')

class World
    DOC_TYPE: 'text-formatted'
    DOC_ID: 'test'

    constructor: ->
        @server = new Model()
        @clients = []

    createServerDoc: (callback) ->
        @server.create @DOC_ID, @DOC_TYPE, {}, (err) =>
            return callback(err) if err
            @getServerDoc callback

    getServerDoc: (callback) ->
        @server.getSnapshot @DOC_ID, callback

    applyServerOp: (op, callback) ->
        @server.applyOp @DOC_ID, op, (err, v) ->
            console.error "Here is error" if err
            return callback(err) if err
            callback(null, v)

    addClient: (clientNum, callback) ->
        @getServerDoc (err, doc) =>
            return callback(err) if err
            @clients[clientNum] = client = {}
            client.proxy = new NetworkProxy(clientNum)
            client.doc = new Doc(client.proxy, @DOC_ID, doc.v, types[@DOC_TYPE], doc.snapshot)
            @server.listen @DOC_ID, doc.v, client.proxy.receive, (err) ->
                return callback(err) if err
                callback(null)


module.exports.World = (callback) -> callback(new World)