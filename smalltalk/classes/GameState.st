FileStream fileIn: 'classes/Inventory.st'.

Object subclass: GameState [
    | isGameOver actionCount currentRoom inventory locks |

    GameState class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
    init [
        isGameOver := false.
        actionCount := 0.
        inventory := Inventory new.
        locks := Dictionary from: {
            'dishwasher' -> true.
        }.
    ]

    setRoom: newRoom [
        currentRoom := newRoom.
    ]
    endGame [
        isGameOver := true
    ]
    endGameScreen [
        Transcript showCr: 'You''ve taken ' , actionCount asString , ' action(s).'.
        Transcript showCr: 'In total, you have found ' , inventory foundCount asString , ' can(s).'.
        Transcript showCr: 'You have finished your search. Thank you for playing!'.
        self endGame.
    ]
    incAction [
        actionCount := actionCount + 1
    ]
    unlock: key [
        locks at: key put: false.
    ]

    isGameOver [
        ^isGameOver
    ]
    actionCount [
        ^actionCount
    ]
    currentRoom [
        ^currentRoom
    ]
    inventory [
        ^inventory
    ]
    isLocked: object [
        ^ locks at: object
    ]
]