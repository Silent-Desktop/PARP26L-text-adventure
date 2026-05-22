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
        (anIntBlock respondsTo: #value) ifTrue: [
            interactBlock := anIntBlock
        ] ifFalse: [
            interactBlock := [Transcript showCr: anIntBlock]
        ].
        (anInspBlock respondsTo: #value) ifTrue: [
            inspectBlock := anInspBlock
        ] ifFalse: [
            inspectBlock := [Transcript showCr: anInspBlock]
        ].
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