FileStream fileIn: 'classes/Room.st'.

Room subclass: Bedroom [
    init [
        super init.
        name := 'bedroom'.
        desc := {
            ''.
        }.
        interactables := Dictionary from: {
            '' -> (Interactable desc: ''
                interaction: [

                ] inspection: [

                ]).
        }.
        items := Dictionary from: {
            '' -> (Item look: ''
                take: '').
        }.
        hiddenItems := Dictionary from: {
            '' -> (Item look: ''
                take: '')
        }.
        hiddenInteracts := Dictionary from: {
            '' -> (Interactable desc: ''
                interaction: [

                ] inspection: [

                ]).
        }
    ]
    Bedroom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"