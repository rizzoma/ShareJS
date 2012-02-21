DomUtils = require('../../utils/dom')
AnchorNodeWrapper = require('../selection/anchor_wrapper').AnchorNodeWrapper
renderLinkEditor = require('./template').renderLinkEditor

class LinkEditor
    constructor: ->
        $(document.body).append renderLinkEditor()
        @_$container = $ '.js-link-editor'
        @_currentRange = null
        @_$textInput = $ '.js-link-editor-text-input'
        @_$textDiv = $ '.js-link-editor-text-div'
        @_hide()
        @_$urlInput = $ '.js-link-editor-url-input'
        @_$textInput.bind 'keydown', @_keyHandler
        @_$urlInput.bind 'keydown', @_keyHandler
        $('.js-link-editor-update-btn').bind 'click', @_update
        $('.js-link-editor-remove-btn').bind 'click', @_remove
        $('.js-link-editor-close-btn').bind 'click', @_close

    @get: -> @instance ?= new @

    _normalizeLink: (link) ->
        return 'http://' + link unless /^[a-zA-Z0-9\-]+:/.test(link)
        link

    _hide: ->
        @_$container.offset
            left: -1000
            top: -1000
        @_$textInput.hide()
        @_$textDiv.hide()

    _clear: ->
        @_$textInput.val ''
        @_$urlInput.val ''
        @_currentRange.detach() if @_currentRange
        @_currentRange = null

    _update: =>
        ###
        Обработчик нажатия кнопки Update
        ###
        url = @_$urlInput.val()
        return @_remove() unless url
        url = @_normalizeLink url
        DomUtils.setRange(@_currentRange)
        @_editor.markLink(url)
        @_close()

    _remove: =>
        ###
        Обработчик нажатия кнопки Remove
        ###
        DomUtils.setRange(@_currentRange)
        @_editor.markLink(null)
        @_close()

    _keyHandler: (event) =>
        ###
        Обработчик клавиатурных событий keypress, keydown
        @param node: Event | KeyEvent
        ###
        if event.keyCode is 13
            @_update()
            return event.preventDefault()
        if event.keyCode is 27
            @_close()
            return event.preventDefault()

    _clickHandler: (event) =>
        @_close() if not $.contains @_$container[0], event.target

    _close: =>
        @_hide()
        window.removeEventListener 'mousedown', @_clickHandler, true

    _isLinkNode: (node) ->
        DomUtils.isAnchorNode(node) and node.parentNode?.parentNode is @_editor.getContainer()

    _getLinkNode: (node) ->
        while node isnt @_editor.getContainer()
            return node if @_isLinkNode(node)
            node = node.parentNode
        null

    _expandRangeStartToAnchor: (range) ->
        # Расширяет начало выделения
        node = @_getLinkNode(range.startContainer)
        while node
            return if not @_isLinkNode(node)
            range.setStart(DomUtils.getDeepestFirstChild(node), 0)
            node = node.previousSibling

    _expandRangeEndToAnchor: (range) ->
        # Расширяет конец выделения
        node = @_getLinkNode(range.endContainer)
        while node
            return if not @_isLinkNode(node)
            textNode = DomUtils.getDeepestLastChild(node)
            range.setEnd(textNode, textNode.data.length)
            node = node.nextSibling

    _expandRange: (range) ->
        # Если концы выделения попадают на границу ссылки и инлайн элемента, но ссылка при этом визуально не выделена,
        # то хром скидывает ссылку в начало/конец текстовой ноды ссылки для конца/начала выделения, т.е. фактическое
        # но редактор расширит это выделение до полной ссылки. учитывая тот факт, что инлайн-элементы не оборачиваются
        # в ссылки, то это поведение можно считать более и менее правильным
        return null if not range
        range = range.cloneRange()
        @_expandRangeStartToAnchor range
        @_expandRangeEndToAnchor range
        range

    _getFirstAnchor: ->
        editorAnchors = $(@_editor.getContainer()).find 'a'
        for anchor in editorAnchors
            continue unless @_isLinkNode(anchor)
            range = document.createRange()
            textStart = DomUtils.getDeepestFirstChild(anchor)
            textEnd = DomUtils.getDeepestLastChild(anchor)
            range.selectNode(anchor)
            range.setStart(textStart, 0) if textStart and DomUtils.isTextNode(textStart)
            range.setEnd(textEnd, textEnd.data.length) if textEnd and DomUtils.isTextNode(textEnd)
            startPoints = @_currentRange.compareBoundaryPoints Range.START_TO_START, range
            endPoints = @_currentRange.compareBoundaryPoints Range.END_TO_END, range
            return anchor if (not startPoints and not endPoints) or
                    ((startPoints or endPoints) and (startPoints*endPoints <= 0))
        null

    _getUrlFromSelection: ->
        anchor = @_getFirstAnchor()
        return '' unless anchor
        anchor.href

    _setText: (text) ->
        @_$textInput.val text
        @_$textDiv.text text

    _setUrl: (url) ->
        @_$urlInput.val url

    open: (@_editor) ->
        ###
        Показывает окно редактирования url
        @param editor: Editor, объект, в котором редактируется ссылка
        @param range: DOM range, выделенный фрагмент
        ###
        @_clear()
        range = @_expandRange(@_editor.getRange())
        return if not range
        return if range.collapsed
        @_currentRange = range.cloneRange()
#        if DomUtils.isTextNode range.startContainer
#            posNode = document.createElement 'span'
#            @_currentRange.insertNode posNode
#            offset = $(posNode).offset()
#            @_currentRange.setStart posNode.nextSibling, 0
#            posNode.parentNode.removeChild posNode
#        else
#            offset = $(range.startContainer).offset()
#        offset.top += 15
#        @_editor.offset offset
        @_$container.center()
        currentText = @_currentRange.toString()
        @_setText currentText
        if currentText == ''
            @_$textInput.show()
        else
            @_$textDiv.show()
        @_setUrl @_getUrlFromSelection()
        window.addEventListener 'mousedown', @_clickHandler, false
        @_$urlInput.select()

exports.LinkEditor = LinkEditor