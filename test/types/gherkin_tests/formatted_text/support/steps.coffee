World = require('./world').World
assert = require('assert')
parse = (str) ->
    try
        return JSON.parse(str)
    catch e
        throw new SyntaxError "#{str} is not a proper JSON object"
clone = (o) -> JSON.parse(JSON.stringify(o))

FTextStepsDefinition = ->
    @World = World

    @Given /^server with (.+)$/, (obj, callback) ->
        obj = parse obj
        @createServerDoc (err, serverDoc) =>
            return callback.fail(err) if err
            index = 0
            totalLength = 0
            op =
                v: serverDoc.v
                op: []
                meta: {}
            for block in obj
                op.op.push({p: totalLength, ti: block.t, params: block.params})
                totalLength += block.t.length
            @applyServerOp op, (err) ->
                return callback.fail(err) if err
                callback()

    @Given /^client(\d+)$/, (clientNum, callback) ->
        clientNum--
        @addClient clientNum, (err) ->
            return callback.fail(err) if err
            callback()

    @When /^client(\d+) submits (.+)$/, (clientNum, obj, callback) ->
        clientNum--
        obj = parse(obj)
        try
            @clients[clientNum].doc.submitOp(obj)
        catch e
            return callback.fail(e)
        callback()

    @When /^server receives operation (\d+) from client(\d+)$/, (opNum, clientNum, callback) ->
        clientNum--
        client = @clients[clientNum]
        client.proxy.getSentOp opNum, (op) =>
            op = clone op
            @applyServerOp op, (err, version) =>
                return callback.fail(err) if err
                # Подтверждение получения операции сервером, отсылаемое клиенту
                client.proxy.receiveResponse({doc: @DOC_ID, v: version})
                callback()

    @Then /^server should send (.+) to client(\d+)$/, (obj, clientNum, callback) ->
        clientNum--
        obj = parse obj
        client = @clients[clientNum]
        client.proxy.getReceivedOp (op) =>
            try
                assert.deepEqual op.op, obj
            catch e
                return callback.fail(e)
            client.doc._onMessage op
            callback()

    @Then /^everyone should have (.+)$/, (obj, callback) ->
        obj = parse obj
        for client, idx in @clients
            try
                assert.deepEqual client.doc.snapshot, obj
            catch e
                e.message = "For client#{idx + 1}:\n#{e.message}"
                return callback.fail(e)
        @getServerDoc (err, doc) ->
            return callback.fail(err) if err
            try
                assert.deepEqual doc.snapshot, obj
            catch e
                e.message = "For server:\n#{e.message}"
                return callback.fail(e)
            callback()

    @Then /^server should have (.+)$/, (obj, callback) ->
        obj = parse obj
        @getServerDoc (err, doc) ->
            return callback.fail(err) if err
            try
                assert.deepEqual doc.snapshot, obj
            catch e
                return callback.fail(e)
            callback()

    @Then /^client(\d+) should have (.+)$/, (clientNum, obj, callback) ->
        clientNum--
        obj = parse obj
        try
            assert.deepEqual @clients[clientNum].doc.snapshot, obj
        catch e
            return callback.fail(e)
        callback()

module.exports = FTextStepsDefinition
