FileStream fileIn: 'classes/Room.st'.

Room subclass: LivingRoom [
    init [
        super init.
        name := 'living room'.
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
    LivingRoom class >> new [
        | x |
        x := super new.
        x init.
        ^x
    ]
]

"TODO: descriptions, interactions, inspections, items"