{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module Bedroom
  ( handleLookBedroom,
  handleGoBedroom,
  handleInteractBedroom,
  handleTakeBedroom,
  )
where

import Rooms
import State (GameState (..))
import Utils (combineRest, updateCan)

handleTakeBedroom :: String -> GameState -> IO GameState
handleTakeBedroom input state = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "house keys"-> do
      if not (pickedUpKeys state) 
        then do
          putStrLn "You pick up the house_keys and they fit neatly in your back pocket."
          let newInventory = inventory state ++ ["keys"]
          let newState = state{pickedUpKeys=True,inventory=newInventory}
          return newState
        else do
          putStrLn "You already picked up the keys earlier"
          return state
    _ -> do
      putStrLn "No such item"
      return state

handleLookBedroom :: GameState -> IO GameState
handleLookBedroom state = do
  putStrLn
    "This is the bedroom, where you spend most of your time. The blind are shut but there is a small desk lamp illuminating the room.\n\
    \There is a DESK pushed up against the wall. This is where you work during the day.\n\
    \You left your HOUSE KEYS on the desk. Right now they're in plain view but often they get lost amoung your notes and books.\n\
    \Your BED is in the far corner of the room. It''s messy and unmade, the usual sight given your sleep schedule."
  putStrLn "You can see that from here you can reach the hall\n"
  return state

handleGoBedroom :: String -> GameState -> IO Room
handleGoBedroom input _ = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "hall" -> return Hall
    "closet" -> return Closet
    _ -> do
      putStrLn "No such room"
      return Bedroom

handleInteractBedroom :: String -> GameState -> IO GameState
handleInteractBedroom input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Interact with what?"
      return state
    else do
      case splitInput !! 1 of
        "bed" -> do
          stateWithDishwasher <-
            if dishwasherRunning state
              then do
                putStrLn "Despite being unmade the bed looks really inviting. You lie down and the moment your cheek touches the pillow you drift off for a nap.\n\
                  \You wake up sometime later, unsure what time it is really is. The house is quiet, even the rumble of the dishwasher in the kitchen has stopped."
                pure $ state {dishwasherRunning = False}
              else do
                putStrLn "Without clear reason you lie down for a nap again. But you already had one today so it's much harder to fall asleep. After a while of tossing and turning you get back up."
                pure state
          return stateWithDishwasher
        "desk" -> do
          stateWithCan <-
            if not (cansFound state !! 7)
              then do
                putStrLn "You sit down at your desk determined to read through some of your notes. After sifting through piles of paper you reach for a book. Before you can even open it you notice Can #8 was hiding behind it!"
                pure $ updateCan 7 True state
              else do
                putStrLn "You've already looked through your notes and books, creating an even bigger mess. Can #8 used to be hidden behind some books"
                pure state
          return stateWithCan
        _ -> do
          putStrLn "No such object here"
          return state
