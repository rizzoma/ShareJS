req = (path) ->
    require('../../../../../' + path)
Model = req('src/server/model')
Doc = req('src/client/doc').Doc
NetworkProxy = require('./network_proxy').NetworkProxy
types = req('src/types')
clone = (o) -> JSON.parse(JSON.stringify(o))


class World
    DOC_TYPE: 'ftext'
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
            return callback(err) if err
            callback(null, v)

    addClient: (clientNum, callback) ->
        @getServerDoc (err, doc) =>
            return callback(err) if err
            @clients[clientNum] = client = {}
            client.proxy = new NetworkProxy(clientNum)
            docData =
                v: doc.v
                snaphot: clone doc.snapshot
                type: @DOC_TYPE
            client.doc = new Doc(client.proxy, @DOC_ID, docData)
            client.proxy.doc = client.doc
            @server.listen @DOC_ID, doc.v, client.proxy.receive, (err) ->
                return callback(err) if err
                callback(null)


module.exports.World = (callback) -> callback(new World)