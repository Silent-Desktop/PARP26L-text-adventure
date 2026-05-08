module State (GameState(..)) where

data GameState = GameState
  { dishwasherRunning :: Bool,
    stringFound :: Bool,
    cansFound :: [Bool],
    inventory :: [String],
    pickedUpKnifeInKitchen :: Bool,
    pickedUpChair :: Bool,
    pickedUpBoots :: Bool,
    pickedUpKeys :: Bool,
    actionCount :: Int,
    openedPaperBox :: Bool
  }
