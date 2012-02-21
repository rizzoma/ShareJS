DomUtils = require('../../utils/dom')
InlineNodeWrapper = require('./inline_node_wrapper').InlineNodeWrapper

class AnchorNodeWrapper extends InlineNodeWrapper
    _createAnchorNode: (attrs) ->
        link = document.createElement DomUtils.ANCHOR_TAG
        for key, attr of attrs
            link[key] = attr
        console.log link
        link

    wrapLeaf: (node, attrs) ->
        return unless node or node.parentNode
        console.log 'wrapLeaf'
#        if (!IsTextVisible (node.textContent))
#            return;
        console.log node, node.parentNode
        parentNode = node.parentNode;
        # TODO:  if the node does not have siblings and the parent is a span element, then modify its color
#        if (!node.previousSibling && !node.nextSibling) {
#            if (parentNode.tagName.toLowerCase () == "span") {
#                parentNode.style.color = color;
#                return;
#            }
#        }
        nextSibling = node.nextSibling
        console.log 'nextSibling', nextSibling
        link = @_createAnchorNode attrs
        parentNode.removeChild (node);
        link.appendChild node
        parentNode.insertBefore link, nextSibling

    wrapLeafFromTo: (node, attrs, from, to) ->
        return unless node or node.parentNode
        console.log 'wrapLeafFromTo'
        text = node.textContent;
#        if (!IsTextVisible (text))
#            return;

        from = 0 if from < 0
        to = text.length if to < 0

        if from == 0 and to >= text.length
            # TODO: // to avoid unnecessary span elements
            return @wrapLeaf node, attrs
        part1 = text.substring 0, from
        part2 = text.substring from, to
        part3 = text.substring to, text.length

        parentNode = node.parentNode;
        nextSibling = node.nextSibling;

        parentNode.removeChild node
        if part1.length > 0
            textNode = document.createTextNode part1
            parentNode.insertBefore textNode, nextSibling
        if part2.length > 0
            link = @_createAnchorNode attrs
            textNode = document.createTextNode part2
            link.appendChild textNode
            parentNode.insertBefore link, nextSibling
        if part3.length > 0
            textNode = document.createTextNode part3
            parentNode.insertBefore textNode, nextSibling

    wrap: (range, url) ->
        super range, {href: url, target: '_blank'}

exports.AnchorNodeWrapper = AnchorNodeWrapper