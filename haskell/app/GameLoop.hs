module GameLoop (roomFunc) where

import Balcony (handleGoBalcony, handleInspectBalcony, handleInteractBalcony, handleLookBalcony, handleTakeBalcony)
import Bathroom
import Bedroom (handleGoBedroom, handleInspectBedroom, handleInteractBedroom, handleLookBedroom, handleTakeBedroom)
import Closet (handleGoCloset, handleInspectCloset, handleInteractCloset, handleLookCloset, handleTakeCloset)
import Data.Typeable
import Hall (handleGoHall, handleInteractHall, handleLookHall, handleTakeHall, handleInspectHall)
import Kitchen
import LivingRoom (handleGoLivingRoom, handleInteractLivingRoom, handleTakeLivingRoom, handleInspectLivingRoom, handleLookLivingRoom)
import Rooms
import State (GameState (actionCount, dishwasherRunning))
import System.Exit (exitSuccess)
import Text.Printf
import Utils (combineRest, printCommands, promptPlayer, showFound, showInventory, showUnfound)

emptyInspect :: String -> GameState -> IO GameState
emptyInspect userInput state = do
  let splitInput = words userInput
  let rest = combineRest splitInput 1
  printf "Whatever %s is, you can't inspect that\n" (show rest)
  return state

roomFunc :: Room -> GameState -> IO ()
roomFunc Kitchen = gameLoop handleLookKitchen handleGoKitchen handleInteractKitchen handleTakeKitchen handleInspectKitchen
roomFunc LivingRoom = gameLoop handleLookLivingRoom handleGoLivingRoom handleInteractLivingRoom handleTakeLivingRoom handleInspectLivingRoom
roomFunc Hall = gameLoop handleLookHall handleGoHall handleInteractHall handleTakeHall handleInspectHall
roomFunc Bedroom = gameLoop handleLookBedroom handleGoBedroom handleInteractBedroom handleTakeBedroom handleInspectBedroom
roomFunc Closet = gameLoop handleLookCloset handleGoCloset handleInteractCloset handleTakeCloset handleInspectCloset
roomFunc Balcony = gameLoop handleLookBalcony handleGoBalcony handleInteractBalcony handleTakeBalcony handleInspectBalcony
roomFunc Bathroom = gameLoop handleLookBathroom handleGoBathroom handleInteractBathroom handleTakeBathroom handleInspectBathroom

-- | Main game loop handling commands via callbacks.
--
-- Arguments:
--   * handleLook: action after the player issues "look" (display state).
--   * handleGo: action after the player issues "go <direction>" or "go <room>".
--   * handleInteract: action after the player issues "interact <target>".
--   * handleTake: action after the player issues "take <item>".
--   * state: current 'GameState'.
--
-- The loop reads player input and dispatches the corresponding helper.
gameLoop ::
  (GameState -> IO GameState) ->
  (String -> GameState -> IO Room) ->
  (String -> GameState -> IO GameState) ->
  (String -> GameState -> IO GameState) ->
  (String -> GameState -> IO GameState) ->
  GameState ->
  IO ()
gameLoop handleLook handleGo handleInteract handleTake handleInspect state = do
  let updatedState = state {actionCount = actionCount state + 1}
  userInput <- promptPlayer
  let splitInput = words userInput
  if null splitInput
    then do
      putStrLn "Please enter a command"
      gameLoop handleLook handleGo handleInteract handleTake handleInspect updatedState
    else case head splitInput of
      "look" -> do
        newState <- handleLook updatedState
        gameLoop handleLook handleGo handleInteract handleTake handleInspect newState
      "go" -> do
        nextRoom <- handleGo userInput updatedState
        roomFunc nextRoom updatedState
      "interact" -> do
        newState <- handleInteract userInput updatedState
        gameLoop handleLook handleGo handleInteract handleTake handleInspect newState
      "info" -> do
        printCommands
        gameLoop handleLook handleGo handleInteract handleTake handleInspect updatedState
      "found" -> do
        showFound updatedState
        gameLoop handleLook handleGo handleInteract handleTake handleInspect updatedState
      "unfound" -> do
        showUnfound updatedState
        gameLoop handleLook handleGo handleInteract handleTake handleInspect updatedState
      "inventory" -> do
        showInventory updatedState
        gameLoop handleLook handleGo handleInteract handleTake handleInspect updatedState
      "take" -> do
        newState <- handleTake userInput updatedState
        gameLoop handleLook handleGo handleInteract handleTake handleInspect newState
      "inspect" -> do
        -- inspect updating the state is really only relevant in one case - the balcony and railing with the string
        newState <- handleInspect userInput state
        gameLoop handleLook handleGo handleInteract handleTake handleInspect newState
      "exit" -> do
        putStrLn "Exiting the game"
        exitSuccess
      _ -> do
        putStrLn ("Unknown command: " ++ userInput)
        gameLoop handleLook handleGo handleInteract handleTake handleInspect updatedState
