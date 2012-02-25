ck = window.CoffeeKup

tmpl = (unread_blips) ->
    ###
    Шаблон волны
    ###
    div '.js-wave-panel.wave-panel', ->
        div '.editor-panel', ->
            if !@editable
                div '.editing-disabled-panel', 'Editing is enabled in Chromium and Google Chrome browsers'
            else
                button '.js-undo.undo', title: 'Undo (Ctrl+Z)'
                button '.js-redo.redo', title: 'Redo (Ctrl+Shift+Z, Ctrl+Y)'
                button '.js-make-bold.bold', title: 'Bold (Ctrl+B)'
                button '.js-make-italic.italic', title: 'Italic (Ctrl+I)'
                button '.js-make-underlined.make-underlined', title: 'Underline (Ctrl+U)'
                button '.js-make-struckthrough.make-struckthrough', title: 'Strikethrough'
                button '.js-clear-formatting.clear-formatting', title: 'Clear formatting'
                button '.js-make-bulleted-list.bulleted', title: 'Bulleted list'
                button '.js-manage-link.add-url', title: 'Insert link (Ctrl+L)'
                button '.js-insert-attachment.add-image', title: 'Insert attachment'
        div '.js-wave-error', ''
    div ->
        div {id: 'editor'}, ->

exports.renderContainer = (params = {}) ->
    ck.render tmpl, params