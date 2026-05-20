FileStream fileIn: 'classes/Room.st'.

Room subclass: Balcony [
    init [
        super init.
        name := 'balcony'.
        desc := {
            'This is the ',(Utils colPlace: 'balcony'),'.'.
        }.
        interactables := SortedCollection from: {
            #plant -> (Interactable desc: 'On the floor, in the corner, there is a large potted ',(Utils colObject: 'plant'),'. It''s most likely a fern, but you never bothered to make sure. Its leaves are large and sprawling.'
                interaction: [

                ] inspection: [
                    (Inventory isCanFound: 7) ifFalse: [
                        Transcript showCr: 'It''s the big ',(Utils colObject: 'plant'),' on your balcony, perhaps a fern. Its leaves are wide and sprawling. It would be very easy to hide something here.'.
                    ] ifTrue: [
                        Transcript showCr: 'The leaves look a bit ruffled now, after you''ve pushed them aside. The ',(Utils colObject: 'plant'),' doesn''t seem bothered.'.
                    ]
                ]).
            #railing -> (Interactable desc: 'The balcony has a thick metal ',(Utils colObject: 'railing'),' and right now, there is a couple of towels hanging from it.'
                interaction: [

                ] inspection: [
                    (Inventory isCanFound: 6) ifFalse: [
                        Transcript showCr: 'Over the edge of the ',(Utils colObject: 'railing'),' there is a thin ',(Utils colObject: 'string'),' hanging. It''s tied to one of the metal bars and it''s taut.'.
                        (hiddenInteracts includesKey: #string) ifTrue: [self revealInteract: #string].
                    ] ifTrue: [
                        Transcript showCr: 'There is a thin string tied to the ',(Utils colObject: 'railing'),'. Currently, it''s loose. Can #6 used to be tied to the end.'.
                    ]
                ]).
        }.
        hiddenInteracts := LookupTable from: {
            #string -> (Interactable desc: 'Over the edge of the ',(Utils colObject: 'railing'),' there is a thin ',(Utils colObject: 'string'),' hanging. It''s tied to one of the metal bars and it''s taut.'
                interaction: [
                    Transcript showCr: 'You grab the ',(Utils colObject: 'string'),' at the edge of the railing and start gently pulling. There is something heavy tied to it. Finally, you grab a hold of ',(Utils colCan: 'Can #6'),'!'.
                    Inventory foundCan: 6.
                    interactables remove: (interactables detect: [:assoc | assoc key = #string]).
                ] inspection: [
                    Transcript showCr: 'The ',(Utils colObject: 'string'),' is tied to one of the metal bars and it''s taut.'
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