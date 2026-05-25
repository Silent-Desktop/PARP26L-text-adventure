FileStream fileIn: 'classes/Utils.st'.
FileStream fileIn: 'classes/GameState.st'.
FileStream fileIn: 'classes/Inventory.st'.

"GameLoop class

Responsibilities:
- handle game loop
- handle command inputs"

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
    "Symbols for allowed commands (in order to prevent the player from executing other class methods)."
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

    "GameLoop constructor — requires providing an instance of a starting Room."
    GameLoop class >> start: room [
        | x |
        x := super new.
        x init: room.
        ^x
    ]
    init: room [
        GameState setRoom: room.
    ]

    "Basic I/O methods."
    printInstructions [
        Utils printLines: instructionsText.
    ]
    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    "Handle the 'info' command by printing instructions."
    info: cmd [
        self printInstructions
    ]
    "Handle the 'go to' command: check number of words, change current room if target is valid."
    go: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 2 failMsg: 'Go to ' , (Utils colPlace: 'where') , '?'.
        target ifNotNil: [ GameState setRoom: (GameState currentRoom go: target asSymbol) ]
    ]
    "Handle the 'take' command: check number of words, pick up item if target is valid."
    take: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 1 failMsg: 'Take ' , (Utils colItem: 'what') , '?'.
        target ifNotNil: [ Inventory addItem: (GameState currentRoom take: target asSymbol) ].
    ]
    "Handle the 'look' command: print the current room description."
    look: cmd [
        GameState currentRoom look
    ]
    "Handle the 'interact with' command: check number of words, interact with target if valid."
    interact: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 2 failMsg: 'Interact with ' , (Utils colObject: 'what') , '?'.
        target ifNotNil: [ GameState currentRoom interact: target asSymbol ].
    ]
    "Handle the 'inspect' command: check number of words, inspect target if valid."
    inspect: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 1 failMsg: 'Inspect ' , (Utils colObject: 'what') , '?'.
        target ifNotNil: [ GameState currentRoom inspect: target asSymbol ].
    ]
    "Handle the 'inventory' command: print list of items."
    inventory: cmd [
        Inventory displayItems.
    ]
    "Handle the 'found' command: print list of found cans."
    found: cmd [
        Inventory displayFound.
    ]
    "Handle the 'unfound' command: print list of unfound cans."
    unfound: cmd [
        Inventory displayUnfound.
    ]
    "Handle the 'exit' command: end game (without the ending score screen)."
    exit: cmd [
        GameState endGame.
    ]

    "Run the game loop until the game ends. Check if input command is supported.
    Commands are parsed as a collection of words, the first words determines the handling method.
    Prepositions like 'around', 'to', 'with' are ignored to allow shorthand inputs."
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