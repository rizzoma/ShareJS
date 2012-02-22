renderLinkPopup = require('./template').renderLinkPopup
DomUtils = require('../../utils/dom')

class LinkPopup
    MAX_OFFSET = 50
    constructor: (args...) ->
        $tmpNode = $(document.createElement 'span')
        $tmpNode.append renderLinkPopup()
        @_anchor = $tmpNode.find('.js-link-anchor')[0]
        @_changeButton = $tmpNode.find('.js-link-popup-change')[0]
        @_changeButton.addEventListener 'click', (event) =>
            @_changeCallback() if @_changeCallback
        , false
        @_container = $tmpNode[0].firstChild
        @_container.addEventListener 'mousedown', (event) ->
            event.stopPropagation()
        , false
        @_container.addEventListener 'mouseup', (event) ->
            event.stopPropagation()
        , false
        @_container.addEventListener 'click', (event) ->
            event.stopPropagation()
        , false

    _setText: (text) ->
        $(@_anchor).empty().text(text)

    _setUrl: (url) ->
        @_anchor.href = url

    getContainer: -> @_container

    hide: ->
        @_container.style.display = 'none'
        @_changeCallback = null
        @_lastTop = null
        @_lastLeft = null

    show: (url, relativeTo, @_changeCallback, showAtBottom) ->
        @_setText(url)
        @_setUrl(url)
        [top, left] = DomUtils.getPosition(relativeTo, @_container.parentNode)
        return @hide() if not top? or not left?
        @_container.style.display = 'block'
        relativeHeight = relativeTo.offsetHeight
        $container = $(@_container)
        containerWidth = $container.width()
        containerHeight = $container.height()
        $parent = $(@_container.parentNode)
        parentWidth = $parent.width()
        parentHeight = $parent.height()
        posTop = top + relativeHeight + 4
        if left + containerWidth > parentWidth
            left = parentWidth - containerWidth
        if not showAtBottom and (posTop + containerHeight > parentHeight)
            posTop = top - containerHeight - 4
        if posTop != @_lastTop or Math.abs(left - @_lastLeft) > MAX_OFFSET
            @_lastTop = posTop
            @_lastLeft = left
            @_container.style.top = posTop + 'px'
            @_container.style.left = left + 'px'

    @get: -> @instance ?= new @

exports.LinkPopup = LinkPopup