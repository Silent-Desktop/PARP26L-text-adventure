module GameLoop (roomFunc) where

import Balcony (handleGoBalcony, handleInteractBalcony, handleLookBalcony, handleTakeBalcony, handleInspectBalcony)
import Bedroom (handleGoBedroom, handleInteractBedroom, handleLookBedroom, handleTakeBedroom)
import Closet (handleGoCloset, handleInteractCloset, handleLookCloset, handleTakeCloset)
import Hall (handleGoHall, handleInteractHall, handleLookHall, handleTakeHall)
import Kitchen
import LivingRoom
import Rooms
import State (GameState (actionCount, dishwasherRunning))
import System.Exit (exitSuccess)
import Utils (printCommands, promptPlayer, showFound, showInventory, showUnfound)

emptyInspect ::  GameState -> IO GameState
emptyInspect state = do
  putStrLn "You can't inspect that"
  return state

roomFunc :: Room -> GameState  -> IO ()
roomFunc (Kitchen) = gameLoop handleLookKitchen handleGoKitchen handleInteractionKitchen handleTakeKitchen emptyInspect
roomFunc (LivingRoom) =  gameLoop handleLookLivingRoom handleGoLivingRoom handleInteractLivingRoom handleTakeLivingRoom emptyInspect
roomFunc (Hall) = gameLoop handleLookHall handleGoHall handleInteractHall handleTakeHall emptyInspect
roomFunc (Bedroom) = gameLoop handleLookBedroom handleGoBedroom handleInteractBedroom handleTakeBedroom emptyInspect
roomFunc (Closet) = gameLoop handleLookCloset handleGoCloset handleInteractCloset handleTakeCloset emptyInspect
roomFunc (Balcony) = gameLoop handleLookBalcony handleGoBalcony handleInteractBalcony handleTakeBalcony handleInspectBalcony
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
    (GameState->IO GameState)->
  GameState ->
  IO ()
gameLoop handleLook handleGo handleInteract handleTake handleInspect state = do
  let updatedState = state {actionCount = actionCount state + 1, dishwasherRunning = (actionCount state < 29 || dishwasherRunning state)}
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
        _ <- handleInspect state
        gameLoop handleLook handleGo handleInteract handleTake handleInspect state
      "exit" -> do
        putStrLn "Exiting the game"
        exitSuccess
      _ -> do
        putStrLn ("Unknown command: " ++ userInput)
        gameLoop handleLook handleGo handleInteract handleTake handleInspect updatedState
