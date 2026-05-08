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
import State (GameState (..))
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
    \interact           -- to interact with something in the scene.\n\
    \inspect            -- to take a closer look at something.\n\
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

-- | Labels and descriptions of all cans.
canLabels :: [String]
canLabels =
  [ "Can #1: There are pictures of butterflies on it. The drink flavour is disgustingly peachy.",
    "Can #2: There are drawings of fish and underwater algae all the way around it. You' re pretty sure the flavour is pineapple.",
    "Can #3: It's a vivid neon green color. It's the best flavour - sour apple.",
    "Can #4: It's pink in color and the drink is probably strawberry flavored.",
    "Can #5: The color of it is a really bright cheerful yellow. There's some drawing on it as well but they're pretty meaningless. The flavour is bad.",
    "Can #6: It's a uniform soft pinkish-orange color. The drink tastes like peach and lemon.",
    "Can #7: It has a gold coating with sparkling silver details. It's reeeaaaly shiny. The drink tastes like cream soda.",
    "Can #8: It's a really bright pastel pink. The drink inside tastes like bubblegum.",
    "Can #9: It's black with some green gradient. There's \"NITRO\" written at the bottom. Why did you buy this flavour?",
    "Can #10: It's black with red details. The drink flavour is cherry.",
    "Can #11: Completely white with some grey shading and silver details. You're not sure what the flavour is supposed to be.",
    "Can #12: It's a deep purple color with some vines drawn around it. The drink flavour is most likely grape."
  ]

-- | Show which cans are found.
showFound :: GameState -> IO ()
showFound state = do
  mapM_
    ( \(x, y) ->
        Control.Monad.when x $
          putStrLn (canLabels !! y)
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
