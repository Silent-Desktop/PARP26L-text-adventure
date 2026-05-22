FileStream fileIn: 'classes/Room.st'.

Room subclass: Kitchen [
    init [
        super init.
        name := 'kitchen'.
        desc := {
            'This is the ' , (Utils colPlace: 'kitchen') , '. The countertops are clean and there are no dirty dishes in the sink. Clearly you''ve been busy or just haven''t eaten in a long time.'.
        }.
        interactables := interactables class from: {
            #dishwasher -> (Interactable desc: 'There is a ' , (Utils colObject: 'dishwasher') , ' here, a true lifesaver, since you hate washing the dishes by hand.'
                interaction: [
                    (GameState isLocked: #dishwasher) ifTrue: [
                        Transcript showCr: 'The ' , (Utils colObject: 'dishwasher') , ' is rumbling and the little display is on — there''s a wash cycle still going. You''ll have to wait some time before opening it.'
                    ] ifFalse: [
                        (Inventory isCanFound: 1) ifFalse: [
                            Transcript showCr: 'The little display is off and the ' , (Utils colObject: 'dishwasher') , ' isn''t making any noises — the wash cycle must be done. You grab the handle and open the door. Inside, it''s still warm and humid. Between plates and pots you find ' , (Utils colCan: 'Can #1') , '!'.
                            Inventory foundCan: 1.
                        ] ifTrue: [
                            Transcript showCr: 'The ' , (Utils colObject: 'dishwasher') , ' has already been opened. The plates inside are drying. Can #1 used to be here.'
                        ]
                    ]
                ] inspection: [
                    (GameState isLocked: #dishwasher) ifTrue: [
                        Transcript showCr: 'The little display is flashing some numbers and you can hear rumbling and water sloshing inside. It might be a good idea to just take a nap instead of waiting here for it to finish.'
                    ] ifFalse: [
                        Transcript showCr: 'The wash cycle has finished, the little display is off and there are no more rumbling noises coming from within.'
                    ]
                ]).
            #cupboard -> (Interactable desc: 'There is a large ' , (Utils colObject: 'cupboard') , ' right at your eye-level and its slightly ajar.'
                interaction: [
                    (Inventory isCanFound: 2) ifFalse: [
                        (Inventory hasItem: #chair) ifTrue: [
                            Transcript showCr: 'You climb the ' , (Utils colItem: 'chair') , ' to reach the top shelf and grab ' , (Utils colCan: 'Can #2') , '!'.
                            Inventory foundCan: 2.
                        ] ifFalse: [
                            Transcript showCr: 'You can see something on the top shelf but it''s way too high for you to reach.'
                        ]
                    ] ifTrue: [
                        Transcript showCr: 'You look into the ' , (Utils colObject: 'cupboard') , ' again but besides some clean cups and plates there''s nothing of interest anymore. Can #2 used to be on the top shelf.'
                    ]
                ] inspection: [
                    (Inventory isCanFound: 2) ifFalse: [
                        Transcript showCr: 'The ' , (Utils colObject: 'cupboard') , ' is where you keep your plates and cups. However, on the top shelf you can see something shiny. You will definitely need a ',(Utils colItem: 'chair'),' to reach it.'
                    ] ifTrue: [
                        Transcript showCr: 'Your plates and cups are still here. Luckily you haven''t broken anything while trying to reach the top shelf.'
                    ]
                ]).
            #trashcan -> (Interactable desc: 'Next to your feet, there is a big square ' , (Utils colObject: 'trashcan') ,', with its lid closed.'
                interaction: [
                    (Inventory isCanFound: 3) ifFalse: [
                        Transcript showCr: 'You grab the plastic lid and open the ' , (Utils colObject: 'trashcan') , '. Inside, nestled between old takeout boxes and paper scraps, is ' , (Utils colCan: 'Can #3') , '!'.
                        Inventory foundCan: 3.
                    ] ifTrue: [
                        Transcript showCr: 'You open the ' , (Utils colObject: 'trashcan') , ' again. Luckily, there is no upleasant smell. Can #3 used to lie on the paper scraps here.'
                    ]
                ] inspection: 'It''s a standard grey ' , (Utils colObject: 'trashcan') , '. The container itself isn''t heavy and you mostly throw out paper scraps here.').
            #fridge -> (Interactable desc: 'Your ' , (Utils colObject: 'fridge') , ' is here, without any chilled cans inside. Open it when you''re done.'
                interaction: [
                    Transcript showCr: 'You open the ' , (Utils colObject: 'fridge') , ' and return all the cans that you''ve found to their shelf. You''re looking forward to enjoying a nice, cold drink.'.
                    GameState endGameScreen.
                ] inspection: 'This is your ' , (Utils colObject: 'fridge') , '. Inside, there should be 12 cans of your favourite energy drink, but your friends hid them around the house to prank you. When you''re done searching, you should return here and put them back.').
        }.
        items := items class from: {
            #knife -> (Item look: 'There is a ' , (Utils colItem: 'knife') , ' on the countertop near the sink. It looks sharp.'
                take: 'You pick up the ' , (Utils colItem: 'knife') , '. The handle is solid black and cold to the touch.').
        }.
    ]
    Kitchen class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]