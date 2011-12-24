###
Текстовые операции с форматированием.
Документ представляется в виде:
[
    {
        t: "Фрагмент жирный"
        params:
            bold: true
            font-size: 14
    }
    {
        t: "Фрагмент наклонный"
        params: {italic: true}
    }
]

Параметры представляется парами ключ-значение и могут только заменяться.

Доступные операции:
    * вставка текста
        p: 9                    # Позиция, в которую будет вставляться текст
        t: "жирный"             # Вставляемый текст
        params:                 # Параметры вставляемого текста
            bold: true
            font-size: 14    
    * удаление текста
        p: 8                    # Позиция, с которой начинается удаляемый текст
        t: "Фрагмент"           # Удаляемый текст (нужен для инвертирования операции)
        params: {italic: true}  # Параметры удаляемого текста (нужны для инвертирования операции
    * вставка форматирования
        p: 5                    # Позиция, с которой начинается изменение форматирования
        fc: 4                   # Количество символов, для которых изменяется форматирование
        paramsi:                # Добавляемый параметр (не более одного за операцию)
            font: 14
    * удаление форматирования
        p: 5                    # Позиция, с которой начинается изменение форматирования
        fc: 4                   # Количество символов, для которых изменяется форматирование
        paramsd:                # Удаляемые параметры (не более одного за операцию)
            bold: true

Трансформации вставки текста и удаления текста между собой очевидны, их
поведение скопировано со строковых операций из ShareJS.
Операция вставки текста при трансформации против совершенной операции изменения
параметров не меняется, то есть она не получает новых параметров.
Следовательно, операция изменения параметров при трансформации против
совершенной операции вставки не меняется либо разбивается на две операции.
Операция удаления текста при трансформации против совершенной операции
изменения параметров изменяет свои параметры, чтобы иметь возможность быть
примененной.
Операция изменения параметров при трансформации против совершенной операции
удаления изменяет свои позицию и длину.
Наконец, взаимная трансформации двух операций изменения параметров не меняет
ничего, если они оперируют разными параметрами. Если они выполняют одно и
то же изменение, то одна из операций будет уменьшена либо убрана совсем. Если
обе операции изменяют один и тот же параметр, но в разные значения, то одна из
операций будет уменьшена (на серверной стороне решение принимается в пользу
приходящей операции, на клиентской - в пользу уже совершенной).

По всему коду приняты следующие обозначения:
    p, pos: позиция, отсчитываемая от начала документа
    offset: позиция, отсчитываемая от начала блока форматирования
    index: индекс блока с форматированием
В операциях приняты обозначения:
    t: текст, противопоставляется оригинальному s - string 
    params: параметры, привязанные к тексту
    i: insert, вставка
    d: delete, удаление
    p: позиция, отсчитываемая от начала документа
    len: длина, указывается только для операций, в которых не может быть вычислена
###

clone = (o) -> JSON.parse(JSON.stringify o)

class FormattedText
    _getBlockAndOffset: (snapshot, p) ->
        ###
        Возвращает индекс блока, содержащего символ с номером p, и смещение
        искомого символа внутри этого блока 
        @param snapshot: formatted text snapshot
        @param p: int
        @return: [int, int] - индекс блока и смещение внутри блока
        ###
        totalLen = 0
        for block, index in snapshot
            return [index, p - totalLen] if totalLen + block.t.length > p
            totalLen += block.t.length
        if p > totalLen
            throw new Error "Specified position (#{p}) is more then text length (#{totalLen})" 
        return [snapshot.length, p - totalLen]
    
    _paramsAreEqual: (first, second) ->
        ###
        Возвращает true, если переданный объекты форматирования совпадают
        @param first: object
        @param second: object
        @return: boolean
        ###
        _secondHasFirst = (first, second) ->
            for key of first
                return false if not second[key]?
                return false if first[key] isnt second[key]
            true
        return false if not _secondHasFirst(first, second)
        return false if not _secondHasFirst(second, first)
        true
    
    _splitBlock: (block, offset) ->
        ###
        Разбивает указанный блок
        @param block: Formatted text block
        @param offset: int
        @return: [Formatted text block]
        ###
        return [block] if offset is 0
        newBlock = clone block
        block.t = block.t.substr(0, offset)
        newBlock.t = newBlock.t.substr(offset)
        return [block, newBlock]
    
    _tryMerge: (snapshot, startIndex, endIndex) ->
        ###
        Пробует слить все смежные блоки с одинаковым форматированием между
        startIndex и endIndex включительно.
        Изменяет snapshot.
        startIndex должен быть меньше endIndex.
        Позволяется указывать startIndex < 0 и endIndex > snapshot.length - 1
        @param snapshot: [Formatted text block]
        @param startIndex: int
        @param endIndex: int
        ###
        startIndex = Math.max(startIndex, 0)
        endIndex = Math.min(endIndex, snapshot.length - 1)
        i = endIndex - 1
        while i >= startIndex
            first = snapshot[i]
            second = snapshot[i+1]
            if @_paramsAreEqual(first.params, second.params)
                snapshot[i+1..i+1] = []
                first.t += second.t
            i--
    
    _applyTextInsert: (snapshot, op) =>
        snapshot = clone snapshot
        [blockIndex, offset] = @_getBlockAndOffset(snapshot, op.p)
        if snapshot.length is blockIndex
            snapshot.push {t: op.ti, params: op.params}
            @_tryMerge(snapshot, blockIndex-1, blockIndex)
            return snapshot
        block = snapshot[blockIndex]
        if @_paramsAreEqual(block.params, op.params)
            # Формат совпадает, просто вставим текст
            block.t = block.t.substr(0, offset) + op.ti + block.t.substr(offset)
        else
            # Формат не совпадает, разобьем блок и вставим новый
            blocks = @_splitBlock(block, offset)
            newBlock =
                t: op.ti
                params: op.params
            blocks[blocks.length-1...blocks.length-1] = newBlock
            snapshot[blockIndex..blockIndex] = blocks
            @_tryMerge(snapshot, blockIndex-1, blockIndex)
        return snapshot
    
    _applyTextDelete: (snapshot, op) =>
        snapshot = clone snapshot
        [blockIndex, offset] = @_getBlockAndOffset(snapshot, op.p)
        block = snapshot[blockIndex]
        if not @_paramsAreEqual(block.params, op.params)
            throw new Error "Text block params (#{JSON.stringify(block.params)}) do not equal to op params (#{JSON.stringify(op.params)})"
        blockText = block.t.substr(offset, op.td.length)
        if blockText isnt op.td
            throw new Error "Deleted text (#{blockText}) is not equal to text in operation (#{op.td})"
        block.t = block.t.substr(0, offset) + block.t.substr(offset + op.td.length)
        if not block.t
            snapshot[blockIndex..blockIndex] = []
            @_tryMerge(snapshot, blockIndex-1, blockIndex)
        return snapshot
    
    _getFirstParam: (params) ->
        ###
        Возвращает [key, value] для первого ключа из params
        @param params: object
        @return: [string, any]
        ###
        for name, value of params
            return [name, value]
    
    _deleteParams: (params, toDelete) ->
        [name, value] = @_getFirstParam(toDelete)
        if params[name] isnt value
            throw new Error "Params delete tried to remove param #{name} with value #{value} from #{JSON.stringify(params)}, but it does not match"
        delete params[name]
    
    _applyParamsDelete: (snapshot, op) =>
        if Object.keys(op.paramsd).length != 1
            throw new Error "Exactly one param should be deleted: #{JSON.stringify(op)}"
        transformBlock = (block) =>
            @_deleteParams(block.params, op.paramsd)
        @_changeParams(snapshot, op.p, op.len, transformBlock)

    _insertParams: (params, toInsert) ->
        [name, value] = @_getFirstParam(toInsert)
        if params[name]?
            throw new Error "Params insert tried to set param #{name} with value #{value} to block #{JSON.stringify(params)}, but it is already set"
        params[name] = value

    _applyParamsInsert: (snapshot, op) =>
        if Object.keys(op.paramsi).length != 1
            throw new Error "Exactly one param should be inserted: #{JSON.stringify(op)}"
        transformBlock = (block) =>
            @_insertParams(block.params, op.paramsi)
        @_changeParams(snapshot, op.p, op.len, transformBlock)
    
    _changeParams: (snapshot, p, len, transformBlock) =>
        ###
        Применяет операцию изменения параметров на диапазоне
        Разбивает при необходимости существующие блоки
        Ко всем блокам, попадающим в диапазон, применяет transformBlock
        Сливает блоки после изменения форматирования
        @param snapshot: any data
        @param p: int, позиция начала изменения параметров от начала документа
        @param len: int, длина диапазона изменения параметров
        @param transformBlock: function, функция, изменяющая параметры
        ###
        snapshot = clone snapshot
        [startBlockIndex, startOffset] = @_getBlockAndOffset(snapshot, p)
        [endBlockIndex, endOffset] = @_getBlockAndOffset(snapshot, p + len)
        if endOffset is 0
            endBlockIndex--
        else
            snapshot[endBlockIndex..endBlockIndex] = @_splitBlock(snapshot[endBlockIndex], endOffset)
        if startOffset > 0
            snapshot[startBlockIndex..startBlockIndex] = @_splitBlock(snapshot[startBlockIndex], startOffset)
            startBlockIndex++
            endBlockIndex++
        transformBlock(snapshot[i]) for i in [startBlockIndex..endBlockIndex]
        @_tryMerge(snapshot, startBlockIndex-1, endBlockIndex+1)
        snapshot
    
    _transformPosAgainstInsert: (p, start, len, shiftIfEqual) ->
        ###
        Изменяет позицию p с учетом того, что в позицию start была вставлена
        строка длины len
        @param p: int
        @param start: int
        @param len: int
        @param shiftIfEqual: boolean, сдвигать ли p при p == start
        @return: int
        ###
        return p if start > p
        return p if start == p and not shiftIfEqual
        return p + len
    
    _transformPosAgainstDelete: (p, start, len) ->
        ###
        Изменяет позицию p с учетом того, что из позиции start была удалена
        строка длины len
        @param p: int
        @param start: int
        @param len: int
        @return: int
        ###
        return p - len if p > start + len
        return start if p > start
        return p

    _transformTiAgainstTi: (dest, op1, op2, type) =>
        op1 = clone op1
        op1.p = @_transformPosAgainstInsert(op1.p, op2.p, op2.ti.length, type is 'right')
        dest.push op1
        dest

    _transformTiAgainstTd: (dest, op1, op2) =>
        op1 = clone op1
        op1.p = @_transformPosAgainstDelete(op1.p, op2.p, op2.td.length)
        dest.push op1
        dest
    
    _transformTdAgainstTi: (dest, op1, op2) =>
        stringToDelete = op1.td
        if op1.p < op2.p
            dest.push 
                p: op1.p
                td: stringToDelete[...op2.p - op1.p]
                params: clone op1.params
            stringToDelete = stringToDelete[(op2.p - op1.p)..]
        if stringToDelete
            dest.push
                p: op1.p + op2.ti.length
                td: stringToDelete
                params: clone op1.params
        dest
    
    _transformTdAgainstTd: (dest, op1, op2) =>
        if op1.p >= op2.p + op2.td.length
            dest.push
                p: op1.p - op2.td.length
                td: op1.td
                params: clone op1.params
        else if op1.p + op1.td.length <= op2.p
            dest.push clone op1
        else
            if not @_paramsAreEqual(op1.params, op2.params)
                throw new Error "Two text delete operations overlap but have different params: #{JSON.stringify(op1)}, #{JSON.stringify(op2)}"
            intersectStart = Math.max(op1.p, op2.p)
            intersectEnd = Math.min(op1.p + op1.td.length, op2.p + op2.td.length)
            op1Intersect = op1.td[intersectStart - op1.p...intersectEnd - op1.p]
            op2Intersect = op2.td[intersectStart - op2.p...intersectEnd - op2.p]
            if op1Intersect isnt op2Intersect
                throw new Error "Delete ops delete different text in the same region of the document: #{JSON.stringify(op1)}, #{JSON.stringify(op2)}"

            newOp = 
                td: ''
                p: op1.p
                params: clone op1.params
            if op1.p < op2.p
                newOp.td = op1.td[...(op2.p - op1.p)]
            if op1.p + op1.td.length > op2.p + op2.td.length
                newOp.td += op1.td[(op2.p + op2.td.length - op1.p)..]
            if newOp.td
                newOp.p = @_transformPosAgainstDelete(newOp.p, op2.p, op2.td.length)
                dest.push newOp
        dest
    
    _transformTiAgainstParamsChange: (dest, op1, op2) =>
        dest.push clone op1
        dest
    
    _transformParamsChangeAgainstTi: (dest, op1, op2) =>
        lenToChange = op1.len
        if op1.p < op2.p
            lenBeforeInsert = Math.min(lenToChange, op2.p - op1.p)
            newOp = clone op1
            newOp.len = lenBeforeInsert
            dest.push newOp
            lenToChange -= lenBeforeInsert
        if lenToChange
            newOp = clone op1
            newOp.p = Math.max(op2.p, op1.p) + op2.ti.length
            newOp.len = lenToChange
            dest.push newOp
        dest
    
    _transformTdAgainstParamsChange: (dest, op1, op2, transformParams) =>
        ###
        Трансформирует операцию удаления текста против операции изменения
        параметров
        @param dest: array
        @param op1: text delete OT operation
        @param op2: paramsi or paramsd OT operation
        @param transformParams: function, функция, изменяющая параметры соответственно op2
            transformParams(params, op2)
        @return: dest
        ###
        if (op1.p >= op2.p + op2.len) or (op1.p + op1.td.length <= op2.p)
            # Диапазоны изменяемых символов не пересекаются
            dest.push clone op1
            return dest
        
        # Операция изменяется, при этом может разбиться на 2 или 3 части
        # или не разбиваться
        strToDelete = op1.td
        if op1.p < op2.p
            # Удаляемая часть слева, которую не задело форматирование
            newOp = clone op1
            newOp.td = strToDelete[...op2.p - op1.p]
            dest.push newOp
            strToDelete = strToDelete[op2.p - op1.p...]
        
        # Удаляемая часть, которую задело форматирование
        newOp = clone op1
        commonLen = op2.p + op2.len - Math.max(op2.p, op1.p)
        newOp.td = strToDelete[...commonLen]
        transformParams(newOp.params, op2)
        strToDelete = strToDelete[commonLen...]
        dest.push newOp
        
        if strToDelete
            # Удаляемая часть справа, которую не задело форматирование
            newOp = clone op1
            newOp.td = strToDelete
            dest.push newOp
        dest
    
    _transformParamsChangeAgainstTd: (dest, op1, op2) =>
        if op1.p >= op2.p + op2.td.length
            newOp = clone op1
            op1.p -= op2.td.length
            dest.push newOp
        else if op1.p + op1.len <= op2.p
            dest.push clone op1
        else
            newOp = clone op1
            newOp.len = 0
            if op1.p < op2.p
                newOp.len = Math.min(op1.len, op2.p - op1.p)
            if op1.p + op1.len > op2.p + op2.td.length
                newOp.len += (op1.p + op1.len) - (op2.p + op2.td.length)
            if newOp.len
                newOp.p = @_transformPosAgainstDelete(newOp.p, op2.p, op2.td.length)
                dest.push newOp
        dest

    _transformTiAgainstParamsi: (args...) => @_transformTiAgainstParamsChange(args...)
    _transformTiAgainstParamsd: (args...) => @_transformTiAgainstParamsChange(args...)
    _transformParamsiAgainstTi: (args...) => @_transformParamsChangeAgainstTi(args...)
    _transformParamsdAgainstTi: (args...) => @_transformParamsChangeAgainstTi(args...)
    _transformTdAgainstParamsi: (dest, op1, op2) =>
        @_transformTdAgainstParamsChange dest, op1, op2, (params, op) =>
            @_insertParams(params, op.paramsi)
    _transformTdAgainstParamsd: (dest, op1, op2) =>
        @_transformTdAgainstParamsChange dest, op1, op2, (params, op) =>
            @_deleteParams(params, op.paramsd)
    _transformParamsiAgainstTd: (args...) => @_transformParamsChangeAgainstTd(args...)
    _transformParamsdAgainstTd: (args...) => @_transformParamsChangeAgainstTd(args...)
    
    _transformParamsiAgainstParamsd: (dest, op1, op2) =>
        dest.push clone op1
        dest

    _transformParamsdAgainstParamsi: (dest, op1, op2) =>
        dest.push clone op1
        dest
    
    _revertParamsChange: (op) =>
        ###
        Возвращает операцию, обратную операции форматирования
        @param op: OT operation
        @return: OT operation
        ###
        res =
            p: op.p
            len: op.len
        res.paramsd = op.paramsi if op.paramsi?
        res.paramsi = op.paramsd if op.paramsd?
        res

    _transformParamsChangeAgainstParamsChange: (dest, op1, op2, type, firstName, firstValue, secondName, secondValue) =>
        ###
        Трансформирует операцию изменения параметров относительно уже
        совершенной операции изменения параметров.
        @param dest: array
        @param op1: text delete OT operation
        @param op2: paramsi or paramsd OT operation
        @param type: 'left' or 'right'
        @param firstName: string, имя параметра, изменяемого первой операцией
        @param secondName: string, имя параметра, изменяемого второй операцией
        @return: dest
        ###
        if (op1.p >= op2.p + op2.len) or
            (op1.p + op1.len <= op2.p) or
            (firstName isnt secondName)
                # Диапазоны изменяемых символов не пересекаются либо операции
                # производятся над разными параметрами либо новая операция
                # должна быть применена в любом случае
                dest.push clone op1
                return dest
        
        if op1.p < op2.p
            # Часть изменения форматирования слева
            newOp = clone op1
            newOp.len = op2.p - op1.p
            dest.push newOp
        
        if (type is 'left' and firstValue isnt secondValue)
            # Нужно отменить старое форматирование и применить новое
            commonEnd = Math.min(op2.p + op2.len, op1.p + op1.len)
            commonStart = Math.max(op1.p, op2.p)
            cancelOp = @_revertParamsChange(op2)
            newOp = clone op1
            newOp.p = cancelOp.p = commonStart
            newOp.len = cancelOp.len = commonEnd - commonStart
            dest.push cancelOp
            dest.push newOp
        
        if op1.p + op1.len > op2.p + op2.len
            # Часть изменения форматирования справа
            newOp = clone op1
            newOp.p = op2.p + op2.len
            newOp.len = (op1.p + op1.len) - (op2.p + op2.len)
            dest.push newOp
        dest

    _transformParamsiAgainstParamsi: (dest, op1, op2, type) =>
        [firstName, firstValue] = @_getFirstParam(op1.paramsi)
        [secondName, secondValue] = @_getFirstParam(op2.paramsi)
        @_transformParamsChangeAgainstParamsChange(dest, op1, op2, type, firstName, firstValue, secondName, secondValue)

    _transformParamsdAgainstParamsd: (dest, op1, op2, type) =>
        [firstName, firstValue] = @_getFirstParam(op1.paramsd)
        [secondName, secondValue] = @_getFirstParam(op2.paramsd)
        @_transformParamsChangeAgainstParamsChange(dest, op1, op2, type, firstName, firstValue, secondName, secondValue)
    
    _getOpType: (op) ->
        ###
        Возвращает текстовое представление типа операции
        @param op: OT operation
        @return: string
        ###
        return "Ti" if op.ti?
        return "Td" if op.td?
        return "Paramsi" if op.paramsi?
        return "Paramsd" if op.paramsd?

    _getTransformFunction: (op1, op2) ->
        name = "_transform#{@_getOpType(op1)}Against#{@_getOpType(op2)}"
        return @[name]
    
    name: "text-formatted"
    
    create: ->
        ###
        Создает новый документ
        @return: []
        ###
        []

    apply: (snapshot, ops) ->
        ###
        Применяет массив операций
        @param snapshot: any data
        @param ops: [OT operation]
        @return: any data, new snapshot
        ###
        snapshot = @applyOp(snapshot, op) for op in ops
        snapshot
        
    applyOp: (snapshot, op) ->
        return @_applyTextInsert(snapshot, op) if op.ti?
        return @_applyTextDelete(snapshot, op) if op.td?
        return @_applyParamsInsert(snapshot, op) if op.paramsi?
        return @_applyParamsDelete(snapshot, op) if op.paramsd?
        throw new Error "Unknown operation applied: #{JSON.stringify op}"
        
    transform: (ops1, ops2, type) ->
        ###
        Преобразует операции ops1 при условии, что были применены ops2.
        Возвращает преобразованные ops1.
        @param ops1: [object], array of OT operations
        @param ops2: [object], array of OT operations
        @param type: string, 'left' или 'right'
        @return: [object], array of OT operations
        ###
        res = clone ops1
        for op2 in ops2
            tmpDest = []
            @transformOp(tmpDest, op1, op2, type) for op1 in res
            res = tmpDest
        return res

    transformOp: (dest, op1, op2, type) ->
        ###
        Преобразует op1 при условии, что была применена op2
        @param dest: array
        @param op1: OT operation
        @param op2: OT operation
        @param type: string, 'left' или 'right'
        @return: dest
        ###
        func = @_getTransformFunction(op1, op2)
        func(dest, op1, op2, type)

    compose: (ops1, ops2) ->
        ###
        Объединяет несколько операций
        @param ops1: [OT operation]
        @param ops2: [OT operation]
        ###
        res = []
        res[0...0] = ops1
        res[res.length...res.length] = ops2
        res
    
    isFormattedTextOperation: (op) ->
        ###
        Возвращает true, если указанная операция является операцией над текстом
        с форматированием
        @param op: OT operation
        @return: boolean
        ###
        op.td? or op.ti? or op.paramsd? or op.paramsi?
    
    _invertOp: (op) ->
        ###
        Инвертирует операцию
        @param op: OT operation
        @return: OT operation
        ###
        res = {}
        res.p = op.p
        res.params = clone op.params if op.params?
        res.ti = clone op.td if op.td?
        res.td = clone op.ti if op.ti?
        res.paramsi = clone op.paramsd if op.paramsd?
        res.paramsd = clone op.paramsi if op.paramsi?
        res.len = clone op.len if op.len?
        res
    
    invert: (ops) ->
        ###
        Инвертирует операции
        @param ops: [OT operation]
        @return: [OT operation]
        ###
        res = (@_invertOp(op) for op in ops)
        res.reverse()
        return res

if WEB?
    exports.types ||= {}
    exports.types.ftext = new FormattedText()
else
    module.exports = new FormattedText()
