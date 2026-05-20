Object subclass: Interactable [
    | interactBlock inspectBlock |

    Interactable class >> interaction: anIntBlock inspection: anInspBlock [
        | x |
        x := super new.
        x init: anIntBlock inspection: anInspBlock.
        ^x
    ]

    init: anIntBlock inspection: anInspBlock [
        interactBlock := anIntBlock.
        inspectBlock := anInspBlock.
    ]

    interact [
        interactBlock value
    ]
    inspect [
        inspectBlock value
    ]
]