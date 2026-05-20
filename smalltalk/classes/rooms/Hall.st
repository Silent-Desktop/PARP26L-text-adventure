FileStream fileIn: 'classes/Room.st'.

Room subclass: Hall [
    init [
        super init.
        name := 'hall'.
        desc := {
            ''.
        }.
        interactables := LookupTable from: {
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
    Hall class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"