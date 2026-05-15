FileStream fileIn: 'Room.st'.

Room subclass: Kitchen [
    init [
        super init.
        name := 'kitchen'
    ]
    Kitchen class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
    look [
        super look.
    ]
]

"TODO: descriptions, interactions, inspections, items"