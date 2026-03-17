module Kitchen
  ( kitchen,
    handleInputKitchen,
    handleInteractionKitchen,
  )
where

import System.Exit (exitSuccess)
import Utils (GameState (..), combineRest, gameLoop, printCommands, showFound, showInventory, showUnfound, updateCan)

kitchen = gameLoop handleInputKitchen kitchen

handleInputKitchen :: String -> GameState -> IO ()
handleInputKitchen input state = do
  let splitInput = words input
  case head splitInput of
    "look" ->
      putStrLn
        "This is the kitchen. The countertops are clean and there are no dirty dishes in the sink. Clearly you've been busy or just haven't eaten in a long time.\n\
        \There is a DISHWASHER here, a true lifesaver since you hate washing the dishes by hand.\n\
        \There is a large CUPBOARD right at your eye-level and its slightly ajar.\n\
        \Next to your feet, there is a big square TRASHCAN, with its lid closed.\n\n\
        \There is a KNIFE on the countertop near the sink. It looks sharp.\n\n\
        \You can see that from here you can reach living_room\n"
    "go" ->
      if length splitInput < 2
        then putStrLn "Go where?"
        else case combineRest splitInput of
          "living room" -> do
            putStrLn "You into the living room."
            livingRoom state
          _ -> putStrLn "There is no such room"
    "interact" -> handleInteractionKitchen (splitInput !! 1) state
    "info" -> printCommands
    "found" -> showFound state
    "unfound" -> showUnfound state
    "inventory" -> showInventory state
    "take" -> handleTakeKitchen (splitInput !! 1) state
    "exit" -> do
      putStrLn "Exiting the game"
      exitSuccess
    _ -> putStrLn ("Unknown command: " ++ input)

handleTakeKitchen object state = do
  case object of
    "knife" -> do
      if not (pickedUpKnifeInKitchen state)
        then do
          putStrLn "You pick up the KNIFE. The handle is solid black and cold to the touch."
          let newInventory = inventory state ++ ["knife"]
          let newState = state {inventory = newInventory, pickedUpKnifeInKitchen = True}
          kitchen newState
        else
          putStrLn "You already picked up the knife earlier"
    _ -> putStrLn "No such object here"

handleInteractionKitchen :: String -> GameState -> IO ()
handleInteractionKitchen object state = do
  case object of
    "dishwasher" -> do
      if dishwasherRunning state
        then putStrLn "The dishwasher is rumbling and the little display is on - there's a wash cycle still going. You'l have to wait some time before opening it."
        else
          if not (head (cansFound state))
            then do
              putStrLn "The little display is off and the dishwasher isn't making any noises - the wash cycle must be done. You grab the handle and open the door. Inside it's still warm and humid. Between plates and pots you find Can #1!."
              let newState = updateCan 0 True state
              kitchen newState
            else
              putStrLn "The dishwasher has already been opened. The plates inside are drying. Can #1 used to be here."
    "cupboard" -> do
      if not (cansFound state !! 1)
        then
          if "chair" `elem` inventory state
            then do
              putStrLn "You climb the chair to reach the top shelf and grab Can #2!"
              let newState = updateCan 1 True state
              kitchen newState
            else
              putStrLn "You can see something on the top shelf but it's much too high for you to reach."
        else
          putStrLn "You look into the cupboard again but besides some clean cups and plates there''s nothing of interest anymore. Can #2 used to be on the top shelf."
    "trashcan" -> do
      if not (cansFound state !! 2)
        then do
          putStrLn "You grab the plastic lid and open the trashcan. Inside nestled between old takeout boxes and paper scraps is Can #3!"
          let newState = updateCan 2 True state
          kitchen newState
        else
          putStrLn "You open the trashcan again. Luckily there is no upleasant smell. Can #3 used to lie on the paper scraps here."
    _ -> kitchen state

handleInputLivingRoom :: String -> GameState -> IO ()
handleInputLivingRoom input state = do
  pure ()

livingRoom :: GameState -> IO ()
livingRoom = gameLoop handleInputLivingRoom livingRoom