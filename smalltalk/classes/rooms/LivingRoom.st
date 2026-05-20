FileStream fileIn: 'classes/Room.st'.

Room subclass: LivingRoom [
    init [
        super init.
        name := 'living room'.
        desc := {
            'This is the ', (Utils colPlace: 'living room') , ' where you spend your free time. You never take naps here, though.'.
        }.
        interactables := LookupTable from: {
            #couch -> (Interactable desc: 'There is a ', (Utils colObject: 'couch') , ' here. It looks very comfortable with all its cushions, the fluffy blanket and the black cat plushie on top.'
                interaction: [
                    (Inventory isCanFound: 4) ifFalse: [
                        Transcript showCr: 'You decide to take a break and sit down on the ', (Utils colObject: 'couch'), '. The cushions are soft, but there is something hard poking you in the hip. You reach under the blanket and find ', (Utils colCan: 'Can #4'), '!'.
                        Inventory foundCan: 4.
                    ] ifTrue: [
                        Transcript showCr: 'Against better judgment, you decide to sit on the ', (Utils colObject: 'couch'), ' again and waste more time. It''s way comfier than previously. Can #4 used to be hidden beneath the blanket here.'.
                ]
                ] inspection: [
                    Transcript showCr: 'This is your ', (Utils colObject: 'couch'), '. It''s where you hang out during the day and read books. You hate napping on it.'.
                    (Inventory isCanFound: 4) ifFalse: [
                        Transcript showCr: 'Right now, the cushions and blanket are bunched up in a weird way, like something is underneath.'.
                    ] ifTrue: [
                        Transcript showCr: 'The cushions are back to lying flat after you pulled out Can #4 from underneath them.'.
                    ]
                ]).
            #table -> (Interactable desc: 'There is a ',  (Utils colObject: 'table') , ' here, used for dining or gatherings.'
                interaction: [
                    Transcript showCr: 'You''re not planning to work right now and it''s way before dinner time, so the ',(Utils colObject: 'table'),' isn''t really useful to you at the moment.'.
                ] inspection: [
                    Transcript showCr: 'This is where you usually eat your meals or work if you need more space. The ',(Utils colObject: 'table'),' is made of a dark reddish wood and it''s big enough for at least 8 people to sit around it.'.
                    (hiddenItems includesKey: #'house keys') ifTrue: [
                        Transcript showCr: 'After taking a closer look at the things laid out on the table, you notice the ',(Utils colItem: 'house keys'),' under the folded tablecloth.'.
                        self revealItem: #'house keys'.
                    ]
                ]).
        }.
        items := LookupTable from: {
            #chair -> (Item look: 'There is a ' , (Utils colItem: 'chair') , ' here, just next to the ' , (Utils colObject: 'table') , '. Usually, you''d just sit on it, but sometimes you use it to reach higher places.'
                take: 'You somehow manage to pick up the ' , (Utils colItem: 'chair') , '. It''s a bit weird to hold, but you''ve done this before.').
        }.
        hiddenItems := LookupTable from: {
            #'house keys' -> (Item look: 'The ' , (Utils colItem: 'house keys') , ' are here, on the table. Usually, you leave them here anyway, easier to find later.'
                take: 'You pick up the ' , (Utils colItem: 'house keys') , ' and they fit neatly in your back pocket.').
        }.
    ]
    showItems [
        super showItems.
        (Inventory isCanFound: 5) ifFalse: [
            Transcript showCr: 'When you look at the ' , (Utils colObject: 'table') , ' you see some used plates, a folded tablecloth, and next to them, slightly obscured by an empty cup, is ' , (Utils colCan: 'Can #5') , '!'.
            Inventory foundCan: 5.
        ].
    ]
    LivingRoom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]