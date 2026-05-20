FileStream fileIn: 'classes/Room.st'.

Room subclass: Bathroom [
    init [
        super init.
        name := 'bathroom'.
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
    Bathroom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"