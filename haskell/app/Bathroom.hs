module Bathroom
  ( handleLookBathroom,
    handleGoBathroom,
    handleInteractBathroom,
    handleTakeBathroom,
    handleInspectBathroom,
  )
where

import Control.Monad qualified
import Rooms
import State (GameState (..))
import Utils (blue, combineRest, green, magenta, updateCan, yellow)

handleTakeBathroom :: String -> GameState -> IO GameState
handleTakeBathroom input state = do
  let splitInput = words input
  let rest = combineRest splitInput 1
  case rest of
    "towel" -> do
      if not (pickedUpTowel state)
        then do
          putStrLn $ "You pick up the " ++ blue "towel" ++ ". It cold and wet to the touch. It still hasn't dried."
          let newInventory = inventory state ++ ["towel"]
          let newState = state {inventory = newInventory, pickedUpTowel = True}
          return newState
        else do
          putStrLn $ "You already picked up the " ++ blue "towel" ++ " earlier"
          return state
    _ -> do
      putStrLn "No such item"
      return state

handleLookBathroom :: GameState -> IO GameState
handleLookBathroom state = do
  putStrLn $ "This is the " ++ yellow "bathroom" ++ " and it looks scrubbed clean. You must have been very bored lately"
  if not (cansFound state !! 6)
    then do
      putStrLn $ "Your " ++ green "shower" ++ " is here. The walls are clear glass. On a shelf you keep your shampoo bottles. Are there more of them than usual...?"
    else do
      putStrLn $ "Your " ++ green "shower" ++ " is here. The walls are clear glass. On a shelf you keep your shampoo bottles."

  putStrLn $ "There is a " ++ green "sink" ++ " here, with nothing on it."
  putStrLn $ "There is a " ++ green "toilet" ++ " here, also very clean."

  Control.Monad.unless (pickedUpTowel state) $
    putStrLn $
      "Theres a " ++ blue "towel" ++ " here, hanging from the top of the shower door."

  putStrLn $ "You can see that from here you can reach the " ++ yellow "hall"
  return state

handleGoBathroom :: String -> GameState -> IO Room
handleGoBathroom input _ = do
  let splitInput = words input
  let rest = combineRest splitInput 2
  case rest of
    "hall" -> do
      putStrLn $ "You go into the " ++ yellow "hall" ++ "."
      return Hall
    _ -> do
      putStrLn "No such room"
      return Bathroom

handleInspectBathroom :: String -> GameState -> IO GameState
handleInspectBathroom input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Inspect what?"
      return state
    else do
      case splitInput !! 1 of
        "sink" -> do
          putStrLn $ "It's the bathroom " ++ green "sink" ++ " perfectly clean and almost sparkling."
          return state
        "toilet" -> do
          putStrLn $ "It's the " ++ green "toilet" ++ ". It makes a funny noise when you flush it."
          return state
        "shower" -> do
          if not (cansFound state !! 12)
            then do
              putStrLn $ "You walk into the " ++ green "shower" ++ ". After taking a closer look one of the bottles turns out to be " ++ magenta "Can #13"
              pure $ updateCan 12 True state
            else do
              putStrLn $ "You've already looked the " ++ green "shower" ++ " up and down. " ++ magenta "Can #13" ++ " used to be hidden here."
              pure state
        _ -> do
          putStrLn "No such object here"
          return state

handleInteractBathroom :: String -> GameState -> IO GameState
handleInteractBathroom input state = do
  let splitInput = words input
  if length splitInput < 3
    then do
      putStrLn "Interact with what?"
      return state
    else do
      case splitInput !! 2 of
        "shower" -> do
          putStrLn $ "You grab the " ++ green "shower" ++ " nozzle and turn on the water. It wets your socks."
          return state
        "sink" -> do
          putStrLn $ "You turn on the water in the " ++ green "sink" ++ " to rinse your hands."
          return state
        "toilet" -> do
          putStrLn $ "You pull up the " ++ green "toilet" ++ " seat. You flush it and it makes a gurgling sound."
          return state
        _ -> do
          putStrLn "No such object here"
          return state