module State (GameState(..)) where

data GameState = GameState
  { dishwasherRunning :: Bool,
    cansFound :: [Bool],
    inventory :: [String],
    pickedUpKnifeInKitchen :: Bool,
    pickedUpChair :: Bool
  }
