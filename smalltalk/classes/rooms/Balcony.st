FileStream fileIn: 'classes/Room.st'.

Room subclass: Balcony [
    init [
        super init.
        name := 'balcony'.
        desc := {
            ''.
        }.
        interactables := Dictionary from: {
            '' -> (Interactable interaction: [

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
    ]
    Balcony class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"