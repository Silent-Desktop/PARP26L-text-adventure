module Kitchen
  ( handleLookKitchen,
    handleGoKitchen,
    handleInteractionKitchen,
    handleTakeKitchen,
  )
where

import Control.Monad qualified
import Rooms (Room (Kitchen, LivingRoom))
import State (GameState (..))
import Utils (combineRest, updateCan)
import System.Exit (exitSuccess)

handleLookKitchen :: GameState -> IO GameState
handleLookKitchen state = do
  putStrLn
    "This is the kitchen. The countertops are clean and there are no dirty dishes in the sink. Clearly you've been busy or just haven't eaten in a long time.\n\
    \There is a DISHWASHER here, a true lifesaver since you hate washing the dishes by hand.\n\
    \There is a large CUPBOARD right at your eye-level and its slightly ajar.\n\
    \Next to your feet, there is a big square TRASHCAN, with its lid closed.\n"
  Control.Monad.unless (pickedUpKnifeInKitchen state) $ putStrLn "There is a KNIFE on the countertop near the sink. It looks sharp.\n"
  putStrLn "You can see that from here you can reach the LIVING ROOM\n"
  return state

handleGoKitchen :: String -> GameState -> IO Room
handleGoKitchen input _ = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Go where?"
      return Kitchen
    else case combineRest splitInput of
      "living room" -> do
        putStrLn "You into the living room."
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
              putStrLn "You pick up the KNIFE. The handle is solid black and cold to the touch."
              let newInventory = inventory state ++ ["knife"]
              let newState = state {inventory = newInventory, pickedUpKnifeInKitchen = True}
              return newState
            else do
              putStrLn "You already picked up the knife earlier"
              return state
        _ -> do
          putStrLn "No such object here"
          return state

handleInteractionKitchen :: String -> GameState -> IO GameState
handleInteractionKitchen input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Interact with what?"
      return state
    else do
      let object = splitInput !! 1
      case object of
        "dishwasher" -> do
          if dishwasherRunning state
            then do
              putStrLn "The dishwasher is rumbling and the little display is on - there's a wash cycle still going. You'l have to wait some time before opening it."
              return state
            else
              if not (cansFound state !! 0)
                then do
                  putStrLn "The little display is off and the dishwasher isn't making any noises - the wash cycle must be done. You grab the handle and open the door. Inside it's still warm and humid. Between plates and pots you find Can #1!."
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
                  putStrLn "You climb the chair to reach the top shelf and grab Can #2!"
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
              putStrLn "You grab the plastic lid and open the trashcan. Inside nestled between old takeout boxes and paper scraps is Can #3!"
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
