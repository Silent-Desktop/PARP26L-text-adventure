module GameLoop (roomFunc) where

import Balcony (handleGoBalcony, handleInteractBalcony, handleLookBalcony, handleTakeBalcony)
import Hall (handleGoHall, handleInteractHall, handleLookHall, handleTakeHall)
import Kitchen
import LivingRoom
import Rooms
import State (GameState (actionCount, dishwasherRunning))
import System.Exit (exitSuccess)
import Utils (printCommands, promptPlayer, showFound, showInventory, showUnfound)

roomFunc :: Room -> GameState  -> IO ()
roomFunc (Kitchen) = gameLoop handleLookKitchen handleGoKitchen handleInteractionKitchen handleTakeKitchen
roomFunc (LivingRoom) =  gameLoop handleLookLivingRoom handleGoLivingRoom handleInteractLivingRoom handleTakeLivingRoom
roomFunc (Hall) = gameLoop handleLookHall handleGoHall handleInteractHall handleTakeHall
roomFunc (Balcony) = gameLoop handleLookBalcony handleGoBalcony handleInteractBalcony handleTakeBalcony
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
  GameState ->
  IO ()
gameLoop handleLook handleGo handleInteract handleTake state = do
  let updatedState = state {actionCount = actionCount state + 1,dishwasherRunning=(actionCount state==29)}
  userInput <- promptPlayer
  let splitInput = words userInput
  case head splitInput of
    "look" -> do
      newState <- handleLook updatedState
      gameLoop handleLook handleGo handleInteract handleTake newState
    "go" -> do
      nextRoom <- handleGo userInput updatedState
      roomFunc nextRoom updatedState
    "interact" -> do
      newState <- handleInteract userInput updatedState
      gameLoop handleLook handleGo handleInteract handleTake newState
    "info" -> do
      printCommands
      gameLoop handleLook handleGo handleInteract handleTake updatedState
    "found" -> do
      showFound updatedState
      gameLoop handleLook handleGo handleInteract handleTake updatedState
    "unfound" -> do
      showUnfound updatedState
      gameLoop handleLook handleGo handleInteract handleTake updatedState
    "inventory" -> do
      showInventory updatedState
      gameLoop handleLook handleGo handleInteract handleTake updatedState
    "take" -> do
      newState <- handleTake userInput updatedState
      gameLoop handleLook handleGo handleInteract handleTake newState
    "exit" -> do
      putStrLn "Exiting the game"
      exitSuccess
    _ -> do
      putStrLn ("Unknown command: " ++ userInput)
      gameLoop handleLook handleGo handleInteract handleTake updatedState
