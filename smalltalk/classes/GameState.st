FileStream fileIn: 'classes/Inventory.st'.

"GameState class

This class' fields and methods are static in order to allow global access (e.g. within interaction Blocks)
without the necessity to explicitly pass the state as an argument.

Responsibilities:
- keep track of 'locks'
- store the current Room instance
- count actions taken
- handle ending the game"

Object subclass: GameState [
    "The Room the player is currently in."
    currentRoom := nil.
    isGameOver := false.
    actionCount := 0.
    "Prerequisite actions other than finding a can/item."
    locks := LookupTable from: {
        #dishwasher -> true.
    }.

    GameState class >> setRoom: newRoom [
        currentRoom := newRoom.
    ]
    GameState class >> endGame [
        isGameOver := true
    ]
    "Proper game ending — called upon interacting with the fridge rather than the 'exit' command."
    GameState class >> endGameScreen [
        Transcript showCr: 'You''ve taken ' , actionCount asString , ' action(s).'.
        Transcript showCr: 'In total, you have found ' , Inventory foundCount asString , ' can(s).'.
        Transcript showCr: 'You have finished your search. Thank you for playing!'.
        self endGame.
    ]
    "Sad ending when you don't find any cans. :("
    GameState class >> sadEndGameScreen [
        actionCount = 1 ifTrue: [Transcript showCr: 'You''ve ended the game instantly.'.]
            ifFalse: [Transcript showCr: 'You''ve taken ' , actionCount asString , ' action(s). What for?'.].
        Transcript showCr: 'You haven''t found any of your cans. They must be here somewhere, right?'.
        Transcript showCr: 'You have abandoned your search. Maybe try again?'.
        self endGame.
    ]
    GameState class >> incAction [
        actionCount := actionCount + 1
    ]
    "Flag that the relevant prerequisite action is completed."
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
    GameState class >> isLocked: object [
        ^ locks at: object
    ]
]