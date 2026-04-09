/* These rules describe interactions with setpieces */
:- module(adv_interacts, [interact/1]).


interact(_) :-
      increment_action_counter, fail.

interact(dishwasher)    :- 
  i_am_at(Here), 
  (in(dishwasher, Here) ->
    (unused(dishwasher) ->
      (running(dishwasher) ->
        write('The '), ansi_format([bold, fg(green)], 'dishwasher', []), write(' is rumbling and the little display is on - there''s a wash cycle still going. You''l have to wait some time before opening it. Best to just take nap.'), nl
        ;
        write('The little display is off and the '), ansi_format([bold, fg(green)], 'dishwasher', []), write(' isn''t making any noises - the wash cycle must be done. You grab the handle and open the door. Inside it''s still warm and humid. Between plates and pots you find '), ansi_format([bold, fg(magenta)], 'Can #1', []), nl,
        retract(unfound(can1)),  increment_can_counter, assert(found(can1)),
        retract(unused(dishwasher))
      )
      ;
      write('The '), ansi_format([bold, fg(green)], 'dishwasher', []), write(' has already been opened. The plates inside are drying. Can #1 used to be here.'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).


interact(couch)    :-
  i_am_at(Here), 
  (in(couch, Here) ->
    (unused(couch) ->
      write('You decide to take a break and sit down on the '), ansi_format([bold, fg(green)], 'couch', []), write('. The cushions are soft but there is something hard poking you in the hip. You reach under the blanket and find '), ansi_format([bold, fg(magenta)], 'Can #4', []), nl,
      retract(unfound(can4)),  increment_can_counter, assert(found(can4)),
      retract(unused(couch))
      ;
      write('Against better judgment you decide to sit on the '), ansi_format([bold, fg(green)], 'couch', []), write(' again and waste more time. It''s way comfier than previously. Can #4 used to be hidden beneath the blanket here.'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(paper_box)  :-
  i_am_at(Here), 
  (in(paper_box, Here) ->
    write('You squat down to reach the box.'), nl,
    (unused(paper_box) ->
      (holding(knife) ->
        write('You use the sharp knife to cut through the packing tape. Inside the box is a lot of white packing peanuts but underneath them you find '), ansi_format([bold, fg(magenta)], 'Can #10', []), nl,
        retract(unfound(can10)),  increment_can_counter, assert(found(can10)),
        retract(unused(paper_box)), fail
        ;
        write('The thick layers of tape are too much for you to tear through. Something sharp would come in handy...'), nl
      ), 
      retract(unused(paper_box))
      ;
      write('You''ve already opened the box using the knife. Inside there used to be Can # 10.')
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(clothing_rack) :-
  i_am_at(Here), 
  (in(clothing_rack, Here) ->
    (unused(clothing_rack) ->
      write('You grab your favourite jacket from a hanger and put it on. It''s very warm and has big nice pocket. Without thinking you put your hands in the pockets and notice something cold. In your left pocket you find '), ansi_format([bold, fg(magenta)], 'Can #9', []), nl,
      retract(unfound(can9)),  increment_can_counter, assert(found(can9)), retract(unused(clothing_rack))
      ;
      write('All the clothes, including the jacket you grabbed earlier are back on'), ansi_format([bold, fg(green)], 'clothing_rack', []), write('. You try the jacket on again but quickly put it back since it''s too warm anyway. Can #9 used to be in the left pocket.')
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

interact(cupboard)  :-
  i_am_at(Here),
  (in(cupboard, Here) ->
    write('You open the door of the '), ansi_format([bold, fg(green)], 'cupboard', []), write(' wider.'), nl,
    (unused(cupboard) ->
    /*During playtesting a more intuitive option seemed to be dropping the chair before trying to get on top of it. Here 2 options are made acceptable.*/
      (holding(chair) ; at(chair, kitchen) ->
        write('You climb the '), ansi_format([bold, fg(blue)], 'chair', []), write(' to reach the top shelf and grab '), ansi_format([bold, fg(magenta)], 'Can #2', []), nl,
        retract(unfound(can2)),  increment_can_counter, assert(found(can2)),
        retract(unused(cupboard))
        ;
        write('You can see something on the top shelf but It''s much too high for you to reach.'), nl
      )
      ;
      write('You look into the '), ansi_format([bold, fg(green)], 'cupboard', []), write(' again but besides some clean cups and plates there''s nothing of interest anymore. Can #2 used to be on the top shelf.')
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(railing) :-
  i_am_at(Here), 
  (in(railing, Here) ->
    (unused(railing) ->
      write('You approach the '), ansi_format([bold, fg(green)], 'railing', []), write(' and rearange the wet towels hanging from it. They are colorful and it would be quite easy to hide something between them, like a thin string.'), nl
      ;
      write('It''s the '), ansi_format([bold, fg(green)], 'railing', []), write('. You rearange the towels again, maybe out of boredom.'), nl,
      (unused(string) ->
        write('There''s still a thin '), ansi_format([bold, fg(green)], 'string', []), write(' hanging over the edge'), nl
        ;
        write('')
      )
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(string) :-
  i_am_at(Here), 
  (in(string, Here) ->
    write('You grab the '), ansi_format([bold, fg(green)], 'string', []), write(' at the edge of the '), ansi_format([bold, fg(green)], 'railing', []), write(' and start gently pulling. There is something heavy tied to it. Finally you grab a hold of '), ansi_format([bold, fg(magenta)], 'Can #6', []), nl,
    retract(unfound(can6)),  increment_can_counter, assert(found(can6)), retract(in(string, balcony)), retract(unused(string))
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(fridge)    :- 
  i_am_at(Here), 
  (in(fridge, Here) ->
    write('You open the '), ansi_format([bold, fg(green)], 'fridge', []), write(' and return all the cans that you''ve found to their shelf. You''re looking forward to ejoying a cold drink.'), nl,
    how_many_actions,
    write('In total you have found '),
    can_counter(Value),
    write(Value), write('/12 cans.'), nl,
    write('You have finished your search, type "halt." to end the game. Thank you for playing!'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(trashcan)    :- 
  i_am_at(Here), 
  (in(trashcan, Here) ->
    (unused(trashcan) ->
      write('You grab the plastic lid and open the '), ansi_format([bold, fg(green)], 'trashcan', []), write('. Inside nestled between old takeout boxes and paper scraps is '), ansi_format([bold, fg(magenta)], 'Can #3', []), nl,
      retract(unfound(can3)),  increment_can_counter, assert(found(can3)),
      retract(unused(trashcan))
      ;
      write('You open the trashcan again. Luckily there is no upleasant smell. Can #3 used to lie on the paper scraps here.'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(plant)    :-
  i_am_at(Here), 
  (in(plant, Here) ->
    (unused(plant) ->
      write('You squat down to touch the '), ansi_format([bold, fg(green)], 'plant', []), write('. After some searching under its many leaves you find '), ansi_format([bold, fg(magenta)], 'Can #7', []), nl,
      retract(unfound(can7)),  increment_can_counter, assert(found(can7)),
      retract(unused(plant))
      ;
      write('You ruffle the leaves again but besides a couple of dried petals and small bugs nothing of interest falls out. Can #3 used to be hidden below the leaves.')
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(house_door)  :-
  i_am_at(Here), 
  (in(house_door, Here) ->
    (unused(house_door) ->
      write('You stand in front of the '), ansi_format([bold, fg(green)], 'house_door', []), write(' of your aparment'), nl,
      (holding(house_keys) ->
        write('You pull out the '), ansi_format([bold, fg(blue)], 'house_keys', []), write(' and use them to easily open both locks. The door is now open. On your doorstep you find '), ansi_format([bold, fg(magenta)], 'Can #12', []), write('. You lock the door again.'), nl,
        retract(unfound(can12)),  increment_can_counter, assert(found(can12)),
        retract(unused(house_door))
        ;
        write('The '), ansi_format([bold, fg(green)], 'house_door', []), write(' is locked and with your current equipment there isn''t much you can do about it.'), nl
      )
      ;
      write('You''ve already opened the door. Can #12 used to be outside standing on your doormat. You made sure to lock the door again right?'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(bed)  :-
  i_am_at(Here), 
  (in(bed, Here) ->
    (unused(bed) ->
      write('The '), ansi_format([bold, fg(green)], 'bed', []), write(' looks really inviting. You lie down and the moment your cheek touches the pillow you drift off for a nap.'), nl, nl,
      write('You wake up sometime later, unsure what time it is really is. The house is quiet, even the rumble of the '), ansi_format([bold, fg(green)], 'dishwasher', []), write(' in the '), ansi_format([bold, fg(yellow)], 'kitchen', []), write(' has stopped.'), nl,
      retract(unused(bed)), 
      retract(running(dishwasher))
      ;
      write('Without clear reason you lie down for a nap again. But you already had one today so it''s much harder to fall asleep. After a while of tossing and turning you get back up.'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(shower) :-
  i_am_at(Here), 
  (in(shower, Here) ->
    write('You grab the shower nozle and turn on the water. It splashes a bit and wets your socks.'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(sink) :-
  i_am_at(Here), 
  (in(sink, Here) ->
    write('You turn on the water to rinse your hands. It''s pleasantly cold and leaves droplets on the white porcelain'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(toilet) :-
  i_am_at(Here), 
  (in(toilet, Here) ->
    write('You pull up the seat to check for any uncleaned spots. Luckily you''ve been diligent so the white porcelain is spotless. You flush the '), ansi_format([bold, fg(green)], 'toilet', []), write(' and it does indeed make a funny gurgling sound.'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(table) :-
  i_am_at(Here), 
  (in(table, Here) ->
    write('You''re not planning to work right now and it''s ways before dinner time so the '), ansi_format([bold, fg(green)], 'table', []), write(' isn''t really useful to you right now.'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(desk) :-
  i_am_at(Here), 
  (in(desk, Here) ->
    (unused(desk) ->
      write('You sit down at your '), ansi_format([bold, fg(green)], 'desk', []), write(' determined to read through some of your notes. After sifting through piles of paper you reach for a book. Before you can even open it you notice '), ansi_format([bold, fg(magenta)], 'Can #8', []), write(' was hiding behind it!'), nl,
      retract(unused(desk)), retract(unfound(can8)),  increment_can_counter, assert(found(can8))
      ;
      write('You''ve already looked through your notes and books, creating an even bigger mess. Can #8 used to be hidden behind some books.'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).