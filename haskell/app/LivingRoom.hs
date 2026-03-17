module LivingRoom
  ( livingRoom,
  )
where

import Control.Monad qualified
import System.Exit (exitSuccess)
import Utils (GameState (..), combineRest, gameLoop, printCommands, showFound, showInventory, showUnfound, updateCan)

livingRoom :: GameState -> IO ()
livingRoom = gameLoop handleLookLivingRoom handleGoLivingRoom handleInteractLivingRoom handleTakeLivingRoom livingRoom

handleTakeLivingRoom :: String -> GameState -> IO ()
handleTakeLivingRoom input state = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "_" -> putStrLn "No such item"

handleLookLivingRoom :: GameState -> IO ()
handleLookLivingRoom state = do
  putStrLn
    "This is the living room, where you spend your free time and occasionaly nap.\n\
    \There is a COUCH here, it looks very comfortable with all its cushions and the fluffy blanket on top\n"
  if "chair" `notElem` inventory state
    then do
      putStrLn "There is a CHAIR here, just next to the table. Usually you'd just sit on it but sometimes you use it to reach higher places."
    else putStrLn ""
  if not (cansFound state !! 4)
    then do
      putStrLn
        "When you look at the table you see some used plates, a folded tablecloth and next to them, slightly obscured by an empty cup is Can #5!"
      let newState = updateCan 4 True state
      handleLookRestLivingRoom newState
    else
      handleLookRestLivingRoom state

handleLookRestLivingRoom :: GameState -> IO ()
handleLookRestLivingRoom state = do
  putStrLn
    "You can see that from here you can reach kitchen\n\
    \You can see that from here you can reach balcony\n\
    \You can see that from here you can reach hall"
  livingRoom state

handleGoLivingRoom :: String -> GameState -> IO ()
handleGoLivingRoom input state = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "_" -> putStrLn "No such room"

handleInteractLivingRoom :: String -> GameState -> IO ()
handleInteractLivingRoom input state = do
  let splitInput = words input
  case splitInput !! 1 of
    "couch" -> do
      putStrLn "You decide to take a break and sit down on the COUCH. The cushions are soft but there is something hard poking you in the hip. You reach under the blanket and find Can #4!"
      livingRoom (updateCan 3 True state)
    "_" -> putStrLn "No such object here"