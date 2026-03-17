{-# LANGUAGE ImportQualifiedPost #-}

module Utils
  ( printCommands,
    replaceAt,
    promptPlayer,
    updateCan,
    combineRest,
    showFound,
    showUnfound,
    showInventory,
  )
where

import Control.Monad qualified
import Rooms
import State (GameState (..))
import System.Exit (exitSuccess)
import System.IO
import Text.Printf

-- | Print available text adventure commands.
printCommands :: IO ()
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

-- | Game state for the adventure.

-- | Combine list of words into a sentence ignoring the first word.
combineRest :: [String] -> String
combineRest xs = unwords (drop 1 xs)

-- | Replace element at index in list.
replaceAt :: Int -> a -> [a] -> [a]
replaceAt i v xs =
  take i xs ++ [v] ++ drop (i + 1) xs

-- | Update can found flag in game state.
--
-- Arguments:
--   * i: index of the can in the list to update (0-based).
--   * val: new found state for that can (True for found, False for not found).
--   * gs: current 'GameState'.
--
-- Returns a new 'GameState' with modified can found list.
updateCan :: Int -> Bool -> GameState -> GameState
updateCan i val gs =
  gs {cansFound = replaceAt i val (cansFound gs)}

-- | Prompt the player and read input.
promptPlayer :: IO String
promptPlayer = do
  putStr "> "
  hFlush stdout
  getLine

-- | Show which cans are found.
showFound :: GameState -> IO ()
showFound state = do
  mapM_
    ( \(x, y) ->
        Control.Monad.when x $
          printf "Found can #%d\n" y
    )
    (zip (cansFound state) [1 .. length (cansFound state)])

-- | Show which cans are not found yet.
showUnfound :: GameState -> IO ()
showUnfound state = do
  mapM_
    ( \(x, y) ->
        Control.Monad.unless x $
          printf "Not found can #%d\n" y
    )
    (zip (cansFound state) [1 .. length (cansFound state)])

-- | Show contents of inventory.
showInventory :: GameState -> IO ()
showInventory state = do
  mapM_ (printf "You have a %s\n") (inventory state)
