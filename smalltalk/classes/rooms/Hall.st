FileStream fileIn: 'classes/Room.st'.

Room subclass: Hall [
    init [
        super init.
        name := 'hall'.
        desc := {
            'This is the ', (Utils colPlace: 'hall'), ' where you keep your coats and shoes. There''s some unvacuumed sand on the tiled floor.'.
        }.
        interactables := interactables class from: {
            #'house door' -> (Interactable desc: 'The ', (Utils colObject: 'house door'), ' to your apartment is here and it''s currently locked.'
                interaction: [
                    (Inventory isCanFound: 12) ifFalse: [
                        Transcript showCr: 'You stand in front of the ', (Utils colObject: 'house door'), ' of your apartment.'.
                        (Inventory hasItem: #'house keys') ifTrue: [
                            Transcript showCr: 'You pull out the ', (Utils colItem: 'house keys'), ' and use them to easily open both locks. The door is now open. On your doorstep you find ', (Utils colCan: 'Can #12'), '! You lock the door again.'.
                            Inventory foundCan: 12.
                        ] ifFalse: [
                            Transcript showCr: 'The ', (Utils colObject: 'house door'), ' is locked and with your current equipment there isn''t much you can do about it.'
                        ]
                    ] ifTrue: [
                        Transcript showCr: 'You''ve already opened the door. Can #12 used to be outside standing on your doormat. You made sure to lock the door again right?'
                    ]
                ] inspection: [
                    (Inventory isCanFound: 12) ifFalse: [
                        Transcript showCr: 'The ', (Utils colObject: 'house door'), ' is a solid ash grey color and the locks are pretty standard. You always make sure to lock it so you''ll need keys if you want to look out into the corridor.'
                    ] ifTrue: [
                        Transcript showCr: 'The ', (Utils colObject: 'house door'), ' is locked once again and there is no need for you to go outside right now.'
                    ]
                ]).
        }.
        items := items class from: {
            #boots -> (Item look: 'There is a pair of your heavy duty ', (Utils colItem: 'boots'), ' here. They''re still covered with wet mud from outside.'
                take: [
                    Transcript showCr: 'You pick up the ', (Utils colItem: 'boots'), ' and get some mud on your hands. Yuck. When you rotate one of the ', (Utils colItem: 'boots'), ' something cylindrical falls out into your hand. It''s ', (Utils colCan: 'Can #11'), '!'.
                    Inventory foundCan: 11.
                ]).
        }.
    ]
    Hall class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"