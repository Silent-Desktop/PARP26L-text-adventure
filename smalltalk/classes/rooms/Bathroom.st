FileStream fileIn: 'classes/Room.st'.

Room subclass: Bathroom [
    init [
        super init.
        name := 'bathroom'.
        desc := {
            'This is the ', (Utils colPlace: 'bathroom'), ' and it looks scrubbed clean. You must have been very bored lately.'.
        }.
        interactables := interactables class from: {
            #sink -> (Interactable desc: 'There is a ', (Utils colObject: 'sink'), ' here, with nothing on it. You must have put everything away to make it cleaner.'
                interaction: 'You turn on the water to rinse your hands. It''s pleasantly cold and leaves droplets on the white porcelain.'
                inspection: 'It''s the bathroom ', (Utils colObject: 'sink'), ', perfectly clean and almost sparkling. So far there haven''t been any leaks.').
            #toilet -> (Interactable desc: 'There is a ', (Utils colObject: 'toilet'), ' here, also very clean. You had guests over so you had to scrub the bathroom.'
                interaction: 'You pull up the seat to check for any uncleaned spots. Luckily, you''ve been diligent, so the white porcelain is spotless. You flush the ', (Utils colObject: 'toilet'), ' and it does indeed make a funny gurgling sound.'
                inspection: 'It''s the ', (Utils colObject: 'toilet'), '. It makes a funny noise when you flush it.').
            #shower -> (Interactable desc: 'Your ', (Utils colObject: 'shower'),' is here. The walls are clear glass but they''re a bit cloudy since you haven''t cleaned them in a while. On a shelf built into the wall you keep your shampoo bottles. Are there more of them than usual...?'
                interaction: 'You grab the nozzle and turn on the water. It splashes a bit and wets your socks.'
                inspection: [
                    (Inventory isCanFound: 7) ifFalse: [
                        Transcript showCr: 'You peek into the ', (Utils colObject: 'shower'), ', careful not to wet your socks on the moist floor. There''s a sponge here and some shampoo and conditioner bottles on a built-in shelf. After taking a closer look one of the bottles turns out to be ', (Utils colCan: 'Can #7'), '.'.
                        Inventory foundCan: 7.
                    ] ifTrue: [
                        Transcript showCr: 'You''ve already looked the ', (Utils colObject: 'shower'), ' up and down and there isn''t anything else of note here. Can #7 used to be hidden bewteen your shampoo bottles.'
                    ] 
                ]).
        }.
        items := items class from: {
            #towel -> (Item look: 'Theres a ', (Utils colItem: 'towel'), ' here, hanging from the top of the shower door. It''s still a bit wet and you can see a few drops of water hit the tiles below it.'
                take: 'You pick up the ', (Utils colItem: 'towel'), '. It cold and wet to the touch. It still hasn''t dried.').
        }.
    ]
    Bathroom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"