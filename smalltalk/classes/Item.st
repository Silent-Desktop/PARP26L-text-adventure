Object subclass: Item [
    | lookDesc takeDesc |

    Item class >> look: aLookDesc take: aTakeDesc [
        | x |
        x := super new.
        x init: aLookDesc take: aTakeDesc.
        ^x
    ]

    init: aLookDesc take: aTakeDesc [
        lookDesc := aLookDesc.
        takeDesc := aTakeDesc.
    ]

    lookDesc [
        ^lookDesc
    ]
    takeDesc [
        ^takeDesc
    ]
]