class InlineNodeWrapper
    getNextLeaf: (node) ->
        until node.nextSibling
            node = node.parentNode
            return node unless node
        leaf = node.nextSibling
        while leaf.firstChild
            leaf = leaf.firstChild
        leaf

    getPreviousLeaf: (node) ->
        until node.previousSibling
            node = node.parentNode
            return node unless node
        leaf = node.previousSibling
        while leaf.lastChild
            leaf = leaf.lastChild
        leaf

    wrapNode: (node, attrs) ->
        childNode = node.firstChild;
        return @wrapLeaf node, attrs unless childNode
        while childNode
            nextSibling = childNode.nextSibling
            @wrapNode childNode, attrs
            childNode = nextSibling

    wrapLeaf: (node, attrs) ->
        throw new Error 'Not Implemented'

    wrapLeafFromTo: (node, attrs, from, to) ->
        throw new Error 'Not Implemented'

    wrapNodeFromTo: (node, attrs, from, to) ->
        childNode = node.firstChild;
        return @wrapLeafFromTo node, attrs, from, to unless childNode
        for i in [from...to]
            @wrapNode node.childNodes[i], attrs

#    // If the text content of an element contains white-spaces only, then does not need to colorize
#   IsTextVisible (text) {
#        for (var i = 0; i < text.length; i++) {
#            if (text[i] != ' ' && text[i] != '\t' && text[i] != '\r' && text[i] != '\n')
#                return true;
#        }
#        return false;
#    }

    wrap: (range, attrs) ->
        #TODO: // store the start and end points of the current selection, because the selection will be removed
        startContainer = range.startContainer;
        startOffset = range.startOffset;
        endContainer = range.endContainer;
        endOffset = range.endOffset;
        console.log startContainer, startOffset
        console.log endContainer, endOffset
        # TODO: // because of Opera, we need to remove the selection before modifying the DOM hierarchy

        if startContainer is endContainer
            console.log 'startContainer is endContainer'
            @wrapNodeFromTo startContainer, attrs, startOffset, endOffset
        else
            if startContainer.firstChild
                console.log 'startContainer.firstChild'
                startLeaf = startContainer.childNodes[startOffset]
            else
                console.log 'not startContainer.firstChild'
                startLeaf = @getNextLeaf startContainer
                @wrapLeafFromTo startContainer, attrs, startOffset, -1

            if endContainer.firstChild
                if endOffset > 0
                    console.log 'endOffset > 0'
                    endLeaf = endContainer.childNodes[endOffset - 1]
                else
                    console.log 'endOffset <= 0'
                    endLeaf = @getPreviousLeaf endContainer
            else
                console.log 'not endContainer.firstChild'
                endLeaf = @getPreviousLeaf endContainer
                @wrapLeafFromTo endContainer, attrs, 0, endOffset
            console.log 'leaf', startLeaf, endLeaf
            return
            while startLeaf
                console.log 'while startLeaf', startLeaf
                nextLeaf = @getNextLeaf startLeaf
                @wrapLeaf startLeaf, attrs
                break if startLeaf is endLeaf
                startLeaf = nextLeaf;

exports.InlineNodeWrapper = InlineNodeWrapper
