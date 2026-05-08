{-# OPTIONS_GHC -Wno-incomplete-patterns #-}

module Hall
  ( handleLookHall,
    handleGoHall,
    handleInteractHall,
    handleTakeHall,
    handleInspectHall
  )
where

import Rooms
import State (GameState (..))
import Utils (combineRest, updateCan)

handleTakeHall :: String -> GameState -> IO GameState
handleTakeHall input state = do
  let splitInput = words input
  let rest = combineRest splitInput 1
  case rest of
    "boots" ->
      if not (pickedUpBoots state)
        then do
          putStrLn "You pick up the BOOTS and get some mud on your hands. Yuck."
          let newInventory = inventory state ++ ["boots"]
          let newState = state {inventory = newInventory, pickedUpBoots = True}
          if not (cansFound newState !! 10)
            then do
              putStrLn "When you rotate on of the boots something cylindrical falls out into your hand. It's Can #11!"
              pure $ updateCan 10 True newState
            else do
              pure newState
        else do
          putStrLn "You're already holding it!"
          return state
    _ -> do
      putStrLn "No such item"
      return state

handleLookHall :: GameState -> IO GameState
handleLookHall state = do
  putStrLn "This is the hall, where you keep your coats and shoes. There's some unvacuumed sand on the tiled floor."
  putStrLn "There is a pair of your heavy duty BOOTS here. They're still covered with wet mud from outside."
  putStrLn "The HOUSE DOOR to your apartment is here and it''s currently locked."
  return state

handleGoHall :: String -> GameState -> IO Room
handleGoHall input _ = do
  let splitInput = words input
  let rest = combineRest splitInput 2
  case rest of
    "bedroom" -> do
      putStrLn "You go into the bedroom."
      return Bedroom
    "bathroom" -> do
      putStrLn "You go into the bathroom."
      return Bathroom
    "living room" -> do
      putStrLn "You go into the living room."
      return LivingRoom
    _ -> do
      putStrLn "No such room"
      return Hall

handleInteractHall :: String -> GameState -> IO GameState
handleInteractHall input state = do
  let splitInput = words input
  if length splitInput < 3
    then do
      putStrLn "Interact with what?"
      return state
    else do
      let rest = combineRest splitInput 2
      case rest of
        "house door" -> do
          putStrLn "You stand in front of the door of your apartment"
          if not (pickedUpKeys state)
            then do
              putStrLn "The door is locked and with your current equipment there isn't much you can do about it."
              return state
            else do
              if not (cansFound state !! 11)
                then do
                  putStrLn "You pull out the house keys and use them to easily open both locks. The door is now open. On your doorstep you find Can #12! You lock the door again."
                  pure $ updateCan 11 True state
                else do
                  putStrLn "You once again open the door. Can #12 used to be here, on your doormat."
                  pure state
        _ -> do
          putStrLn "No such object here"
          return state


handleInspectHall :: String -> GameState -> IO GameState
handleInspectHall input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Inspect what?"
      return state
    else do
      let rest = combineRest splitInput 1
      case rest of
        "house door" -> do
            if not (cansFound state !! 10)
              then do
                putStrLn "The HOUSE DOOR is a solid ash grey color and the locks are pretty standard. You always make sure to lock it so you''ll need keys if you want to look out into the corridor."
                pure state
              else do
                putStrLn "The HOUSE DOOR is locked once again and there is no need for you to go outside right now."
                pure state
        _ -> do
          putStrLn "No such object here"
          return state