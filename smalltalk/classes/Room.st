"Classes usually used by the room subclasses:"
FileStream fileIn: 'classes/Utils.st'.
FileStream fileIn: 'classes/Item.st'.
FileStream fileIn: 'classes/Interactable.st'.
FileStream fileIn: 'classes/GameState.st'.
FileStream fileIn: 'classes/Inventory.st'.

Object subclass: Room [
    | name visited desc interactables items hiddenItems exits |
    init [
        name := String new.
        visited := false.
        desc := { String new. }.
        exits := Dictionary new.  "String -> Room"
        items := Dictionary new.  "String -> Item"
        hiddenItems := Dictionary new.  "String -> Item"
        interactables := Dictionary new.  "String -> Interactable"
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
    revealItem: itemName [
        items add: (hiddenItems associationAt: itemName).
        hiddenItems removeKey: itemName.
    ]
    go: destStr [
        (exits includesKey: destStr) ifTrue: [
            Transcript showCr: 'You go to the ' , (Utils colPlace: destStr) , '.'.
            (exits at: destStr) visit.
            ^exits at: destStr
        ] ifFalse: [
            Transcript showCr: 'There is no such room!'.
            ^self
        ]
    ]
    printDesc [
        Utils printLines: desc.
    ]
    showItems [
        items do: [:item |
            Transcript showCr: item lookDesc.
        ].
    ]
    itemsCr [
        items size = 0 ifFalse: [ Transcript cr. ].
    ]
    showExits [
        Transcript showCr: 'From here you can go to:'.
        exits keys do: [:roomName |
            Transcript showCr: '- ' , (Utils colPlace: roomName).
        ]
    ]
    look [
        self printDesc.
        Transcript cr.
        self showItems.
        self itemsCr.
        self showExits.
    ]
    take: item [
        Transcript showCr: ((items removeKey: item ifAbsent: [
            Transcript showCr: 'No such ' , (Utils colItem: 'item') , ' here!'.
            ^ nil
        ]) takeDesc).
        ^ item
    ]
    check: objectName ifPresentValue: closure [
        | object |
        object := interactables at: objectName ifAbsent: [
            Transcript showCr: 'No such ' , (Utils colObject: 'object') , ' here!'.
            ^ nil
        ].
        object ifNotNil: [ closure value: object ].
    ]
    interact: objectName [
        self check: objectName ifPresentValue: [:object | object interact ].
    ]
    inspect: objectName [
        self check: objectName ifPresentValue: [:object | object inspect ].
    ]
]