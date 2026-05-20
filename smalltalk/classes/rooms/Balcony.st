FileStream fileIn: 'classes/Room.st'.

Room subclass: Balcony [
    init [
        super init.
        name := 'balcony'.
        desc := {
            'This is the ',(Utils colPlace: 'balcony'),'.'.
        }.
        interactables := Dictionary from: {
            'plant' -> (Interactable desc: 'On the floor, in the corner, there is a large potted ',(Utils colObject: 'plant'),'. It''s most likely a fern, but you never bothered to make sure. Its leaves are large and sprawling.'
                interaction: [

                ] inspection: [

                ]).
            'railing' -> (Interactable desc: 'The balcony has a thick metal ',(Utils colObject: 'railing'),' and right now, there is a couple of towels hanging from it.'
                interaction: [

                ] inspection: [

                ]).
        }.
        hiddenInteracts := Dictionary from: {
            'string' -> (Interactable desc: 'Over the edge of the ',(Utils colObject: 'railing'),' there is a thin ',(Utils colObject: 'string'),' hanging. It''s tied to one of the metal bars and it''s taut.'
                interaction: [

                ] inspection: [

                ]).
        }
    ]
    Balcony class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"