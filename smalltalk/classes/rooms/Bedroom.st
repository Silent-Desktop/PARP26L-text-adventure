FileStream fileIn: 'classes/Room.st'.

Room subclass: Bedroom [
    init [
        super init.
        name := 'bedroom'.
        desc := {
            'This is the ', (Utils colPlace: 'bedroom'), ' where you spend most of your time. The blinds are shut but there is a small desk lamp illuminating the room.'.
        }.
        interactables := interactables class from: {
            #bed -> (Interactable desc: 'Your ', (Utils colObject: 'bed'), ' is in the far corner of the room. It''s covered with many pillows, blankets, and plushies.'
                interaction: [
                    (GameState isLocked: #dishwasher) ifTrue: [
                        Transcript showCr: 'The ', (Utils colObject: 'bed'), ' looks really inviting. You lie down and, the moment your cheek touches the pillow, you drift off for a nap.'.
                        Transcript showCr: 'You wake up sometime later, unsure what time it really is. The house is quiet, even the rumble of the ', (Utils colObject: 'dishwasher'), ' in the ', (Utils colPlace: 'kitchen'), ' has stopped.'.
                        GameState unlock: #dishwasher.
                    ] ifFalse: [
                        Transcript showCr: 'Without clear reason, you lie down for a nap again. But you already had one today, so it''s much harder to fall asleep. After a while of tossing and turning, you get back up.'
                    ]
                ] inspection: [
                    (GameState isLocked: #dishwasher) ifTrue: [
                        Transcript showCr: 'You inspect the blankets and pillows on your ', (Utils colObject: 'bed'), '. You made it this morning so everything is nice, tidy, and flat. The fluffy covers and soft pillows look very inviting.'
                    ] ifFalse: [
                        Transcript showCr: 'You look at the ', (Utils colObject: 'bed'), ' again. The blankets are no longer neatly folded and the pillows are clearly out of place. The nap you''ve had must''ve been really good.'
                    ]

                ]).
                #desk -> (Interactable desc: 'There is a ', (Utils colObject: 'desk'), ' pushed up against the wall. This is where you work during the day.',Character nl asString,'There''s a pile of notes, pens, and some books on it — the usual sight, given your upcoming exams.'
                interaction: [
                    (Inventory isCanFound: 8) ifFalse: [
                        Transcript showCr: 'You sit down at your ', (Utils colObject: 'desk'), ', determined to read through some of your notes. After sifting through piles of paper, you reach for a book.',Character nl asString,'Before you even open it, you notice ', (Utils colCan: 'Can #8'), ' was hiding behind it!'.
                        Inventory foundCan: 8.
                    ] ifTrue: [
                        Transcript showCr: 'You''ve already looked through your notes and books, creating an even bigger mess. Can #8 used to be hidden behind some books.'
                    ]
                ] inspection: [
                    (Inventory isCanFound: 8) ifFalse: [
                        Transcript showCr: 'You take a closer look at the pile of notes. You''re prepping for exams, so your ',(Utils colObject: 'desk'),' is full of notes and loose pens.',Character nl asString,'It looks like there''s something hidden behind the large stack of books to the side...'
                    ] ifTrue: [
                        Transcript showCr: 'You look at your notes again. The ', (Utils colObject: 'desk'), ' is even more of a mess now, since you''ve rearranged it. Can #8 used to be hidden behind some books here.'
                    ]

                ]).
        }.
    ]
    Bedroom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"