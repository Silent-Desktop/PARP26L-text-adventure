module Closet
  ( handleLookCloset,
    handleGoCloset,
    handleInteractCloset,
    handleTakeCloset,
  )
where

import Rooms (Room (Closet, Bedroom))
import State (GameState (..))
import Utils (combineRest, updateCan)

handleLookCloset :: GameState -> IO GameState
handleLookCloset state = do
  putStrLn
    "This is the closet where you keep most of your daily clothes. There are dust speckles in the air and you can smell your laundry detergent faintly."
  if openedPaperBox state 
    then do
      putStrLn "On the floor there is a small paper box completely covered in packing tape. You'll need something sharp to open it."
    else do
      putStrLn "The paper box on the floor has already been opened with a knife, inside are only white packing peanuts."
  return state

handleGoCloset :: String -> GameState -> IO Room
handleGoCloset input _ = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "bedroom" -> return Bedroom
    _ -> do
      putStrLn "No such room"
      return Closet
        
handleTakeCloset :: String -> GameState -> IO GameState
handleTakeCloset input state = do
  let splitInput = words input
  let object = splitInput !! 1
  case object of
    _ -> do
      putStrLn "No such object here"
      return state

handleInteractCloset :: String -> GameState -> IO GameState
handleInteractCloset input state = do
  let splitInput = words input
  let rest = combineRest splitInput
  case rest of
    "drying rack" -> do
      if not (cansFound state !! 8)
        then do
          putStrLn "You grab your favourite jacket from a hanger and put it on. It's very warm and has big nice pocket. Without thinking you put your hands in the pockets and notice something cold. In your left pocket you find Can #9"
          let newState = updateCan 8 True state
          return newState
        else do
          putStrLn "All the clothes, including the jacket you grabbed earlier are back on. You try the jacket on again but quickly put it back since it's too warm anyway. Can #9 used to be in the left pocket."
          return state
    "paper box" -> do
        if not (openedPaperBox state) 
          then do
            putStrLn "You squat down to reach the box."
            if "knife" `elem` inventory state 
              then do
                putStrLn "You use the sharp knife to cut through the packing tape. Inside the box is a lot of white packing peanuts but underneath them you find Can #10"
                let newState = updateCan 9 True state
                return newState{openedPaperBox=True}
              else do
                putStrLn "The thick layers of tape are too much for you to tear through. Something sharp would come in handy..."
                return state
        else do
            putStrLn "You've already opened the box using the knife. Inside there used to be Can # 10."
            return state

    _ -> return state
