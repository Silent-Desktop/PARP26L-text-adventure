Object subclass: Room [
    | name visited desc interactables items exits |
    init [
        name := String new.
        visited := false.
        desc := { String new. }.
        exits := Dictionary new.
        items := Dictionary new.
        interactables := Dictionary new.
    ]
    getName [
        ^name
    ]
    visit [
        visited ifFalse: [ self look ].
        visited := true.
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
            Transcript showCr: 'You go to the ' , Utils colPlace: destStr , '.'.
            (exits at: destStr) visit.
            ^exits at: destStr
        ] ifFalse: [
            Transcript showCr: 'There is no such room!'.
            ^self
        ]
    ]
    look [
        Utils printLines: desc.
        Transcript cr.
        items values do: [:item |
            Transcript showCr: item lookDesc.
        ].
        items size = 0 ifFalse: [ Transcript cr. ].
        Transcript showCr: 'From here you can go to:'.
        exits keys do: [:roomName |
            Transcript showCr: '- ' , (Utils colPlace: roomName).
        ]
    ]
    take: item [
        Transcript showCr: ((items removeKey: item ifAbsent: [
            Transcript showCr: 'No such item here!'.
            ^ nil
        ]) takeDesc).
        ^ item
    ]
    interact: object withState: state [
        ^(interactables at: object ifAbsent: [
            Transcript showCr: 'No such object here!'.
            ^ nil
        ]) value: state
    ]
]