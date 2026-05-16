FileStream fileIn: 'classes/Room.st'.

Room subclass: RoomName [
    init [
        super init.
        name := ''.
        desc := {
            ''.
        }.
        interactables := Dictionary from: {
            '' -> (Interactable interaction: [:state |

            ] inspection: [:state |

            ]).
        }.
        items := Dictionary from: {
            '' -> (Item look: '' take: '').
        }.
    ]
    RoomName class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"