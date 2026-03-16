module Main where

import System.Exit
import System.IO

data GameState = GameState{
    dishwasher_running :: Bool,
    cans_found :: [Bool]
}

replaceAt :: Int -> a -> [a] -> [a]
replaceAt i v xs =
  take i xs ++ [v] ++ drop (i+1) xs
updateCan :: Int -> Bool -> GameState -> GameState
updateCan i val gs =
  gs { cans_found = replaceAt i val (cans_found gs) }
main = do
    let state = GameState{dishwasher_running = True, cans_found = replicate 8 False}
    putStrLn "You are in your kitchen, staring into your fridge. Lately you've bought exactly 12 cans of your favourite energy drink to last you through the exam season. You had some friends over last night and they must have decided on a prank to hide all of them from you, because the fridge is nearly empty without a single perfectly chilled can. They're not in the fridge but they wouldn't steal so they must be around the house. Better get to searching!"
    putStrLn "Commands:\n\
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
    kitchen state


prompt_player :: IO String
prompt_player = do
    putStr "> "
    hFlush stdout
    user_input <- getLine
    return user_input

game_loop handle_input return_place state = do
    -- get user input
    user_input <- prompt_player
    -- decide what to do based on the input
    handle_input user_input state
    return_place state
kitchen state = do
    game_loop handle_input_kitchen kitchen state

handle_interaction_kitchen object state = do
    case object of
        "dishwasher" -> do
            if dishwasher_running state == True
                then putStrLn "The dishwasher is rumbling and the little display is on - there's a wash cycle still going. You'l have to wait some time before opening it."
            else if not (cans_found state !! 0) then do
                putStrLn "The little display is off and the dishwasher isn't making any noises - the wash cycle must be done. You grab the handle and open the door. Inside it's still warm and humid. Between plates and pots you find Can #1!."
                let newState = updateCan 0 True state
                kitchen newState
            else 
                putStrLn "The dishwasher has already been opened. The plates inside are drying. Can #1 used to be here."
        _ -> kitchen state
                

handle_input_kitchen :: String -> GameState -> IO ()
handle_input_kitchen input state = do
    let split_input = words input
    case split_input !! 0 of
        "look" -> putStrLn "This is the kitchen. The countertops are clean and there are no dirty dishes in the sink. Clearly you've been busy or just haven't eaten in a long time.\n\
        \There is a DISHWASHER here, a true lifesaver since you hate washing the dishes by hand.\n\
        \There is a large CUPBOARD right at your eye-level and its slightly ajar.\n\
        \Next to your feet, there is a big square TRASHCAN, with its lid closed."
        "go north" -> putStrLn "You go north to the living room."
        "interact" -> handle_interaction_kitchen (split_input !! 1) state
        "exit" -> do
            putStrLn "Exiting the game"
            exitSuccess
        _ -> putStrLn ("Unknown command: " ++ input)


