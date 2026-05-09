module Kitchen
  ( handleLookKitchen,
    handleGoKitchen,
    handleInteractKitchen,
    handleTakeKitchen,
    handleInspectKitchen,
  )
where

import Control.Monad qualified
import Rooms (Room (Kitchen, LivingRoom))
import State (GameState (..))
import System.Exit (exitSuccess)
import Utils (blue, combineRest, green, magenta, updateCan, yellow)

handleLookKitchen :: GameState -> IO GameState
handleLookKitchen state = do
  putStrLn $ "This is the " ++ yellow "kitchen" ++ ". The countertops are clean and there are no dirty dishes in the sink."
  putStrLn $ "There is a " ++ green "DISHWASHER" ++ " here, a true lifesaver since you hate washing the dishes by hand."
  putStrLn $ "There is a large " ++ green "CUPBOARD" ++ " right at your eye-level and its slightly ajar."
  putStrLn $ "Next to your feet, there is a big square " ++ green "TRASHCAN" ++ ", with its lid closed."

  Control.Monad.unless (pickedUpKnifeInKitchen state) $
    putStrLn $
      "There is a " ++ blue "KNIFE" ++ " on the countertop near the sink. It looks sharp.\n"

  putStrLn $ "You can see that from here you can reach the " ++ yellow "living room" ++ "\n"
  return state

handleGoKitchen :: String -> GameState -> IO Room
handleGoKitchen input _ = do
  let splitInput = words input
  if length splitInput < 3
    then do
      putStrLn "Go to where?"
      return Kitchen
    else case combineRest splitInput 2 of
      "living room" -> do
        putStrLn $ "You go into the " ++ yellow "living room" ++ "."
        return LivingRoom
      _ -> do
        putStrLn "There is no such room"
        return Kitchen

handleTakeKitchen :: String -> GameState -> IO GameState
handleTakeKitchen input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Take what?"
      return state
    else do
      let object = splitInput !! 1
      case object of
        "knife" -> do
          if not (pickedUpKnifeInKitchen state)
            then do
              putStrLn $ "You pick up the " ++ blue "KNIFE" ++ ". The handle is solid black and cold to the touch."
              let newInventory = inventory state ++ ["knife"]
              let newState = state {inventory = newInventory, pickedUpKnifeInKitchen = True}
              return newState
            else do
              putStrLn $ "You already picked up the " ++ blue "knife" ++ " earlier"
              return state
        _ -> do
          putStrLn "No such object here"
          return state

handleInteractKitchen :: String -> GameState -> IO GameState
handleInteractKitchen input state = do
  let splitInput = words input
  if length splitInput < 3
    then do
      putStrLn "Interact with what?"
      return state
    else do
      let object = combineRest splitInput 2
      case object of
        "dishwasher" -> do
          if dishwasherRunning state
            then do
              putStrLn $ "The " ++ green "dishwasher" ++ " is rumbling—there's a wash cycle still going."
              return state
            else do
              if not (cansFound state !! 0)
                then do
                  putStrLn $ "The wash cycle is done. You open the " ++ green "dishwasher" ++ " and find " ++ magenta "Can #1" ++ "!"
                  let newState = updateCan 0 True state
                  return newState
                else do
                  putStrLn $ "The " ++ green "dishwasher" ++ " has already been opened. " ++ magenta "Can #1" ++ " used to be here."
                  return state
        "cupboard" -> do
          if not (cansFound state !! 1)
            then
              if "chair" `elem` inventory state
                then do
                  putStrLn $ "You climb the " ++ blue "chair" ++ " to reach the top shelf of the " ++ green "cupboard" ++ " and grab " ++ magenta "Can #2" ++ "!"
                  let newState = updateCan 1 True state
                  return newState
                else do
                  putStrLn $ "You can see something on the top shelf of the " ++ green "cupboard" ++ " but it's much too high for you to reach."
                  return state
            else do
              putStrLn $ "You look into the " ++ green "cupboard" ++ " again. " ++ magenta "Can #2" ++ " used to be on the top shelf."
              return state
        "trashcan" -> do
          if not (cansFound state !! 2)
            then do
              putStrLn $ "You open the " ++ green "trashcan" ++ ". Inside you find " ++ magenta "Can #3" ++ "!"
              let newState = updateCan 2 True state
              return newState
            else do
              putStrLn $ "You open the " ++ green "trashcan" ++ " again. " ++ magenta "Can #3" ++ " used to lie here."
              return state
        "fridge" -> do
          putStrLn $ "You open the " ++ green "fridge" ++ " and return all the cans to their shelf."
          putStrLn ("You've taken " ++ show (actionCount state) ++ " action(s)")
          putStrLn ("In total you have found " ++ show (length (filter id (cansFound state))) ++ " can(s).")
          putStrLn "You have finished your search. Thank you for playing."
          exitSuccess
        _ -> return state

handleInspectKitchen :: String -> GameState -> IO GameState
handleInspectKitchen input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Inspect what?"
      return state
    else do
      let rest = combineRest splitInput 1
      case rest of
        "fridge" -> do
          putStrLn $ "This is your " ++ green "FRIDGE" ++ ". Return here when you find all the cans."
          pure state
        "cupboard" -> do
          if not (cansFound state !! 1)
            then do
              putStrLn $ "The " ++ green "CUPBOARD" ++ " has something shiny on the top shelf. You might need a " ++ blue "chair" ++ "."
              pure state
            else do
              putStrLn $ "Your plates and cups are still here in the " ++ green "CUPBOARD" ++ "."
              pure state
        "dishwasher" -> do
          if dishwasherRunning state
            then do
              putStrLn $ "The " ++ green "dishwasher" ++ " is currently running."
              pure state
            else do
              putStrLn $ "The " ++ green "dishwasher" ++ " wash cycle has finished."
              pure state
        _ -> do
          putStrLn "No such object here"
          return state