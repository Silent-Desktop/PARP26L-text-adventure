FileStream fileIn: 'Room.st'.

Room subclass: LivingRoom [
    init [
        super init.
        name := 'living room'
    ]
    LivingRoom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"