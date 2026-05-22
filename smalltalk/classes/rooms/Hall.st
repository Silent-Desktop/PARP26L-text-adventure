FileStream fileIn: 'classes/Room.st'.

Room subclass: Hall [
    init [
        super init.
        name := 'hall'.
        desc := {
            'This is the ', (Utils colPlace: 'hall'), ', where you keep your coats and shoes. There''s some unvacuumed sand on the tiled floor.'.
        }.
        interactables := interactables class from: {
            #door -> (Interactable desc: 'The ', (Utils colObject: 'door'), ' to your apartment is here and it''s currently locked.'
                interaction: [
                    (Inventory isCanFound: 12) ifFalse: [
                        Transcript showCr: 'You stand in front of the ', (Utils colObject: 'door'), ' of your apartment.'.
                        (Inventory hasItem: #keys) ifTrue: [
                            Transcript showCr: 'You pull out the ', (Utils colItem: 'keys'), ' and use them to easily open both locks. The ',(Utils colObject: 'door'),' is now open. On your doorstep you find ', (Utils colCan: 'Can #12'), '! You lock the ',(Utils colObject: 'door'),' again.'.
                            Inventory foundCan: 12.
                        ] ifFalse: [
                            Transcript showCr: 'The ', (Utils colObject: 'door'), ' is locked and, at least with your current equipment, there isn''t much you can do about it.'
                        ]
                    ] ifTrue: [
                        Transcript showCr: 'You''ve already opened the ',(Utils colObject: 'door'),'. Can #12 used to be outside, standing on your doormat. You''ve made sure to lock the ',(Utils colObject: 'door'),' again, right?'
                    ]
                ] inspection: [
                    (Inventory isCanFound: 12) ifFalse: [
                        Transcript showCr: 'The ', (Utils colObject: 'door'), ' is a solid ash grey color and the locks are pretty standard. You always make sure to lock it, so you''ll need your ',(Utils colItem: 'keys'),' if you want to look out into the corridor.'
                    ] ifTrue: [
                        Transcript showCr: 'The ', (Utils colObject: 'door'), ' is locked once again and there is no need for you to go outside right now.'
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