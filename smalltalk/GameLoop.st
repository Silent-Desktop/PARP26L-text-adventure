FileStream fileIn: 'Utils.st'.
FileStream fileIn: 'GameState.st'.

Object subclass: GameLoop [
    | state |

    instructionsText := {
        'Commands:'.
        'info                    -- prints this message'.
        'go to [' , (Utils colPlace: 'place') , ']           -- go to that ' , (Utils colPlace: 'place').
        'take [' , (Utils colItem: 'item') , ']             -- to pick up an ' , (Utils colItem: 'item').
        'look around             -- to look around you again'.
        'interact with [' , (Utils colObject: 'object') , ']  -- to interact with ' , (Utils colObject: 'something') , ' in the scene.'.
        'inspect [' , (Utils colObject: 'object') , ']        -- to take a closer look at ' , (Utils colObject: 'something') , '.'.
        'inventory               -- to check what ' , (Utils colItem: 'items') , ' you have'.
        'found                   -- to check which ' , (Utils colCan: 'cans') , ' you''ve already found'.
        'unfound                 -- to check which ' , (Utils colCan: 'cans') , ' you''re still missing'.
        'exit                    -- to end the game and quit'.
        'The goal of the game is to find as many ' , (Utils colCan: 'cans') , ' as possible hidden around the house.'.
        'When you think you''re done, return to the ' , (Utils colPlace: 'kitchen') , ' and interact with the ' , (Utils colObject: 'fridge') , ' for the final score.'.
    }.

    cmdHandlers := Dictionary from: {
        'info' -> #handleInfo:.
        'go' -> #handleGo:.
        'take' -> #handleTake:.
        'look' -> #handleLook:.
        'interact' -> #handleInteract:.
        'inspect' -> #handleInspect:.
        'inventory' -> #handleInventory:.
        'found' -> #handleFound:.
        'unfound' -> #handleUnfound:.
        'exit' -> #handleExit:.
    }.
 
    GameLoop class >> start: room [
        | x |
        x := super new.
        x init: room.
        ^x
    ]

    init: room [
        state := GameState new.
        state setRoom: room.
    ]

    printInstructions [
        Utils printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    handleInfo: cmd [
        self printInstructions
    ]

    handleGo: cmd [
        Transcript showCr: 'Go white boy, go!'.
    ]

    handleTake: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 1 failMsg: 'Take ' , (Utils colItem: 'what') , '?'.
        target ifNotNil: [ state inventory addItem: (state currentRoom take: target) ].
    ]

    handleLook: cmd [
        state currentRoom look.
    ]

    handleInteract: cmd [
        | target |
        target := Utils cmdTarget: cmd skipWords: 2 failMsg: 'Interact with ' , (Utils colObject: 'what') , '?'.
        target ifNotNil: [ state currentRoom interact: target withState: state ].
    ]

    handleInspect: cmd [
        Transcript showCr: 'You inspect something.'.
    ]

    handleInventory: cmd [
        state inventory displayItems.
    ]

    handleFound: cmd [
        state inventory displayFound.
    ]

    handleUnfound: cmd [
        state inventory displayUnfound.
    ]

    handleExit: cmd [
        state endGame.
    ]

    "Run the game loop."
    run [
        | cmd |
        Transcript cr.
        self printInstructions.
        Transcript cr.
        state currentRoom visit.
        [state isGameOver] whileFalse: [
            cmd := self readCommand subStrings.
            (cmdHandlers includesKey: cmd first) ifTrue: [
                state incAction.
                self perform: (cmdHandlers at: cmd first) with: cmd
            ] ifFalse: [
                Transcript showCr: 'Unknown command: ' , cmd first
            ]
        ]
    ]
]