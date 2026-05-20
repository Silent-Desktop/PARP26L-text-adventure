FileStream fileIn: 'classes/Room.st'.

Room subclass: RoomName [
    init [
        super init.
        name := ''.
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
    RoomName class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"