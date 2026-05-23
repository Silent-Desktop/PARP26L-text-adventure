"Utils class

This class' methods are static in order to allow global access (e.g. anywhere a String uses colour-coded words)
without the necessity to explicitly pass an instance as an argument.

Responsibilities:
- provide display utilities (colouring text, printing lines)
- provide command parsing utilities ()"

Object subclass: Utils [
    "Escape character used for colouring text."
    esc := Character esc asString.
    "Escape character used to reset text colour."
    reset := Character esc asString , '[0m'.

    "Passed text will be colour-coded like an Interactable."
    Utils class >> colObject: text [  "green"
        ^ esc , '[32m' , text , reset
    ]
    "Passed text will be colour-coded like a Room."
    Utils class >> colPlace: text [  "yellow"
        ^ esc , '[33m' , text , reset
    ]
    "Passed text will be colour-coded like an Item."
    Utils class >> colItem: text [  "blue"
        ^ esc , '[34m' , text , reset
    ]
    "Passed text will be colour-coded like a can.
    Note: only intended to use the moment the can is found
    in order to attract the player's attention."
    Utils class >> colCan: text [  "magenta"
        ^ esc , '[35m' , text , reset
    ]

    "Print a collection of Strings as separate lines."
    Utils class >> printLines: anArray [
        anArray do: [ :string | Transcript showCr: string ]
    ]

    "Receives a collection of words and returns all but first `n` words as a single String."
    Utils class >> concatTarget: cmd skipWords: n [
        ^ (cmd allButFirst: n) join: ' '
    ]
    "Return the 'target' of a command or `nil` if there's no target.
    Arguments:
    - `cmdTarget`: a collection of words
    - `skipWords`: first `n` words that aren't the target
    - `failMsg`: unique error message to be printed if there's no target"
    Utils class >> cmdTarget: cmd skipWords: n failMsg: msg [
        cmd size <= n ifTrue: [
                Transcript showCr: msg.
                ^ nil
            ]
            ifFalse: [
                (cmd size = (n+1)) ifTrue: [ ^ cmd at: n+1 ]
                    ifFalse: [ ^ (Utils concatTarget: cmd skipWords: n) ].
            ].
    ]
]