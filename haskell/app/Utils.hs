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
    green,
    magenta,
    blue,
    yellow,
    handleEmptyTake,
    reset,
  )
where

import Control.Monad qualified
import State (GameState (..))
import System.IO
import Text.Printf

-- | Print available text adventure commands.
printCommands :: IO ()
printCommands = do
  putStrLn "Commands:"
  putStrLn "info                     -- prints this message"
  putStrLn $ "go to [" ++ yellow "place" ++ "]            -- go to that place"
  putStrLn $ "take [" ++ blue "object" ++ "]            -- to pick up an object"
  putStrLn "look around              -- to look around you again"
  putStrLn $ "interact with [" ++ green "setpiece" ++ "] -- to interact with something in the scene."
  putStrLn $ "inspect [" ++ green "setpiece" ++ "]       -- to take a closer look at something."
  putStrLn "inventory                -- to check what items you have"
  putStrLn "found                    -- to check which trophies you've already found"
  putStrLn "unfound                  -- to check which trophies you're still missing"
  putStrLn "exit                     -- to end the game and quit"
  putStrLn $ "The goal of the game is to find as many cans as possible hidden around the house. When you think you're done return to the kitchen and interract with the " ++ green "FRIDGE" ++ " for the final score"

-- | Game state for the adventure.

-- | Combine list of words into a sentence ignoring the n first words.
combineRest :: [String] -> Int -> String
combineRest xs n = unwords (drop n xs)

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
    "Can #12: It's a deep purple color with some vines drawn around it. The drink flavour is most likely grape.",
    "Can #13: Lucky #13, you found the bonus can. Congrats."
  ]

reset :: String
reset = "\ESC[0m"

green :: String -> String
green s = "\ESC[32m" ++ s ++ reset

magenta :: String -> String
magenta s = "\ESC[35m" ++ s ++ reset

blue :: String -> String
blue s = "\ESC[34m" ++ s ++ "\ESC[0m"

yellow :: String -> String
yellow s = "\ESC[33m" ++ s ++ "\ESC[0m"

-- | Show which cans are found.
showFound :: GameState -> IO ()
showFound state = do
  mapM_
    ( \(x, y) ->
        Control.Monad.when x $
          putStrLn (canLabels !! y)
    )
    (zip (cansFound state) [0 .. length (cansFound state) - 1])

-- | Show which cans are not found yet.
showUnfound :: GameState -> IO ()
showUnfound state = do
  mapM_
    ( \(x, y) ->
        Control.Monad.unless x $
          printf "Not found can #%d\n" (y + 1)
    )
    (zip (cansFound state) [0 .. length (cansFound state) - 1])

-- | Show contents of inventory.
showInventory :: GameState -> IO ()
showInventory state = do
  mapM_ (printf "- %s\n") (inventory state)

handleEmptyTake :: String -> GameState -> IO GameState
handleEmptyTake _input state = do
  putStrLn "No such item"
  return state