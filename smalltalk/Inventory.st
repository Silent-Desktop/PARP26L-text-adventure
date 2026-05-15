FileStream fileIn: 'Utils.st'.

Object subclass: Inventory [
    | items cans |
    canDescs := #(
        'Can #1: There are pictures of butterflies on it. The drink flavour is disgustingly peachy.'
        'Can #2: There are drawings of fish and underwater algae all the way around it. You''re pretty sure the flavour is pineapple.'
        'Can #3: It''s a vivid neon green colour. It''s the best flavour — sour apple.'
        'Can #4: It''s pink in colour and the drink is probably strawberry flavoured.'
        'Can #5: The colour of it is a really bright, cheerful yellow. There''s some drawings on it as well, but they''re pretty meaningless. The flavour is bad.'
        'Can #6: It''s a uniform, soft, pinkish-orange colour. The drink tastes like peach and lemon.'
        'Can #7: It has a gold coating with sparkling silver details. It''s reeeaaally shiny. The drink tastes like cream soda.'
        'Can #8: It''s a really bright pastel pink. The drink inside tastes like bubblegum.'
        'Can #9: It''s black with some green gradient. There''s ''NITRO'' written at the bottom. Why did you buy this flavour?'
        'Can #10: It''s black with red details. The drink flavour is cherry.'
        'Can #11: Completely white with some grey shading and silver details. You''re not sure what the flavour is supposed to be.'
        'Can #12: It''s a deep purple colour with some vines drawn around it. The drink flavour is most likely grape.'
        'Can #13: Lucky #13! You found the bonus secret can. Congrats!'
    ).
    secrets := #(13) asSet.
    Inventory class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
    init [
        items := Bag new.
        cans := Array new: canDescs size withAll: false.
    ]
    displayItems [
        Transcript showCr: 'Your inventory:'.
        items do: [:each |
            Transcript showCr: each
        ]
    ]
    displayFound [
        Transcript showCr: 'Here''s a list of ' , (Utils magenta: 'cans') , ' you have found:'.
        1 to: canDescs size do: [:i |
            (cans at: i) ifTrue: [
                Transcript showCr: '+ ' , (canDescs at: i)
            ]
        ]
    ]
    displayUnfound [
        Transcript showCr: 'Here''s a list of ' , (Utils magenta: 'cans') , ' you haven''t found yet:'.
        1 to: canDescs size do: [:i |
            ((cans at: i) or: [secrets includes: i]) ifFalse: [
                Transcript showCr: '- Can #' , i asString
            ]
        ]
    ]
]

"TODO: implement taking items"