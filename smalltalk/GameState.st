FileStream fileIn: 'Inventory.st'.

Object subclass: GameState [
    | isGameOver actionCount currentRoom inventory|

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
    ]

    setRoom: newRoom [
        currentRoom := newRoom.
    ]
    endGame [
        isGameOver := true
    ]
    incAction [
        actionCount := actionCount + 1
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
]