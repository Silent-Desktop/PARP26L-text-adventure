{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

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
import Utils (combineRest, updateCan)

handleTakeBathroom :: String -> GameState -> IO GameState
handleTakeBathroom input state = do
  let splitInput = words input
  let rest = combineRest splitInput 1
  case rest of
    "towel" -> do
      if not (pickedUpTowel state)
        then do
          putStrLn "You pick up the towel. It cold and wet to the touch. It still hasn''t dried."
          let newInventory = inventory state ++ ["towel"]
          let newState = state {inventory = newInventory, pickedUpTowel = True}
          return newState
        else do
          putStrLn "You already picked up the towel earlier"
          return state
    _ -> do
      putStrLn "No such item"
      return state

handleLookBathroom :: GameState -> IO GameState
handleLookBathroom state = do
  putStrLn "This is the bathroom and it looks scrubbed clean. You must have been very bored lately"
  --   TODO correct can or state
  if not (cansFound state !! 6)
    then do
      putStrLn "Your shower is here. The walls are clear glass but they're a bit cloudy since you haven't cleaned them in a while. On a shelf built into the wall you keep your shampoo bottles. Are there more of them than usual...?"
    else do
      putStrLn "Your shower is here. The walls are clear glass but they're a bit cloudy since you haven't cleaned them in a while. On a shelf built into the wall you keep your shampoo bottles."
  putStrLn "There is a sink here, with nothing on it. You must have put everything away to make it cleaner."
  putStrLn "There is a toilet here, also very clean. You had guests over so you had to scrub the bathroom."
  Control.Monad.unless (pickedUpTowel state) $ putStrLn "Theres a towel here, hanging from the top of the shower door. It's still a bit wet and you can see a few drops of water hit the tiles below it."
  putStrLn "You can see that from here you can reach the hall"
  return state

handleGoBathroom :: String -> GameState -> IO Room
handleGoBathroom input _ = do
  let splitInput = words input
  let rest = combineRest splitInput 2
  case rest of
    "hall" -> do
      putStrLn "You go into the hall."
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
          putStrLn "It's the bathroom sink perfectly clean and almost sparkling. So far there haven't been any leaks."
          return state
        "toilet" -> do
          putStrLn "It's the toilet. It makes a funny noise when you flush it."
          return state
        "shower" -> do
          if not (cansFound state !! 6)
            then do
              putStrLn "You walk into the shower, careful not to wet your socks on the moist floor. There's a sponge here and some shampoo and conditioner bottles on a built-in shelf. After taking a closer look one of the bottles turns out to be Can #7"
              pure $ updateCan 6 True state
            else do
              putStrLn "You've already looked the shower up and down and there isn't anything else of note here. Can #7 used to be hidden bewteen your shampoo bottles."
              pure state

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
          putStrLn "You grab the shower nozle and turn on the water. It splashes a bit and wets your socks."
          return state
        "sink" -> do
          putStrLn "You turn on the water to rinse your hands. It's pleasantly cold and leaves droplets on the white porcelain."
          return state
        "toilet" -> do
          putStrLn "You pull up the seat to check for any uncleaned spots. Luckily you''ve been diligent so the white porcelain is spotless. You flush the toilet and it does indeed make a funny gurgling sound."
          return state
        _ -> do
          putStrLn "No such object here"
          return state