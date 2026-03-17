module Main where

import GameLoop (kitchen)
import State (GameState (..))
import Utils (printCommands)

main :: IO ()
main = do
  let state = GameState {dishwasherRunning = True, cansFound = replicate 8 False, inventory = [], pickedUpKnifeInKitchen = False, pickedUpChair = False}
  putStrLn "You are in your kitchen, staring into your fridge. Lately you've bought exactly 12 cans of your favourite energy drink to last you through the exam season. You had some friends over last night and they must have decided on a prank to hide all of them from you, because the fridge is nearly empty without a single perfectly chilled can. They're not in the fridge but they wouldn't steal so they must be around the house. Better get to searching!"
  printCommands
  kitchen state
