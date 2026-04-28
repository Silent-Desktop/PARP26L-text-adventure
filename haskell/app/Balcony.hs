{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module Balcony
  ( handleLookBalcony,
    handleGoBalcony,
    handleInteractBalcony,
    handleTakeBalcony,
    handleInspectBalcony
  )
where

import Rooms
import State (GameState (..))
import Utils (combineRest, updateCan)

handleTakeBalcony :: String -> GameState -> IO GameState
handleTakeBalcony input state = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "_" -> do
      putStrLn "No such item"
      return state

handleLookBalcony :: GameState -> IO GameState
handleLookBalcony state = do
  putStrLn "On the floor in the corner there is a large potted PLANT. It''s most likely a fern but you never bothered to make sure. It''s leaves are large and sprawling."
  putStrLn "The balcony has a thick metal RAILING and right now there are a couple of towels hanging from it."
  putStrLn "You can see that from here you can reach living room"
  return state

handleGoBalcony :: String -> GameState -> IO Room
handleGoBalcony input _ = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "living room" -> return Balcony
    "_" -> do
      putStrLn "No such room"
      return Balcony

handleInspectBalcony :: GameState -> IO GameState
handleInspectBalcony state = do
  putStrLn "Over the edge of the RAILING there is a thin STRING hanging. Its tied to one of the metal bars and its pulled."
  return state

handleInteractBalcony :: String -> GameState -> IO GameState
handleInteractBalcony input state = do
  let splitInput = words input
  case splitInput !! 1 of
    "plant" -> do
      stateWithCan <-
        if not (cansFound state !! 7)
          then do
            putStrLn "You squat down to touch the plant. After some searching under its many leaves you find Can #7!"
            pure $ (updateCan 7 True state)
        else do
          putStrLn "You ruffle the plants leaves again but besides a couple of dried petals and small bugs nothing of interest falls out. Can #3 used to be hidden below the leaves."
          pure state
      return stateWithCan
    "string" -> do
      stateWithCan <-
        if not (cansFound state !! 6)
          then do
            putStrLn "You grab the string at the edge of the railing and start gently pulling. There is something heavy tied to it. Finally you grab a hold of Can #6!"
            pure $ updateCan 6 True state
          else do
            putStrLn "Can #6 used to be here"
            pure state
      return stateWithCan
    "_" -> do
      putStrLn "No such object here"
      return state