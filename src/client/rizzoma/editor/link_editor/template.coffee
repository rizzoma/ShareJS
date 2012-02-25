ck = window.CoffeeKup

linkEditorTmpl = ->
    div '.js-link-editor.link-editor.window', ->
        div '.link-editor-name', ->
            span 'Insert link'
            span '.close-icon.js-link-editor-close-btn', ''
        table '.link-editor-content', ->
            tr '.link-name', ->
                td '', 'Text'
                td '', ->
                    label ->
                        input '.js-link-editor-text-input', {type: 'text'}
                    div '.js-link-editor-text-div', ''
            tr '.link-url', ->
                td '', 'URL'
                td '', ->
                    label ->
                        input '.js-link-editor-url-input', {type: 'text'}
            tr '', ->
                td '', ''
                td '', ->
                    button '.js-link-editor-update-btn.button', title: 'Accept changes', 'Submit'
                    button '.js-link-editor-remove-btn.button', title: 'Remove link', 'Remove'

linkPopupTmpl = ->
    div '.js-link-popup.link-popup', ->
        a '.js-link-anchor', {target: '_blank'}
        button '.js-link-popup-change.button', 'Change'

exports.renderLinkEditor = ->
    ck.render linkEditorTmpl

exports.renderLinkPopup = ->
    ck.render linkPopupTmpl