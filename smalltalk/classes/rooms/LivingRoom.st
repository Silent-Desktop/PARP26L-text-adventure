FileStream fileIn: 'classes/Room.st'.

Room subclass: LivingRoom [
    init [
        super init.
        name := 'living room'.
        desc := {
            'This is the ', (Utils colPlace: 'living room') , ' where you spend your free time. You never take naps here though.'.
            'There is a ',  (Utils colObject: 'table here') , ' used for dining or gatherings.'.
            'There is a ', (Utils colObject: 'couch') , ' here, it looks very comfortable with all its cushions and the fluffy blanket on top.'.
            "TODO conditional description for finding can #5 that must appear ONLY once"
        }.
        interactables := Dictionary from: {
            'couch' -> (Interactable interaction: [:state |
                (state inventory ifCanFound: 4) ifFalse: [
                    Transcript showCr: 'You decide to take a break and sit down on the ', (Utils colObject: 'couch'), '. The cushions are soft but there is something hard poking you in the hip. You reach under the blanket and find ', (Utils colCan: 'Can #4'), '!'.
                    state inventory foundCan: 4.
                ] ifTrue: [
                    Transcript showCr: 'Against better judgment you decide to sit on the ', (Utils colObject: 'couch'), ' again and waste more time. It''s way comfier than previously. Can #4 used to be hidden beneath the blanket here.'.
            ]
            ] inspection: [:state |
                (state inventory ifCanFound: 4) ifFalse: [
                    Transcript showCr: 'This is your ', (Utils colObject: 'couch'), '. It''s were you hang out during the day and read books. You hate napping on it. Right now the cushions and blanket are bunched up in a weird way, like something is underneath.'.
                ] ifTrue: [
                    Transcript showCr: 'This is your ', (Utils colObject: 'couch'), '. It''s were you hang out during the day and read books. You hate napping on it. The cushions are back to laying flat after you pulled out Can #4 from underneath them.'.
                ]
            ]).
        }.
        items := Dictionary from: {
            '' -> (Item look: '' take: '').
        }.
    ]
    LivingRoom class >> look [
       super look.
       Transcript showCr: 'WORK PLEASE'.
    ]
    LivingRoom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"