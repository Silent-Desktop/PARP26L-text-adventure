Object subclass: Item [
    | name lookDesc takeBlock |

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

    lookDesc [
        ^lookDesc
    ]
    take [
        takeBlock value
    ]
]