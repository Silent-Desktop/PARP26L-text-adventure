Object subclass: Item [
    | name lookDesc aTakeBlock |

    Item class >> look: aLookDesc take: aTakeBlock [
        | x |
        x := super new.
        x init: nil look: aLookDesc take: aTakeBlock.
        ^x
    ]

    Item class >> name: aName look: aLookDesc take: aTakeBlock [
        | x |
        x := super new.
        x init: aName look: aLookDesc take: aTakeBlock.
        ^x
    ]

    init: aName look: aLookDesc take: take [
        name := aName.
        lookDesc := aLookDesc.
        aTakeBlock := take.
    ]

    name [
        ^ name
    ]

    lookDesc [
        ^lookDesc
    ]
    take [
        aTakeBlock value
    ]
]