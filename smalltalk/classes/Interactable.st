"Interactable class

Responsibilities:
- store object description displayed with the 'look' command
- store BlockClosures to be executed with the 'inspect' and 'interact' commands (or simple Strings to be displayed)"

Object subclass: Interactable [
    | desc interactBlock inspectBlock |
    "Interactable constructor
    Arguments:
    - `desc`: String
    - `interaction`: BlockClosure or String
    - `inspection`: BlockClosure or String
    `interaction`/`inspection` Strings are converted into a simple `[Transcript showCr: aString]` BlockClosure."
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

    "Execute the relevant code blocks."
    interact [
        interactBlock value
    ]
    inspect [
        inspectBlock value
    ]

    desc [
        ^desc
    ]
]