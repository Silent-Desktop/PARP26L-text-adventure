module Main where

import GameLoop (roomFunc)
import Rooms (Room (Kitchen))
import State (GameState (..))
import Utils (green, printCommands)

main :: IO ()
main = do
  let state = GameState {pickedUpTowel = False, openedPaperBox = False, actionCount = 0, dishwasherRunning = True, cansFound = replicate 12 False, inventory = [], pickedUpKnifeInKitchen = False, pickedUpChair = False, pickedUpBoots = False, pickedUpKeys = False, stringFound = False, houseKeysFound = False}
  printCommands
  putStrLn $ "You are in your kitchen, staring into your " ++ green "fridge" ++ ". Lately you've bought exactly 12 cans of your favourite energy drink to last you through the exam season. You had some friends over last night and they must have decided on a prank to hide all of them from you, because the " ++ green "fridge" ++ " is nearly empty without a single perfectly chilled can. They're not in the " ++ green "fridge" ++ " but they wouldn't steal so they must be around the house. Better get to searching!"
  roomFunc Kitchen state
