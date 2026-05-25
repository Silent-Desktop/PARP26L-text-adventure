"Item class

Responsibilities:
- store item description to be displayed with the 'look' command
- store a String to be displayed with the 'take' command (or a more complex BlockClosure to be executed)"

Object subclass: Item [
    | lookDesc takeBlock |
    "Item constructor
    Arguments:
    - look: String
    - take: String or BlockClosure
    `take` String is converted into a simple `[Transcript showCr: aString]` BlockClosure."
    Item class >> look: aLookDesc take: aTakeDesc [
        | x |
        x := super new.
        x init: aLookDesc take: aTakeDesc.
        ^x
    ]
    init: aLookDesc take: aTakeDesc [
        lookDesc := aLookDesc.
        (aTakeDesc respondsTo: #value) ifFalse: [
            takeBlock := [Transcript showCr: aTakeDesc]
        ] ifTrue: [
            takeBlock := aTakeDesc
        ]
    ]

    "Execute the `takeBlock`. Usually just prints a simple description of taking the item."
    take [
        takeBlock value
    ]

    lookDesc [
        ^lookDesc
    ]
]