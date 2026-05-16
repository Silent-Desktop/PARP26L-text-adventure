FileStream fileIn: 'Utils.st'.
FileStream fileIn: 'Room.st'.
FileStream fileIn: 'Item.st'.

Room subclass: Kitchen [
    init [
        super init.
        name := 'kitchen'.
        desc := {
            'This is the ' , (Utils colPlace: 'kitchen') , '. The countertops are clean and there are no dirty dishes in the sink. Clearly you''ve been busy or just haven''t eaten in a long time.'.
            'There is a ' , (Utils colObject: 'dishwasher') , ' here, a true lifesaver, since you hate washing the dishes by hand.'.
            'Your ' , (Utils colObject: 'fridge') , ' is here, without any chilled cans inside. Open it when you''re done.'.
            'There is a large ' , (Utils colObject: 'cupboard') , ' right at your eye-level and its slightly ajar.'.
            'Next to your feet, there is a big square ' , (Utils colObject: 'trashcan') ,', with its lid closed.'.
        }.
        interactables := Dictionary from: {
            'dishwasher' -> [:state |
                (state isLocked: 'dishwasher') ifTrue: [
                    Transcript showCr: 'The dishwasher is rumbling and the little display is on — there''s a wash cycle still going. You''ll have to wait some time before opening it.'
                ] ifFalse: [
                    (state inventory ifCanFound: 1) ifFalse: [
                        Transcript showCr: 'The little display is off and the dishwasher isn''t making any noises — the wash cycle must be done. You grab the handle and open the door. Inside, it''s still warm and humid. Between plates and pots you find ' , (Utils colCan: 'Can #1') , '!'.
                        state inventory foundCan: 1.
                    ] ifTrue: [
                        Transcript showCr: 'The dishwasher has already been opened. The plates inside are drying. ' , (Utils colCan: 'Can #1') , ' used to be here.'
                    ]
                ]
            ].
            'cupboard' -> [:state |
                (state inventory ifCanFound: 2) ifFalse: [
                    (state inventory hasItem: 'chair') ifTrue: [
                        Transcript showCr: 'You climb the chair to reach the top shelf and grab ' , (Utils colCan: 'Can #2') , '!'.
                        state inventory foundCan: 2.
                    ] ifFalse: [
                        Transcript showCr: 'You can see something on the top shelf but it''s way too high for you to reach.'
                    ]
                ] ifTrue: [
                    Transcript showCr: 'You look into the cupboard again but besides some clean cups and plates there''s nothing of interest anymore. ' , (Utils colCan: 'Can #2') , ' used to be on the top shelf.'
                ]
            ].
            'trashcan' -> [:state |
                (state inventory ifCanFound: 3) ifFalse: [
                    Transcript showCr: 'You grab the plastic lid and open the trashcan. Inside, nestled between old takeout boxes and paper scraps, is ' , (Utils colCan: 'Can #3') , '!'.
                    state inventory foundCan: 3.
                ] ifTrue: [
                    Transcript showCr: 'You open the trashcan again. Luckily, there is no upleasant smell. ' , (Utils colCan: 'Can #3') , ' used to lie on the paper scraps here.'
                ]
            ].
            'fridge' -> [:state |
                Transcript showCr: 'You open the fridge and return all the ' , (Utils colCan: 'cans') , ' that you''ve found to their shelf. You''re looking forward to enjoying a nice, cold drink.'.
                state endGameScreen.
            ].
        }.
        items := Dictionary from: {
            'knife' -> (Item look: 'There is a ' , (Utils colItem: 'knife') , ' on the countertop near the sink. It looks sharp.' take: 'You pick up the knife. The handle is solid black and cold to the touch.').
        }.
    ]
    Kitchen class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: inspections"