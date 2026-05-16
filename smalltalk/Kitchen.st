FileStream fileIn: 'Utils.st'.
FileStream fileIn: 'Room.st'.

Room subclass: Kitchen [
    desc := {
        'This is the ' , (Utils yellow: 'kitchen') , '. The countertops are clean and there are no dirty dishes in the sink. Clearly you''ve been busy or just haven''t eaten in a long time.'.
        'There is a ' , (Utils green: 'dishwasher') , ' here, a true lifesaver, since you hate washing the dishes by hand.'.
        'Your ' , (Utils green: 'fridge') , ' is here, without any chilled cans inside. Open it when you''re done.'.
        'There is a large ' , (Utils green: 'cupboard') , ' right at your eye-level and its slightly ajar.'.
        'Next to your feet, there is a big square ' , (Utils green: 'trashcan') ,', with its lid closed.'.
    }.
    init [
        super init.
        name := 'kitchen'.
        items := Dictionary from: {
            'knife' -> 'You pick up the knife. The handle is solid black and cold to the touch.'.
        }.
        interactables := Dictionary from: {
            'dishwasher' -> [:state | Transcript showCr: 'Dishwasher interaction [PH]' , state actionCount asString. nil].
        }
    ]
    Kitchen class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
    look [
        Utils printLines: desc.
        Transcript cr.
        (items includesKey: 'knife') ifTrue: [
            Transcript showCr: 'There is a ' , (Utils blue: 'knife') , ' on the countertop near the sink. It looks sharp.'; cr.
        ].
        super look.
    ]
]

"TODO: descriptions, interactions, inspections, items"