module Utils (GameState (..), printCommands, replaceAt, promptPlayer, updateCan, gameLoop, combineRest, showFound, showUnfound, showInventory) where

import Control.Monad qualified
import System.IO
import Text.Printf

printCommands =
  putStrLn
    "Commands:\n\
    \info               -- prints this message\n\
    \go [place]         -- go to that place\n\
    \take [object]      -- to pick up an object\n\
    \drop [object]      -- to put down an object\n\
    \look               -- to look around you again\n\
    \interact           -- to interact with something in the scene. (NOT FINISHED\n\
    \inspect            -- to take a closer look at something. (NOT IMPLEMENTED\n\
    \inventory          -- to check what items you have\n\
    \found              -- to check which trophies you've already found\n\
    \unfound            -- to check which trophies you're still missing\n\
    \exit               -- to end the game and quit\n\
    \The goal of the game is to find as many cans as possible hidden around the house. When you think you're done return to the kitchen and interract with the FRIDGE for the final score\n"

data GameState = GameState
  { dishwasherRunning :: Bool,
    cansFound :: [Bool],
    inventory :: [String],
    pickedUpKnifeInKitchen :: Bool
  }

combineRest xs = do
  unwords (drop 1 xs)

replaceAt :: Int -> a -> [a] -> [a]
replaceAt i v xs =
  take i xs ++ [v] ++ drop (i + 1) xs

updateCan :: Int -> Bool -> GameState -> GameState
updateCan i val gs =
  gs {cansFound = replaceAt i val (cansFound gs)}

promptPlayer :: IO String
promptPlayer = do
  putStr "> "
  hFlush stdout
  getLine

showFound :: GameState -> IO ()
showFound state = do
  mapM_ (\(x, y) -> Control.Monad.when x $ printf "Found can #%d\n" y) (zip (cansFound state) [1 .. (length (cansFound state))])

showUnfound :: GameState -> IO ()
showUnfound state = do
  mapM_ (\(x, y) -> Control.Monad.unless x $ printf "Not found can #%d\n" y) (zip (cansFound state) [1 .. (length (cansFound state))])

showInventory :: GameState -> IO ()
showInventory state = do
  mapM_ (printf "You have a %s\n") (inventory state)

gameLoop handleInput returnPlace state = do
  -- get user input
  userInput <- promptPlayer
  -- decide what to do based on the input
  handleInput userInput state
  returnPlace state