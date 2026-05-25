 {-# LANGUAGE OverloadedStrings #-}

module Kitchen
  ( handleLookKitchen,
    handleGoKitchen,
    handleInteractKitchen,
    handleTakeKitchen,
    handleInspectKitchen,
  )
where

import Control.Monad qualified
import Data.Function ((&))
import Rooms (Room (Kitchen, LivingRoom))
import State (GameState (..))
import Utils (combineRest, updateCan, green, blue, yellow, magenta)
import System.Exit (exitSuccess)

handleLookKitchen :: GameState -> IO GameState
handleLookKitchen state = do
  putStr $
    "This is the " ++ yellow "kitchen" ++ ". The countertops are clean and there are no dirty dishes in the sink. Clearly you've been busy or just haven't eaten in a long time.\n\
    \There is a " ++ blue "dishwasher" ++ " here, a true lifesaver since you hate washing the dishes by hand.\n\
    \Your " ++ green "fridge" ++ " is here, without any chilled cans inside. Open it when you're done.\n\
    \There is a large " ++ green "cupboard" ++ " right at your eye-level and its slightly ajar.\n\
    \Next to your feet, there is a big square " ++ green "trashcan" ++", with its lid closed.\n"
  Control.Monad.unless (pickedUpKnifeInKitchen state) $ putStrLn $ "There is a " ++ blue "knife" ++ " on the countertop near the sink. It looks sharp.\n"
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
        putStrLn $ "You go into the " ++ yellow "living room"
        return LivingRoom
      _ -> do
        putStrLn "There is no such room"
        return Kitchen

-- handleInputKitchen :: String -> GameState -> IO ()
-- handleInputKitchen input state = do
--   let splitInput = words input
--   case head splitInput of
--     "interact" -> handleInteractionKitchen (splitInput !! 1) state
--     "info" -> printCommands
--     "found" -> showFound state
--     "unfound" -> showUnfound state
--     "inventory" -> showInventory state
--     "take" -> handleTakeKitchen (splitInput !! 1) state
--     "exit" -> do
--       putStrLn "Exiting the game"
--       exitSuccess
--     _ -> putStrLn ("Unknown command: " ++ input)

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
              putStrLn "You pick up the knife. The handle is solid black and cold to the touch."
              let newInventory = inventory state ++ ["knife"]
              let newState = state {inventory = newInventory, pickedUpKnifeInKitchen = True}
              return newState
            else do
              putStrLn "You already picked up the knife earlier"
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
      let object = splitInput !! 2
      case object of
        "dishwasher" -> do
          if dishwasherRunning state
            then do
              putStrLn "The dishwasher is rumbling and the little display is on - there's a wash cycle still going. You'l have to wait some time before opening it."
              return state
            else do
              if not (cansFound state !! 0)
                then do
                  putStrLn $ "The little display is off and the dishwasher isn't making any noises - the wash cycle must be done. You grab the handle and open the door. Inside it's still warm and humid. Between plates and pots you find " ++ magenta "Can #1" ++ "!"
                  let newState = updateCan 0 True state
                  return newState
                else do
                  putStrLn "The dishwasher has already been opened. The plates inside are drying. Can #1 used to be here."
                  return state
        "cupboard" -> do
          if not (cansFound state !! 1)
            then
              if "chair" `elem` inventory state
                then do
                  putStrLn $ "You climb the chair to reach the top shelf and grab " ++ magenta "Can #2" ++ "!"
                  let newState = updateCan 1 True state
                  return newState
                else do
                  putStrLn "You can see something on the top shelf but it's much too high for you to reach."
                  return state
            else do
              putStrLn "You look into the cupboard again but besides some clean cups and plates there''s nothing of interest anymore. Can #2 used to be on the top shelf."
              return state
        "trashcan" -> do
          if not (cansFound state !! 2)
            then do
              putStrLn $ "You grab the plastic lid and open the trashcan. Inside nestled between old takeout boxes and paper scraps is " ++ magenta "Can #3" ++ "!"
              let newState = updateCan 2 True state
              return newState
            else do
              putStrLn "You open the trashcan again. Luckily there is no upleasant smell. Can #3 used to lie on the paper scraps here."
              return state
        "fridge" -> do
          putStrLn "You open the fridge and return all the cans that you've found to their shelf. You're looking forward to enjoying a cold drink"
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
          putStrLn "This is your fridge. Inside there should be 12 cans of your favourite energy drink but your friends hid them around the house to prank you. When you''re done searching you should return here and put them back."
          pure state
        "cupboard" -> do
            if not (cansFound state !! 1)
              then do
                putStrLn "The cupboard is where you keep your plates and cups. However on the top shelf you can see something shiny. You will definetely need a chair to reach it."
                pure state
              else do
                putStrLn "Your plates and cups are still here. Luckily you didn''t break anything when trying to reach the top shelf."
                pure state
        "dishwasher" -> do
            if dishwasherRunning state
              then do
                putStrLn "The little display is flashing some numbers and you can hear rumbling and water sloshing inside. It might be a good idea to just take nap instead of waiting here for it to finish."
                pure state
              else do
                putStrLn "The wash cycle has finished, the little display is off and there are no more rumbling noises coming from inside."
                pure state
        _ -> do
          putStrLn "No such object here"
          return state