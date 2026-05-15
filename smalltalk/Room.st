Object subclass: Room [
    | name exits |
    init [
        exits := Dictionary new.
    ]
    getName [
        ^name
    ]
    addExit: destRoom [
        exits at: destRoom getName put: destRoom
    ]
    connect: destRoom [
        self addExit: destRoom.
        destRoom addExit: self.
    ]
    go: destStr [
        (exits includesKey: destStr) ifTrue: [
            Transcript showCr: 'You go to the ' , Utils yellow: destStr , '.'.
            ^exits at: destStr
        ] ifFalse: [
            Transcript showCr: 'There is no such room!'.
            ^self
        ]
    ]
    look [
        Transcript showCr: 'From here you can go to:'.
        exits keys do: [:roomName |
            Transcript showCr: '- ' , roomName.
        ]
    ]
]