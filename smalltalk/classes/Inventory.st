FileStream fileIn: 'classes/Utils.st'.

"Inventory class

This class' fields and methods are static in order to allow global access (e.g. within interaction BlockClosures)
without the necessity to explicitly pass the inventory as an argument.

Responsibilities:
- keep track of collected items and cans
- display stored information"

Object subclass: Inventory [
    "Can descriptions to be displayed with the 'found' command."
    canDescs := {
        'Can #1: There are pictures of butterflies on it. The drink flavour is disgustingly peachy.'.
        'Can #2: There are drawings of fish and underwater algae all the way around it. You''re pretty sure the flavour is pineapple.'.
        'Can #3: It''s a vivid neon green colour. It''s the best flavour — sour apple.'.
        'Can #4: It''s pink in colour and the drink is probably strawberry flavoured.'.
        'Can #5: The colour of it is a really bright, cheerful yellow. There''s some drawings on it as well, but they''re pretty meaningless. The flavour is bad.'.
        'Can #6: It''s a uniform, soft, pinkish-orange colour. The drink tastes like peach and lemon.'.
        'Can #7: It has a gold coating with sparkling silver details. It''s reeeaaally shiny. The drink tastes like cream soda.'.
        'Can #8: It''s a really bright pastel pink. The drink inside tastes like bubblegum.'.
        'Can #9: It''s black with some green gradient. There''s ''NITRO'' written at the bottom. Why did you buy this flavour?'.
        'Can #10: It''s black with red details. The drink flavour is cherry.'.
        'Can #11: Completely white with some grey shading and silver details. You''re not sure what the flavour is supposed to be.'.
        'Can #12: It''s a deep purple colour with some vines drawn around it. The drink flavour is most likely grape.'.
        'Can #13: Lucky #13! You found the bonus secret can. Congrats!'.
    }.
    "Array of Booleans — keeps track of which cans have already been found or not."
    cans := Array new: 13 withAll: false.  "unfortunately, it's impossible to use `canDescs size` here"
    "Array of Integers — represents which cans are skipped from appearing in the 'unfound' command output."
    secrets := #(13) asSet.  "this is a set in order to theoretically allow adding more secret cans"
    "Counter of found cans — incremented when the player finds a new can."
    foundCount := 0.
    "Stores picked up items."
    items := Bag new.  "Bag of Symbols — easier access to item names for checks + descriptions aren't needed after picking up."

    "Display found item names or information about not having any."
    Inventory class >> displayItems [
        items isEmpty ifTrue: [
            Transcript showCr: 'You don''t have any items!'.
        ] ifFalse: [
            Transcript showCr: 'Your inventory:'.
            items do: [:each |
                Transcript showCr: '+ ' , (Utils colItem: each asString)
            ]
        ]
    ]
    "Display found cans and their descriptions or information about not having found any."
    Inventory class >> displayFound [
        (cans includes: true) ifFalse: [
            Transcript showCr: 'You haven''t found any cans yet!'.
        ] ifTrue: [
            Transcript showCr: 'Here''s a list of cans you have found:'.
            1 to: canDescs size do: [:i |
                (cans at: i) ifTrue: [
                    Transcript showCr: '+ ' , (canDescs at: i)
                ]
            ]
        ]
    ]
    "Display unfound can numbers or information about having found all.
    Excludes 'secret' cans, unless they're the only ones remaining."
    Inventory class >> displayUnfound [
        (cans includes: false) ifFalse: [Transcript showCr: 'You''ve found all of the cans!'.]
            ifTrue: [
                | i |
                i := 0.
                (cans allSatisfy: [:can |
                    i := i + 1.
                    can xor: (secrets includes: i)  "Either the can is found or is secret."
                ]) ifTrue: [Transcript showCr: 'There are some secret cans you''re still missing!'.]
                    ifFalse: [
                        Transcript showCr: 'Here''s a list of cans you haven''t found yet:'.
                        1 to: cans size do: [:i |
                            ((cans at: i) or: [secrets includes: i]) ifFalse: [
                                Transcript showCr: '- Can #' , i asString
                            ]
                        ]
                    ]
        ]
    ]

    "Add item to inventory."
    Inventory class >> addItem: item [
        item ifNotNil: [
            items add: item
        ]
    ]
    "Mark can as found and increment the counter."
    Inventory class >> foundCan: can [
        (cans at: can) ifFalse: [
            cans at: can put: true.
            foundCount := foundCount + 1.
        ].
    ]

    Inventory class >> foundCount [
        ^ foundCount
    ]
    Inventory class >> isCanFound: can [
        ^ cans at: can
    ]
    Inventory class >> hasItem: name [
        ^ items includes: name
    ]
]