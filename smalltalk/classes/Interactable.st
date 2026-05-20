Object subclass: Interactable [
    | desc interactBlock inspectBlock |

    Interactable class >> desc: aDesc interaction: anIntBlock inspection: anInspBlock [
        | x |
        x := super new.
        x init: aDesc interaction: anIntBlock inspection: anInspBlock.
        ^x
    ]

    init: aDesc interaction: anIntBlock inspection: anInspBlock [
        desc := aDesc.
        interactBlock := anIntBlock.
        inspectBlock := anInspBlock.
    ]

    desc [
        ^desc
    ]
    interact [
        interactBlock value
    ]
    inspect [
        inspectBlock value
    ]
]