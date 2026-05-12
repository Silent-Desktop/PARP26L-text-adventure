module LivingRoom
  ( handleLookLivingRoom,
    handleGoLivingRoom,
    handleInteractLivingRoom,
    handleTakeLivingRoom,
    handleInspectLivingRoom,
  )
where

import Rooms
import State (GameState (..))
import Utils (blue, combineRest, green, magenta, updateCan, yellow)

handleTakeLivingRoom :: String -> GameState -> IO GameState
handleTakeLivingRoom input state = do
  let splitInput = words input
  let rest = combineRest splitInput 1
  case rest of
    "chair" ->
      if not (pickedUpChair state)
        then do
          putStrLn $ "You somehow manage to pick up the " ++ blue "chair" ++ ". It's a bit weird to hold but you've done this before."
          let newInventory = inventory state ++ ["chair"]
          let newState = state {inventory = newInventory, pickedUpChair = True}
          return newState
        else do
          putStrLn "You're already holding it!"
          return state
    "house keys" -> do
      if not (pickedUpKeys state)
        then do
          putStrLn $ "You pick up the " ++ blue "house keys" ++ " and they fit neatly in your back pocket."
          let newInventory = inventory state ++ ["house keys"]
          let newState = state {pickedUpKeys = True, inventory = newInventory}
          return newState
        else do
          putStrLn "You already picked up the keys earlier"
          return state
    _ -> do
      putStrLn "No such item"
      return state

handleLookLivingRoom :: GameState -> IO GameState
handleLookLivingRoom state = do
  putStrLn $
    "This is the living room, where you spend your free time and occasionaly nap.\n\
    \There is a "
      ++ green "couch"
      ++ " here, it looks very comfortable with all its cushions and the fluffy blanket on top\n"
  if "chair" `notElem` inventory state
    then do
      putStrLn $ "There is a " ++ blue "chair" ++ " here, just next to the " ++ green "table" ++ ". Usually you'd just sit on it but sometimes you use it to reach higher places."
    else putStrLn ""
  if houseKeysFound state && not (pickedUpKeys state)
    then do
      putStrLn $ "The " ++ blue "house keys" ++ " are here, on the table. Usually you leave them here anyway, easier to find later."
    else putStrLn ""
  stateWithCan <-
    if not (cansFound state !! 4)
      then do
        putStrLn $
          "When you look at the " ++ green "table" ++ " you see some used plates, a folded tablecloth and next to them, slightly obscured by an empty cup is " ++ magenta "Can #5" ++ "!"
        pure $ updateCan 4 True state
      else pure state
  handleLookRestLivingRoom stateWithCan

handleLookRestLivingRoom :: GameState -> IO GameState
handleLookRestLivingRoom state = do
  putStrLn $ "You can see that from here you can reach " ++ yellow "kitchen"
  putStrLn $
    "You can see that from here you can reach "
      ++ yellow "balcony"
  putStrLn $
    "You can see that from here you can reach "
      ++ yellow "hall"
  return state

handleGoLivingRoom :: String -> GameState -> IO Room
handleGoLivingRoom input _ = do
  let splitInput = words input
  let rest = combineRest splitInput 2
  case rest of
    "kitchen" -> do
      putStrLn $ "You go into the " ++ yellow "kitchen."
      return Kitchen
    "balcony" -> do
      putStrLn $ "You enter the " ++ yellow "balcony."
      return Balcony
    "hall" -> do
      putStrLn $ "You go into the " ++ yellow "hall."
      return Hall
    _ -> do
      putStrLn "No such room"
      return LivingRoom

handleInteractLivingRoom :: String -> GameState -> IO GameState
handleInteractLivingRoom input state = do
  let splitInput = words input
  if length splitInput < 3
    then do
      putStrLn "Interact with what?"
      return state
    else do
      case splitInput !! 2 of
        "couch" -> do
          if not (cansFound state !! 3)
            then do
              putStrLn $ "You decide to take a break and sit down on the " ++ green "couch" ++ ". The cushions are soft but there is something hard poking you in the hip. You reach under the blanket and find " ++ magenta "Can #4" ++ "!"
              pure $ updateCan 3 True state
            else do
              putStrLn $ "Against better judgment you decide to sit on the " ++ green "couch" ++ " again and waste more time. It's way comfier than previously. " ++ magenta "Can #4" ++ " used to be hidden beneath the blanket here."
              pure state
        "table" -> do
          putStrLn $ "You're not planning to work right now and it's ways before dinner time so the " ++ green "table" ++ " isn't really useful to you right now."
          return state
        _ -> do
          putStrLn "No such object here"
          return state

handleInspectLivingRoom :: String -> GameState -> IO GameState
handleInspectLivingRoom input state = do
  let splitInput = words input
  if length splitInput < 2
    then do
      putStrLn "Inspect what?"
      return state
    else do
      let rest = combineRest splitInput 1
      case rest of
        "couch" -> do
          if not (cansFound state !! 3)
            then do
              putStrLn $ "This is your " ++ green "couch" ++ ". It's were you hang out during the day and read books. You hate napping on it. Right now the cushions and blanket are bunched up in a weird way, like something is underneath."
              pure state
            else do
              putStrLn $ "This is your " ++ green "couch" ++ ". It's were you hang out during the day and read books. You hate napping on it. The cushions are back to laying flat after you pulled out " ++ magenta "Can #4" ++ " from underneath them."
              pure state
        "table" -> do
          if not (houseKeysFound state)
            then do
              putStrLn $ "This is were you usually eat your meals or work if you need more space. The " ++ green "table" ++ " is made of a dark reddish wood and it's big enough for at least 8 people to sit around it. After taking a closer look at the things laid out on the table you notice the " ++ blue "house keys" ++ " under the folded tablecloth."
              let newState = state {houseKeysFound = True}
              return newState
            else do
              putStrLn $ "This is were you usually eat your meals or work if you need more space. The " ++ green "table" ++ " is made of a dark reddish wood and it's big enough for at least 8 people to sit around it."
              pure state
        _ -> do
          putStrLn "No such object here"
          return state