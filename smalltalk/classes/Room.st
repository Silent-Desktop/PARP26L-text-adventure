"Classes usually used by the room subclasses:"
FileStream fileIn: 'classes/Utils.st'.
FileStream fileIn: 'classes/Item.st'.
FileStream fileIn: 'classes/Interactable.st'.
FileStream fileIn: 'classes/GameState.st'.
FileStream fileIn: 'classes/Inventory.st'.

Object subclass: Room [
    | name visited desc interactables hiddenInteracts items hiddenItems exits |
    init [
        name := String new.
        visited := false.
        desc := { String new. }.
        exits := LookupTable new.  "Symbol -> Room"
        items := LookupTable new.  "Symbol -> Item"
        hiddenItems := LookupTable new.  "Symbol -> Item"
        interactables := SortedCollection new.  "SortedCollection of Symbol -> Interactable Associations in order to manipulate order"
        hiddenInteracts := LookupTable new.  "Symbol -> Interactable"
    ]
    getName [
        ^name
    ]
    visit [
        visited ifFalse: [ self look ].
        visited := true.
    ]
    addExit: destRoom [
        exits at: destRoom getName asSymbol put: destRoom
    ]
    connect: destRoom [
        self addExit: destRoom.
        destRoom addExit: self.
    ]
    revealItem: itemName [
        items add: (hiddenItems associationAt: itemName).
        hiddenItems removeKey: itemName.
    ]
    revealInteract: objName [
        interactables add: (hiddenInteracts associationAt: objName).
        hiddenInteracts removeKey: objName.
    ]
    go: dest [
        (exits includesKey: dest) ifTrue: [
            Transcript showCr: 'You go to the ' , (Utils colPlace: dest asString) , '.'.
            (exits at: dest) visit.
            ^exits at: dest
        ] ifFalse: [
            Transcript showCr: 'There is no such room!'.
            ^self
        ]
    ]
    printDesc [
        Utils printLines: desc.
    ]
    showInteracts [
        interactables do: [:interactable |
            Transcript showCr: interactable value desc.
        ].
    ]
    interactsCr [
        interactables size = 0 ifFalse: [ Transcript cr. ].
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
        self showInteracts.
        self interactsCr.
        self showItems.
        self itemsCr.
        self showExits.
    ]
    take: item [
        | removed |
        removed := items removeKey: item ifAbsent: [
            Transcript showCr: 'No such ', (Utils colItem: 'item'), ' here!'.
            ^ nil
        ].
        removed take.
        ^ item
    ]
    check: objectName ifPresentValue: closure [
        | object |
        object := interactables detect: [:assoc | assoc key = objectName] ifNone: [
            Transcript showCr: 'No such ' , (Utils colObject: 'object') , ' here!'.
            ^ nil
        ].
        object ifNotNil: [ closure value: object value ].
    ]
    interact: objectName [
        self check: objectName ifPresentValue: [:object | object interact ].
    ]
    inspect: objectName [
        self check: objectName ifPresentValue: [:object | object inspect ].
    ]
]