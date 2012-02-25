ck = window.CoffeeKup

editorTmpl = ->
    div '.editor', {contentEditable: @isEditable.toString(), spellcheck: 'false'}, ''

exports.renderEditor = (params) ->
    ck.render editorTmpl, params
