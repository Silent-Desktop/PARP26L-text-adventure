FileStream fileIn: 'Kitchen.st'.
FileStream fileIn: 'LivingRoom.st'.
FileStream fileIn: 'GameLoop.st'.
FileStream fileIn: 'Utils.st'.


kitchen := Kitchen new.
livingRoom := LivingRoom new.

kitchen connect: livingRoom.

introductionText := {
        'You are in your ' , (Utils yellow: 'kitchen') , ', staring into your ' , (Utils green: 'fridge') , '.'.
        'Lately you''ve bought exactly 12 ' , (Utils magenta: 'cans') , ' of your favourite energy drink to last you through the exam season.'.
        'You had some friends over last night and they must have decided on a prank to hide all of them from you,'.
        'because the ' , (Utils green: 'fridge') , ' is nearly empty without a single perfectly chilled ' , (Utils magenta: 'can') , '.'.
        'They''re not in the ' , (Utils green: 'fridge') , ', but they wouldn''t steal, so they must be around the house. Better get to searching!'.
    }.
Utils printLines: introductionText.

game := GameLoop start: kitchen.
game run.