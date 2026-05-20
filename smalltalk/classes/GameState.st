FileStream fileIn: 'classes/Inventory.st'.

Object subclass: GameState [
    currentRoom := nil.
    isGameOver := false.
    actionCount := 0.
    inventory := Inventory new.
    locks := Dictionary from: {
        'dishwasher' -> true.
    }.

    GameState class >> setRoom: newRoom [
        currentRoom := newRoom.
    ]
    GameState class >> endGame [
        isGameOver := true
    ]
    GameState class >> endGameScreen [
        Transcript showCr: 'You''ve taken ' , actionCount asString , ' action(s).'.
        Transcript showCr: 'In total, you have found ' , inventory foundCount asString , ' can(s).'.
        Transcript showCr: 'You have finished your search. Thank you for playing!'.
        self endGame.
    ]
    GameState class >> incAction [
        actionCount := actionCount + 1
    ]
    GameState class >> unlock: key [
        locks at: key put: false.
    ]

    GameState class >> isGameOver [
        ^isGameOver
    ]
    GameState class >> actionCount [
        ^actionCount
    ]
    GameState class >> currentRoom [
        ^currentRoom
    ]
    GameState class >> inventory [
        ^inventory
    ]
    GameState class >> isLocked: object [
        ^ locks at: object
    ]
]