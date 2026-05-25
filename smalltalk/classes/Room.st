"Classes used by the Room subclasses:"
FileStream fileIn: 'classes/Utils.st'.
FileStream fileIn: 'classes/Item.st'.
FileStream fileIn: 'classes/Interactable.st'.
FileStream fileIn: 'classes/GameState.st'.
FileStream fileIn: 'classes/Inventory.st'.

"Room class

Responsibilities:
- keep track of having been already visited
- store name and description
- manage Items and Interactables contained within the room
- represent Rooms and pathways between them"

Object subclass: Room [
    | name visited desc interactables hiddenInteracts items hiddenItems exits |
    "Room is intended as an abstract class, even though the subclasses rarely override its methods.
    Representing the various rooms as subclasses allows us to keep the `main.st` script rather clean.
    Theoretically, it also allows easily creating duplicates of rooms in case of extending or creating a custom game.
    The `items`/`interactables` collections store Associations keyed by their respective object instance names.
    As a result, the Item/Interactable classes don't have a `name` field, since it'd be redundant storage."
    init [
        name := String new.
        visited := false.
        "Array of Strings — describes the Room itself in the 'look' command output."
        desc := { String new. }.
        "Stores Room instances accessible from this instance."
        exits := LookupTable new.  "Symbol -> Room"
        "Stores Items available for the `take` command."
        items := LookupTable new.  "Symbol -> Item"
        "Stores Items that are hidden in the room and untargetable by player commands until revealed."
        hiddenItems := LookupTable new.  "Symbol -> Item"
        "Stores objects the player can `interact with` or `inspect`."
        interactables := SortedCollection new.  "SortedCollection of Symbol -> Interactable Associations in order to manipulate order for proper display"
        "Stores Interactables that are hidden in the room and untargetable by player commands until revealed."
        hiddenInteracts := LookupTable new.  "Symbol -> Interactable"
    ]

    "Add a Room instance you can go to from this instance."
    addExit: destRoom [
        exits at: destRoom getName asSymbol put: destRoom
    ]
    "Connect two Rooms both ways."
    connect: destRoom [
        self addExit: destRoom.
        destRoom addExit: self.
    ]

    "Called during 'go' command handling.
    Display 'look' command output upon entering the room for the first time.
    Display just the exits otherwise."
    visit [
        visited ifFalse: [
            self look.
            visited := true.
        ] ifTrue: [self showExits.].
    ]
    "Return target room if valid or self otherwise."
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
    "Display (non-hidden) Interactable descriptions.
    Interactables are stored (and displayed) in alphabetic order of their Association Symbols.
    Properly adjusting those Symbols allows displaying descriptions of
    e.g. relative positions to another Interactable in a logical order."
    showInteracts [
        interactables do: [:interactable |
            Transcript showCr: interactable value desc.
        ].
    ]
    "Print an empty separating line if any Interactables are to be displayed."
    interactsCr [
        interactables size = 0 ifFalse: [ Transcript cr. ].
    ]
    "Display (non-hidden) Item descriptions.
    Ideally, they shouldn't contain descriptions relative to other Items,
    since those wouldn't make much sense once the mentioned Item gets picked up."
    showItems [
        items do: [:item |
            Transcript showCr: item lookDesc.
        ].
    ]
    "Print an empty separating line if any Items are to be displayed."
    itemsCr [
        items size = 0 ifFalse: [ Transcript cr. ].
    ]
    "Display valid 'go' command destinations."
    showExits [
        Transcript showCr: 'From here you can go to:'.
        exits keys do: [:roomName |
            Transcript showCr: '- ' , (Utils colPlace: roomName).
        ]
    ]
    "Display relevant information for the 'look' command."
    look [
        self printDesc.
        self showInteracts.
        self interactsCr.
        self showItems.
        self itemsCr.
        self showExits.
    ]

    "Move an Item from `hiddenItems` to `items`."
    revealItem: itemName [
        items add: (hiddenItems associationAt: itemName).
        hiddenItems removeKey: itemName.
    ]
    "Move an Interactable from `hiddenInteracts` to `interactables`."
    revealInteract: objName [
        interactables add: (hiddenInteracts associationAt: objName).
        hiddenInteracts removeKey: objName.
    ]
    "Take an Item from the Room.
    Remove the Item from `items`.
    Execute the Item's `take` BlockClosure (usually just displays a String).
    Return an Item or `nil` if invalid."
    take: item [
        | removed |
        removed := items removeKey: item ifAbsent: [
            Transcript showCr: 'No such ', (Utils colItem: 'item'), ' here!'.
            ^ nil
        ].
        removed take.
        ^ item
    ]
    "Check if the target Interactable exists.
    Execute the passed closure if present.
    Return `nil` if absent.
    Implementing this method was necessary because of `interactables` being
    an OrderedCollection of Associations rather than a LookupTable."
    check: objectName ifPresentValue: closure [
        | object |
        object := interactables detect: [:assoc | assoc key = objectName] ifNone: [
            Transcript showCr: 'No such ' , (Utils colObject: 'object') , ' here!'.
            ^ nil
        ].
        object ifNotNil: [ closure value: object value ].
    ]
    "Execute an Interactable's `interact` BlockClosure."
    interact: objectName [
        self check: objectName ifPresentValue: [:object | object interact ].
    ]
    "Execute an Interactable's `inspect` BlockClosure."
    inspect: objectName [
        self check: objectName ifPresentValue: [:object | object inspect ].
    ]

    getName [
        ^name
    ]
]