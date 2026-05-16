Object subclass: Utils [
    esc := Character esc asString.
    reset := Character esc asString , '[0m'.

    Utils class >> colObject: text [  "green"
        ^ esc , '[32m' , text , reset
    ]
    Utils class >> colPlace: text [  "yellow"
        ^ esc , '[33m' , text , reset
    ]
    Utils class >> colItem: text [  "blue"
        ^ esc , '[34m' , text , reset
    ]
    Utils class >> colCan: text [  "magenta"
        ^ esc , '[35m' , text , reset
    ]

    Utils class >> printLines: anArray [
        anArray do: [ :string | Transcript showCr: string ]
    ]
    Utils class >> concatTarget: cmd skipWords: n [
        ^ (cmd allButFirst: n) join: ' '
    ]
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