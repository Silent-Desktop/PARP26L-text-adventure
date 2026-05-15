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
]