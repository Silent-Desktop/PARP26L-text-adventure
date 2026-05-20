FileStream fileIn: 'classes/Room.st'.

Room subclass: Closet [
    init [
        super init.
        name := 'closet'.
        desc := {
            ''.
        }.
        interactables := SortedCollection from: {
            #'' -> (Interactable desc: ''
                interaction: [

                ] inspection: [

                ]).
        }.
        items := LookupTable from: {
            #'' -> (Item look: ''
                take: '').
        }.
        hiddenItems := LookupTable from: {
            #'' -> (Item look: ''
                take: '')
        }.
        hiddenInteracts := LookupTable from: {
            #'' -> (Interactable desc: ''
                interaction: [

                ] inspection: [

                ]).
        }
    ]
    Closet class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"