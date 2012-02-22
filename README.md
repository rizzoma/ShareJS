ShareJS with text-formatted document type
=======

Original project is Joseph Gentle's [`ShareJS`](https://github.com/josephg/ShareJS)

This branch adds data type for formatted text.

The document is represented as:

    [
        {
            t: "A fragment of a fat"
            params:
                bold: true
                font-size: 14
        }
        {
            t: "Fragment of an inclined"
            params: {italic: true}
        }
    ]

Parameters is key-value pairs and can only be replaced.

Available actions:

    * Insert text
        p: # 9 position, which will be inserted into the text
        t: "bold" pasted text
        params: # Options pasted text
            bold: true
            font-size: 14
    * Removal of text
        p: 8 # The position at which to start the deleted text
        t: "Fragment" Exhaust text (need to invert the operation)
        params: {italic: true} # Options to delete the text (need to invert the operation
    * Insert format
        p: # 5 position, which begins with a change in format
        fc: 4 # Number of characters for which the format is changed
        paramsi: # parameter is added (no more than one per transaction)
            font: 14
    * Remove formatting
        p: # 5 position, which begins with a change in format
        fc: 4 # Number of characters for which the format is changed
        paramsd: # Removed settings (no more than one per transaction)
            bold: true

Transformation of the text insertion and deletion of text to each other are obvious, they
copied from the behavior of the string operations ShareJS.
The operation insert text in the transformation perfectly against the change operation
parameters does not change, that is, it does not get the new settings.
Consequently, the operation changes the parameters of the transformation against
perfect insert operation does not change either split into two operations.
The operation of removing the text in the transformation of the operation against the perfect
parameter changes alter their settings to be able to be
applied.
The operation of parameters in the transformation of the operation against the perfect
deletion changes its position and length.
Finally, the mutual transformation of the two operations, changes in the parameters does not change
Nothing, if they operate on different parameters. If they do one and
However, the change is one of the operations will be reduced or removed altogether. If
Both transactions change the same parameter, but different values, one of the
operations will be reduced (on the server side decision is in favor of the
incoming transactions on the client - in favor of already perfect).

Check also google group about rich text formatting using OT here: http://groups.google.com/group/sharejs/browse_thread/thread/f973fd957e34448e
