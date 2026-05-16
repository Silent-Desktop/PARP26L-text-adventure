FileStream fileIn: 'Utils.st'.

Object subclass: Inventory [
    | items cans foundCount |
    canDescs := {
        (Utils colCan: 'Can #1') , ': There are pictures of butterflies on it. The drink flavour is disgustingly peachy.'.
        (Utils colCan: 'Can #2') , ': There are drawings of fish and underwater algae all the way around it. You''re pretty sure the flavour is pineapple.'.
        (Utils colCan: 'Can #3') , ': It''s a vivid neon colObject colour. It''s the best flavour — sour apple.'.
        (Utils colCan: 'Can #4') , ': It''s pink in colour and the drink is probably strawberry flavoured.'.
        (Utils colCan: 'Can #5') , ': The colour of it is a really bright, cheerful colPlace. There''s some drawings on it as well, but they''re pretty meaningless. The flavour is bad.'.
        (Utils colCan: 'Can #6') , ': It''s a uniform, soft, pinkish-orange colour. The drink tastes like peach and lemon.'.
        (Utils colCan: 'Can #7') , ': It has a gold coating with sparkling silver details. It''s reeeaaally shiny. The drink tastes like cream soda.'.
        (Utils colCan: 'Can #8') , ': It''s a really bright pastel pink. The drink inside tastes like bubblegum.'.
        (Utils colCan: 'Can #9') , ': It''s black with some colObject gradient. There''s ''NITRO'' written at the bottom. Why did you buy this flavour?'.
        (Utils colCan: 'Can #10') , ': It''s black with red details. The drink flavour is cherry.'.
        (Utils colCan: 'Can #11') , ': Completely white with some grey shading and silver details. You''re not sure what the flavour is supposed to be.'.
        (Utils colCan: 'Can #12') , ': It''s a deep purple colour with some vines drawn around it. The drink flavour is most likely grape.'.
        (Utils colCan: 'Can #13') , ': Lucky #13! You found the bonus secret can. Congrats!'.
    }.
    secrets := #(13) asSet.  "this is a set in order to theoretically allow adding more secret cans"
    Inventory class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
    init [
        items := Bag new.  "Bag of Strings — easier access to item names for checks + descriptions aren't needed after picking up."
        cans := Array new: canDescs size withAll: false.
        foundCount := 0.
    ]
    displayItems [
        Transcript showCr: 'Your inventory:'.
        items do: [:each |
            Transcript showCr: '+ ' , (Utils colItem: each)
        ]
    ]
    displayFound [
        Transcript showCr: 'Here''s a list of ' , (Utils colCan: 'cans') , ' you have found:'.
        1 to: canDescs size do: [:i |
            (cans at: i) ifTrue: [
                Transcript showCr: '+ ' , (canDescs at: i)
            ]
        ]
    ]
    displayUnfound [
        Transcript showCr: 'Here''s a list of ' , (Utils colCan: 'cans') , ' you haven''t found yet:'.
        1 to: canDescs size do: [:i |
            ((cans at: i) or: [secrets includes: i]) ifFalse: [
                Transcript showCr: '- ' , (Utils colCan: 'Can #' , i asString)
            ]
        ]
    ]
    addItem: item [
        item ifNotNil: [
            items add: item
        ]
    ]
    foundCan: can [
        can ifNotNil: [
            cans at: can put: true.
        ].
        foundCount := foundCount + 1.
    ]
    foundCount [
        ^ foundCount
    ]
    ifCanFound: can [
        ^ cans at: can
    ]
    hasItem: name [
        ^ items includes: name
    ]
]

"TODO: implement taking items"