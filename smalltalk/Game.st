FileStream fileIn: 'Utils.st'.
FileStream fileIn: 'Inventory.st'.
FileStream fileIn: 'Room.st'.
FileStream fileIn: 'Kitchen.st'.
FileStream fileIn: 'LivingRoom.st'.


Object subclass: Game [
    | isGameOver actionCount currentRoom inventory|

    introductionText := 'You are in your ' , (Utils yellow: 'kitchen') , ', staring into your ' , (Utils green: 'fridge') , '. Lately you''ve bought exactly 12 ' , (Utils magenta: 'cans') , ' of your favourite energy drink to last you through the exam season. You had some friends over last night and they must have decided on a prank to hide all of them from you, because the ' , (Utils green: 'fridge') , ' is nearly empty without a single perfectly chilled ' , (Utils magenta: 'can') , '. They''re not in the ' , (Utils green: 'fridge') , ', but they wouldn''t steal, so they must be around the house. Better get to searching!'.

    instructionsText := {
        'Commands:'.
        'info                     -- prints this message'.
        'go to [' , (Utils yellow: 'place') , ']            -- go to that place'.
        'take [' , (Utils blue: 'object') , ']            -- to pick up an object'.
        'look around              -- to look around you again'.
        'interact with [' , (Utils green: 'setpiece') , '] -- to interact with something in the scene.'.
        'inspect [' , (Utils green: 'setpiece') , ']       -- to take a closer look at something.'.
        'inventory                -- to check what items you have'.
        'found                    -- to check which trophies you''ve already found'.
        'unfound                  -- to check which trophies you''re still missing'.
        'exit                     -- to end the game and quit'.
        'The goal of the game is to find as many ' , (Utils magenta: 'cans') , ' as possible hidden around the house.'.
        'When you think you''re done, return to the ' , (Utils yellow: 'kitchen') , ' and interact with the ' , (Utils green: 'fridge') , ' for the final score.'.
    }.
 
    Game class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]

    init [
        isGameOver := false.
        actionCount := 0.
        inventory := Inventory new.
    ]

    setRoom: newRoom [
        currentRoom := newRoom.
    ]

    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript showCr: string ]
    ]

    printIntroduction [
       Transcript showCr: introductionText.
    ]

    printInstructions [
        self printLines: instructionsText.
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine
    ]

    "Run the game."
    run [
        | cmd isUnknown |

        self printIntroduction.
        self printInstructions.

        "Game loop."
        [isGameOver] whileFalse: [
            isUnknown := true.
            cmd := self readCommand subStrings.
            cmd first = 'info' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].
            cmd first = 'go' ifTrue: [ "TODO"
                Transcript showCr: 'Go white boy, go!'.
                isUnknown := false
            ].
            cmd first = 'take' ifTrue: [ "TODO"
                Transcript showCr: 'You take something.'.
                isUnknown := false
            ].
            cmd first = 'look' ifTrue: [
                currentRoom look.
                isUnknown := false
            ].
            cmd first = 'interact' ifTrue: [ "TODO"
                Transcript showCr: 'You interact with something.'.
                isUnknown := false
            ].
            cmd first = 'inspect' ifTrue: [ "TODO"
                Transcript showCr: 'You inspect something.'.
                isUnknown := false
            ].
            cmd first = 'inventory' ifTrue: [
                inventory displayItems.
                isUnknown := false
            ].
            cmd first = 'found' ifTrue: [
                inventory displayFound.
                isUnknown := false
            ].
            cmd first = 'unfound' ifTrue: [
                inventory displayUnfound.
                isUnknown := false
            ].
            cmd first = 'exit' ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].
            isUnknown ifTrue: [
                Transcript showCr: 'Unknown command: ' , cmd
            ] ifFalse: [
                actionCount := actionCount + 1
            ]
        ]
    ]
]


kitchen := Kitchen new.
livingRoom := LivingRoom new.

kitchen connect: livingRoom.

game := Game new.
game setRoom: kitchen.
game run.
