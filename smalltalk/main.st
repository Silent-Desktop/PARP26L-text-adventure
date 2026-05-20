(Directory working) allFilesMatching: 'classes/rooms/*' do: [:f| FileStream fileIn: f name].
FileStream fileIn: 'classes/GameLoop.st'.
FileStream fileIn: 'classes/Utils.st'.


kitchen := Kitchen new.
livingRoom := LivingRoom new.
balcony := Balcony new.
"hall := Hall new."
"bathroom := Bathroom new."
"bedroom := Bedroom new."
"closet := Closet new."

kitchen connect: livingRoom.
"livingRoom connect: hall."
livingRoom connect: balcony.
"hall connect: bedroom."
"hall connect: bathroom."
"bedroom connect: closet."

introductionText := {
        'You are in your ' , (Utils colPlace: 'kitchen') , ', staring into your ' , (Utils colObject: 'fridge') , '.'.
        'Lately you''ve bought exactly 12 cans of your favourite energy drink to last you through the exam season.'.
        'You had some friends over last night and they must have decided on a prank to hide all of them from you,'.
        'because the ' , (Utils colObject: 'fridge') , ' is nearly empty without a single perfectly chilled can.'.
        'They''re not in the ' , (Utils colObject: 'fridge') , ', but they wouldn''t steal, so they must be around the house. Better get to searching!'.
    }.
Utils printLines: introductionText.

game := GameLoop start: kitchen.
game run.