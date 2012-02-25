DomUtils = require('../../utils/dom')

class HtmlSelectionHelper
    ###
    Вспомогательный класс для работы с выделениями
    ###

    constructor: (args...) ->
        @_init args...

    _init: (@_container) ->

    _isFullyInside: (selection, node) ->
        ###
            Check that current selection is fully inside node
        ###
        anchorNode = selection.anchorNode
        focusNode = selection.focusNode
        (anchorNode is node or DomUtils.contains(node, anchorNode)) and
                (focusNode is node or DomUtils.contains(node, anchorNode))

    _isNodeInChildEditorOrNonEditableNode: (node) ->
        node = if DomUtils.isTextNode(node) then node.parentNode else node
        while node? and node isnt @_container
            if node.hasAttribute('contentEditable')
                return yes
            node = node.parentNode
        no

    _isInChildEditorOrNonEditableNode: (selection) ->
        if selection.isCollapsed
            @_isNodeInChildEditorOrNonEditableNode(selection.anchorNode)
        else
            @_isNodeInChildEditorOrNonEditableNode(selection.anchorNode) or
                    @_isNodeInChildEditorOrNonEditableNode(selection.focusNode)

    getSelection: ->
        selection = window.getSelection()
        # Check if selection is insideChildEditor, non-editrable elements
        if(not selection? || not @_isFullyInside(selection, @_container) || @_isInChildEditorOrNonEditableNode(selection))
            return null
        selection

    getRange: ->
        selection = @getSelection()
        return null if not selection or not selection.rangeCount
        selection.getRangeAt(0)

exports.HtmlSelectionHelper = HtmlSelectionHelper