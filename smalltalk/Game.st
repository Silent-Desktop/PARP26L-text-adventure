FileStream fileIn: 'Utils.st'.

Object subclass: Game [
    | isGameOver |

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
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false
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
            cmd first = 'go' ifTrue: [
                Transcript showCr: 'Go white boy, go!'.
                isUnknown := false
            ].
            cmd first = 'take' ifTrue: [
                Transcript showCr: 'You take something.'.
                isUnknown := false
            ].
            cmd first = 'look' ifTrue: [
                Transcript showCr: 'You look around.'.
                isUnknown := false
            ].
            cmd first = 'interact' ifTrue: [
                Transcript showCr: 'You interact with something.'.
                isUnknown := false
            ].
            cmd first = 'inspect' ifTrue: [
                Transcript showCr: 'You inspect something.'.
                isUnknown := false
            ].
            cmd first = 'inventory' ifTrue: [
                Transcript showCr: 'Your inventory is empty.'.
                isUnknown := false
            ].
            cmd first = 'found' ifTrue: [
                Transcript showCr: 'You have found nothing.'.
                isUnknown := false
            ].
            cmd first = 'unfound' ifTrue: [
                Transcript showCr: 'You have not found everything.'.
                isUnknown := false
            ].
            cmd first = 'exit' ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].
            isUnknown ifTrue: [
                Transcript showCr: 'Unknown command: ' , cmd
            ]
        ]
    ]
]

Game new run.
