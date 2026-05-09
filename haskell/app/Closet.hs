module Closet
  ( handleLookCloset,
    handleGoCloset,
    handleInteractCloset,
    handleTakeCloset,
    handleInspectCloset,
  )
where

import Rooms (Room (Bedroom, Closet))
import State (GameState (..))
import Utils (combineRest, green, magenta, updateCan)

handleLookCloset :: GameState -> IO GameState
handleLookCloset state = do
  putStrLn
    "This is the closet where you keep most of your daily clothes. There are dust speckles in the air and you can smell your laundry detergent faintly."
  if not (openedPaperBox state)
    then do
      putStrLn $ "On the floor there is a small " ++ green "PAPER BOX" ++ " completely covered in packing tape. You'll need something sharp to open it."
    else do
      putStrLn $ "The " ++ green "PAPER BOX" ++ " on the floor has already been opened with a knife, inside are only white packing peanuts."
  putStrLn $ "There is a " ++ green "DRYING RACK" ++ " here, where you keep your shirts and some pants. It looks dusty."
  return state

handleGoCloset :: String -> GameState -> IO Room
handleGoCloset input _ = do
  let splitInput = words input
  let rest = combineRest splitInput 2
  case rest of
    "bedroom" -> do
      putStrLn "You go into the bedroom."
      return Bedroom
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
  if length splitInput < 3
    then do
      putStrLn "Interact with what?"
      return state
    else do
      let rest = combineRest splitInput 2
      case rest of
        "clothing rack" -> do
          if not (cansFound state !! 8)
            then do
              putStrLn $ "You grab your favourite jacket from a hanger and put it on. It's very warm and has big nice pocket. Without thinking you put your hands in the pockets and notice something cold. In your left pocket you find " ++ magenta "Can #9"
              let newState = updateCan 8 True state
              return newState
            else do
              putStrLn $ "All the clothes, including the jacket you grabbed earlier are back on. You try the jacket on again but quickly put it back since it's too warm anyway. " ++ magenta "Can #9" ++ " used to be in the left pocket."
              return state
        "paper box" -> do
          if not (openedPaperBox state)
            then do
              putStrLn "You squat down to reach the box."
              if "knife" `elem` inventory state
                then do
                  putStrLn $ "You use the sharp knife to cut through the packing tape. Inside the box is a lot of white packing peanuts but underneath them you find " ++ magenta "Can #10"
                  let newState = updateCan 9 True state
                  return newState {openedPaperBox = True}
                else do
                  putStrLn "The thick layers of tape are too much for you to tear through. Something sharp would come in handy..."
                  return state
            else do
              putStrLn $ "You've already opened the box using the knife. Inside there used to be " ++ magenta "Can #10" ++ "."
              return state
        _ -> return state

handleInspectCloset :: String -> GameState -> IO GameState
handleInspectCloset input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Inspect what?"
      return state
    else do
      let rest = combineRest splitInput 1
      case rest of
        "clothing rack" -> do
          if not (cansFound state !! 8)
            then do
              putStrLn $ "You look closer at one of your favourite denim jackets. The fabric is pretty thick but despite that you can still see something bulging in its inner pocket."
              pure state
            else do
              putStrLn $ "You inspect the " ++ green "CLOTHING RACK" ++ " again. Your denim jacket now hangs flat on its hanger, with visibly empty pockets."
              pure state
        "paper box" -> do
          if not (cansFound state !! 9)
            then do
              putStrLn $ "It's a " ++ green "PAPER BOX" ++ " completely covered in many many layers of packing tape. It's definitely too sealed for you to just open it with your bare hands. A knife would surely help here."
              pure state
            else do
              putStrLn $ "It's the " ++ green "PAPER BOX" ++ ", now torn open. Inside only a heap of white packing peanuts remains."
              pure state
        _ -> do
          putStrLn "No such object here"
          return state