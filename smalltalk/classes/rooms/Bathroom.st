FileStream fileIn: 'classes/Room.st'.

Room subclass: Bathroom [
    init [
        super init.
        name := 'bathroom'.
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
    Bathroom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"