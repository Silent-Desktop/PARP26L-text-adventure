Object subclass: Utils [
Utils class >> esc [
        ^ Character esc asString
    ]
Utils class >> reset [
        ^ self esc , '[0m'
    ]
Utils class >> green: text [
        ^ self esc , '[32m' , text , self reset
    ]
Utils class >> yellow: text [
        ^ self esc , '[33m' , text , self reset
    ]
Utils class >> blue: text [
        ^ self esc , '[34m' , text , self reset
    ]
Utils class >> magenta: text [
        ^ self esc , '[35m' , text , self reset
    ]
]