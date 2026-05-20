FileStream fileIn: 'classes/Utils.st'.
FileStream fileIn: 'classes/GameState.st'.
FileStream fileIn: 'classes/Inventory.st'.

Object subclass: GameLoop [
    instructionsText := {
        'Commands:'.
        'info                    -- prints this message'.
        'go to [' , (Utils colPlace: 'place') , ']           -- go to that ' , (Utils colPlace: 'place').
        'take [' , (Utils colItem: 'item') , ']             -- to pick up an ' , (Utils colItem: 'item').
        'look around             -- to look around you again'.
        'interact with [' , (Utils colObject: 'object') , ']  -- to interact with ' , (Utils colObject: 'something') , ' in the scene.'.
        'inspect [' , (Utils colObject: 'object') , ']        -- to take a closer look at ' , (Utils colObject: 'something') , '.'.
        'inventory               -- to check what ' , (Utils colItem: 'items') , ' you have'.
        'found                   -- to check which cans you''ve already found'.
        'unfound                 -- to check which cans you''re still missing'.
        'exit                    -- to end the game and quit'.
        'The goal of the game is to find as many cans as possible hidden around the house.'.
        'When you think you''re done, return to the ' , (Utils colPlace: 'kitchen') , ' and interact with the ' , (Utils colObject: 'fridge') , ' for the final score.'.
    }.
    commands := #(
        #info:
        #go:
        #take:
        #look:
        #interact:
        #inspect:
        #inventory:
        #found:
        #unfound:
        #exit:
    ).
 
    GameLoop class >> start: room [
        | x |
        x := super new.
        x init: room.
        ^x
    ]

    init: room [
        GameState setRoom: room.
    ]

    printInstructions [
        Utils printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    info: cmd [
        self printInstructions
    ]

    go: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 2 failMsg: 'Go to ' , (Utils colPlace: 'where') , '?'.
        target ifNotNil: [ GameState setRoom: (GameState currentRoom go: target asSymbol) ]
    ]

    take: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 1 failMsg: 'Take ' , (Utils colItem: 'what') , '?'.
        target ifNotNil: [ Inventory addItem: (GameState currentRoom take: target asSymbol) ].
    ]

    look: cmd [
        GameState currentRoom look
    ]

    interact: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 2 failMsg: 'Interact with ' , (Utils colObject: 'what') , '?'.
        target ifNotNil: [ GameState currentRoom interact: target asSymbol ].
    ]

    inspect: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 1 failMsg: 'Inspect ' , (Utils colObject: 'what') , '?'.
        target ifNotNil: [ GameState currentRoom inspect: target asSymbol ].
    ]

    inventory: cmd [
        Inventory displayItems.
    ]

    found: cmd [
        Inventory displayFound.
    ]

    unfound: cmd [
        Inventory displayUnfound.
    ]

    exit: cmd [
        GameState endGame.
    ]

    "Run the game loop."
    run [
        | cmd cmdMethod |
        Transcript cr.
        self printInstructions.
        Transcript cr.
        GameState currentRoom visit.
        [GameState isGameOver] whileFalse: [
            cmd := self readCommand subStrings.
            cmdMethod := (cmd first,':') asSymbol.
            (commands includes: cmdMethod) ifTrue: [
                GameState incAction.
                self perform: cmdMethod with: cmd
            ] ifFalse: [
                Transcript showCr: 'Unknown command: ' , cmd first
            ]
        ]
    ]
]