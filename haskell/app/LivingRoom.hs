{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module LivingRoom
  ( handleLookLivingRoom,
    handleGoLivingRoom,
    handleInteractLivingRoom,
    handleTakeLivingRoom,
  )
where

import Rooms
import State (GameState (..))
import Utils (combineRest, updateCan)

handleTakeLivingRoom :: String -> GameState -> IO GameState
handleTakeLivingRoom input state = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "chair" ->
      if not (pickedUpChair state)
        then do
          putStrLn "You somehow manage to pick up the CHAIR. It's a bit weird to hold but you've done this before."
          let newInventory = inventory state ++ ["chair"]
          let newState = state {inventory = newInventory, pickedUpChair = True}
          return newState
        else do
          putStrLn "You're already holding it!"
          return state
    _ -> do
      putStrLn "No such item"
      return state

handleLookLivingRoom :: GameState -> IO GameState
handleLookLivingRoom state = do
  putStrLn
    "This is the living room, where you spend your free time and occasionaly nap.\n\
    \There is a COUCH here, it looks very comfortable with all its cushions and the fluffy blanket on top\n"
  if "chair" `notElem` inventory state
    then do
      putStrLn "There is a CHAIR here, just next to the table. Usually you'd just sit on it but sometimes you use it to reach higher places."
    else putStrLn ""
  stateWithCan <-
    if not (cansFound state !! 4)
      then do
        putStrLn
          "When you look at the table you see some used plates, a folded tablecloth and next to them, slightly obscured by an empty cup is Can #5!"
        pure $ updateCan 4 True state
      else pure state
  handleLookRestLivingRoom stateWithCan

handleLookRestLivingRoom :: GameState -> IO GameState
handleLookRestLivingRoom state = do
  putStrLn
    "You can see that from here you can reach kitchen\n\
    \You can see that from here you can reach balcony\n\
    \You can see that from here you can reach hall"
  return state

handleGoLivingRoom :: String -> GameState -> IO Room
handleGoLivingRoom input _ = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "kitchen" -> return Kitchen
    "balcony" -> return Balcony
    "hall" -> return Hall
    _ -> do
      putStrLn "No such room"
      return LivingRoom

handleInteractLivingRoom :: String -> GameState -> IO GameState
handleInteractLivingRoom input state = do
  let splitInput = words input
  case splitInput !! 1 of
    "couch" -> do
      putStrLn "You decide to take a break and sit down on the COUCH. The cushions are soft but there is something hard poking you in the hip. You reach under the blanket and find Can #4!"
      return (updateCan 3 True state)
    "table" -> do
      putStrLn "You're not planning to work right now and it's ways before dinner time so the table isn't really useful to you right now."
      return state
    _ -> do
      putStrLn "No such object here"
      return state