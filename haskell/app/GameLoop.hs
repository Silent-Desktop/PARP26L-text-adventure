module GameLoop (kitchen, livingRoom) where

import Kitchen
import LivingRoom
import Rooms
import State (GameState)
import System.Exit (exitSuccess)
import Utils (printCommands, promptPlayer, showFound, showInventory, showUnfound)

kitchen :: GameState -> IO ()
kitchen = gameLoop handleLookKitchen handleGoKitchen handleInteractionKitchen handleTakeKitchen

livingRoom :: GameState -> IO ()
livingRoom = gameLoop handleLookLivingRoom handleGoLivingRoom handleInteractLivingRoom handleTakeLivingRoom

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
  userInput <- promptPlayer
  let splitInput = words userInput
  case head splitInput of
    "look" -> do
      newState <- handleLook state
      gameLoop handleLook handleGo handleInteract handleTake newState
    "go" -> do
      nextRoom <- handleGo userInput state
      case nextRoom of
        Kitchen -> kitchen state
        LivingRoom -> livingRoom state
    "interact" -> do
      newState <- handleInteract userInput state
      gameLoop handleLook handleGo handleInteract handleTake newState
    "info" -> do
      printCommands
      gameLoop handleLook handleGo handleInteract handleTake state
    "found" -> do
      showFound state
      gameLoop handleLook handleGo handleInteract handleTake state
    "unfound" -> do
      showUnfound state
      gameLoop handleLook handleGo handleInteract handleTake state
    "inventory" -> do
      showInventory state
      gameLoop handleLook handleGo handleInteract handleTake state
    "take" -> do
      newState <- handleTake userInput state
      gameLoop handleLook handleGo handleInteract handleTake newState
    "exit" -> do
      putStrLn "Exiting the game"
      exitSuccess
    _ -> do
      putStrLn ("Unknown command: " ++ userInput)
      gameLoop handleLook handleGo handleInteract handleTake state
