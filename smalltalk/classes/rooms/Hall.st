FileStream fileIn: 'classes/Room.st'.

Room subclass: Hall [
    init [
        super init.
        name := 'hall'.
        desc := {
            ''.
        }.
        interactables := interactables class from: {
            #'' -> (Interactable desc: ''
                interaction: [

                ] inspection: [

                ]).
        }.
        items := items class from: {
            #'' -> (Item look: ''
                take: '').
        }.
        hiddenItems := hiddenItems class from: {
            #'' -> (Item look: ''
                take: '')
        }.
        hiddenInteracts := hiddenInteracts class from: {
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