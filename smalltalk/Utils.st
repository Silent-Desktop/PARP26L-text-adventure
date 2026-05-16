Object subclass: Utils [
    esc := Character esc asString.
    reset := Character esc asString , '[0m'.

    Utils class >> green: text [
        ^ esc , '[32m' , text , reset
    ]
    Utils class >> yellow: text [
        ^ esc , '[33m' , text , reset
    ]
    Utils class >> blue: text [
        ^ esc , '[34m' , text , reset
    ]
    Utils class >> magenta: text [
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