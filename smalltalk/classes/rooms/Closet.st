FileStream fileIn: 'classes/Room.st'.

Room subclass: Closet [
    init [
        super init.
        name := 'closet'.
        desc := {
            'This is the ', (Utils colPlace: 'closet'), ', where you keep most of your daily clothes. There are specks of dust in the air and you can smell your laundry detergent faintly.'
        }.
        interactables := interactables class from: {
            #'paper box' -> (Interactable
                desc: ((Inventory isCanFound: 10) ifFalse: [
                    'On the floor, there is a small ', (Utils colObject: 'paper box'), ', completely covered in packing tape. You''ll need something sharp to open it.'
                ] ifTrue: [
                    'The ', (Utils colObject: 'paper box'), ' on the floor has already been opened with a ',(Utils colItem: 'knife'),', inside are only white packing peanuts.'
                ])
                interaction: [
                    Transcript showCr: 'You squat down to reach the ',(Utils colObject: 'box'),'.'.
                    (Inventory isCanFound: 10) ifFalse: [
                        (Inventory hasItem: #knife) ifTrue: [
                            Transcript showCr: 'You use the sharp ',(Utils colItem: 'knife'),' to cut through the packing tape. Inside the ',(Utils colObject: 'box'),', there is a lot of white packing peanuts, but underneath them you find ', (Utils colCan: 'Can #10'), '!'.
                            Inventory foundCan: 10.
                        ] ifFalse: [
                            Transcript showCr: 'The thick layers of tape are too much for you to tear through. Something sharp would come in handy...'
                        ]
                    ] ifTrue: [
                        Transcript showCr: 'You''ve already opened the ', (Utils colObject: 'paper box'), ' using the ', (Utils colItem: 'knife'), '. Inside, there used to be Can #10.'
                    ]
                ] inspection: [
                    (Inventory isCanFound: 10) ifFalse: [
                        Transcript showCr: 'It''s a ', (Utils colObject: 'paper box'), ', completely covered in many, many layers of packing tape. It''s definitely too sealed for you to just open it with your bare hands. A ',(Utils colItem: 'knife'),' would surely help here.'
                    ] ifTrue: [
                        Transcript showCr: 'It''s the ', (Utils colObject: 'paper box'), ', now torn open. Inside, only a heap of white packing peanuts remains.'
                    ]

                ]).
            #'clothing rack' -> (Interactable desc: 'There is a ', (Utils colObject: 'clothing rack'), ' here, where you keep your shirts and some pants. It looks dusty.'
                interaction: [
                    (Inventory isCanFound: 9) ifFalse: [
                        Transcript showCr: 'You grab your favourite jacket from a hanger and put it on. It''s very warm and has nice, big pockets. Without much thinking, you put your hands in the pockets and notice something cold. In your left pocket, you find ', (Utils colCan: 'Can #9'), '!'.
                        Inventory foundCan: 9.
                    ] ifTrue: [
                        Transcript showCr: 'All the clothes, including the jacket you grabbed earlier, are back on the ', (Utils colObject: 'clothing rack'), '. You try the jacket on again, but quickly put it back, since it''s too warm, anyway.',Character nl asString,'Can #9 used to be in the left pocket.'
                    ]
                ] inspection: [
                    (Inventory isCanFound: 9) ifFalse: [
                        Transcript showCr: 'You look closer at one of your favourite denim jackets. The fabric is pretty thick, but despite that, you can still see something bulging in its inner pocket.',Character nl asString,'You reach in and find ', (Utils colCan: 'Can #9'), '!'.
                        Inventory foundCan: 9.
                    ] ifTrue: [
                        Transcript showCr: 'You inspect the ', (Utils colObject: 'clothing rack'), ' again. Your denim jacket now hangs flat on its hanger. Can #9 used to be in the inner pocket.'
                    ]

                ]).
        }.
    ]
    Closet class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]