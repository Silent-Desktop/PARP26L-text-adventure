{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module Bedroom
  ( handleLookBedroom,
    handleGoBedroom,
    handleInteractBedroom,
    handleTakeBedroom,
    handleInspectBedroom,
  )
where

import Rooms
import State (GameState (..))
import Utils (blue, combineRest, green, magenta, updateCan, yellow)

handleTakeBedroom :: String -> GameState -> IO GameState
handleTakeBedroom input state = do
  let splitInput = words input
  let rest = combineRest splitInput 1
  case rest of
    _ -> do
      putStrLn "No such item"
      return state

handleLookBedroom :: GameState -> IO GameState
handleLookBedroom state = do
  putStrLn $
    "This is the "
      ++ yellow "bedroom"
      ++ ", where you spend most of your time. The blind are shut but there is a small desk lamp illuminating the room.\n\
         \There is a "
      ++ green "DESK"
      ++ " pushed up against the wall. This is where you work during the day.\n\
         \Your "
      ++ green "BED"
      ++ " is in the far corner of the room. It's messy and unmade, the usual sight given your sleep schedule."
  putStrLn $ "You can see that from here you can reach the " ++ yellow "hall" ++ "\n"
  putStrLn $ "You can see that from here you can reach the " ++ yellow "closet" ++ "\n"
  return state

handleGoBedroom :: String -> GameState -> IO Room
handleGoBedroom input _ = do
  let splitInput = words input
  let rest = combineRest splitInput 2
  case rest of
    "hall" -> do
      putStrLn $ "You go into the " ++ yellow "hall" ++ "."
      return Hall
    "closet" -> do
      putStrLn $ "You go into the " ++ yellow "closet" ++ "."
      return Closet
    _ -> do
      putStrLn "No such room"
      return Bedroom

handleInteractBedroom :: String -> GameState -> IO GameState
handleInteractBedroom input state = do
  let splitInput = words input
  if length splitInput < 3
    then do
      putStrLn "Interact with what?"
      return state
    else do
      case splitInput !! 2 of
        "bed" -> do
          if dishwasherRunning state
            then do
              putStrLn $
                "Despite being unmade the "
                  ++ green "bed"
                  ++ " looks really inviting. You lie down and the moment your cheek touches the pillow you drift off for a nap.\n\
                     \You wake up sometime later, unsure what time it is really is. The house is quiet, even the rumble of the dishwasher in the "
                  ++ yellow "kitchen"
                  ++ " has stopped."
              let newState = state {dishwasherRunning = False}
              return newState
            else do
              putStrLn $ "Without clear reason you lie down for a nap on the " ++ green "bed" ++ " again. But you already had one today so it's much harder to fall asleep. After a while of tossing and turning you get back up."
              return state
        "desk" -> do
          if not (cansFound state !! 7)
            then do
              putStrLn $ "You sit down at your " ++ green "desk" ++ " determined to read through some of your notes. After sifting through piles of paper you reach for a book. Before you can even open it you notice " ++ magenta "Can #8" ++ " was hiding behind it!"
              pure $ updateCan 7 True state
            else do
              putStrLn $ "You've already looked through your notes and books on the " ++ green "desk" ++ ", creating an even bigger mess. " ++ magenta "Can #8" ++ " used to be hidden behind some books."
              pure state
        _ -> do
          putStrLn "No such object here"
          return state

handleInspectBedroom :: String -> GameState -> IO GameState
handleInspectBedroom input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Inspect what?"
      return state
    else do
      case splitInput !! 1 of
        "bed" -> do
          if dishwasherRunning state
            then do
              putStrLn $ "You inspect the blankets and pillows on your " ++ green "BED" ++ ". You made it this morning so everything is nice, tidy, and flat. The fluffy covers and soft pillows look very inviting."
              pure state
            else do
              putStrLn $ "You look at the " ++ green "BED" ++ " again. The blankets are no longer neatly folded and the pillows are clearly out of place. The nap you had must've been really good."
              pure state
        "desk" -> do
          if not (cansFound state !! 7)
            then do
              putStrLn $ "You take a closer look at the pile of notes. You're prepping for exams so your " ++ green "desk" ++ " is full of notes and loose pens. It looks like there's something hidden behind the large stack of books to the side..."
              pure state
            else do
              putStrLn $ "You look at your notes again. The " ++ green "DESK" ++ " is even more of a mess now since you rearranged it. " ++ magenta "Can #8" ++ " used to be hidden behind some books here."
              pure state
        _ -> do
          putStrLn "No such object here"
          return state