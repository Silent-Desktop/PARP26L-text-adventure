/* These rules are for inspecting setpieces */
:- module(adv_inspects, [inspect/1]).


inspect(_) :-
      increment_action_counter, fail.

inspect(shower) :-
  i_am_at(Here), 
  (in(shower, Here) ->
    (unused(shower) ->
      write('You walk into the '), ansi_format([bold, fg(green)], 'shower', []), write(', careful not to wet your socks on the moist floor. There''s a sponge here and some shampoo and conditioner bottles on a built-in shelf. After taking a closer look one of the bottles turns out to be '), ansi_format([bold, fg(magenta)], 'Can #7', []), nl,
      retract(unfound(can7)),  increment_can_counter, assert(found(can7)),
      retract(unused(shower))
      ;
      write('You''ve already looked the '), ansi_format([bold, fg(green)], 'shower', []), write(' up and down and there isn''t anything else of note here. Can #7 used to be hidden bewteen your shampoo bottles.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ), !.

inspect(dishwasher) :-
  i_am_at(Here), 
  (in(dishwasher, Here) ->
    (unused(dishwasher) ->
      write('The little display is flashing some numbers and you can hear rumbling and water sloshing inside. It might be a good idea to just take nap instead of waiting here for it to finish.'), nl
      ;
      write('The '), ansi_format([bold, fg(green)], 'dishwasher', []), write(' is now open, and you can see some steam coming from inside, There''s warm plates inside and they need some time to fully dry. Can #1 used to be here'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(railing) :-
  i_am_at(Here), 
  (in(railing, Here) ->
    (unused(railing) ->
      write('After looking closer at the '), ansi_format([bold, fg(green)], 'railing', []), write(' and the towels hanging from it you notice a thin '), ansi_format([bold, fg(green)], 'string', []), write(' tied to the edge. It''s pulled taut as if something heavy was at the end of it.'), nl,
      assert(in(string, balcony)), retract(unused(railing))
      ;
      write('It''s the '), ansi_format([bold, fg(green)], 'railing', []), write(', with some colorful wet towers hanging from it. '), nl,
      (unused(string) ->
        write('There''s still a thin '), ansi_format([bold, fg(green)], 'string', []), write(' hanging over the edge'), nl
        ;
        write('')
      )
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(cupboard) :-
  i_am_at(Here), 
  (in(cupboard, Here) ->
    (unused(cupboard) ->
      write('The '), ansi_format([bold, fg(green)], 'cupboard', []), write(' is where you keep your plates and cups. However on the top shelf you can see something shiny. You will definetely need a chair to reach it.'), nl
      ;
      write('Your plates and cups are still here. Luckily you didn''t break anything when trying to reach the top shelf.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(fridge) :-
  i_am_at(Here), 
  (in(fridge, Here) ->
    write('This is your '), ansi_format([bold, fg(green)], 'fridge', []), write('. Inside there should be 12 cans of your favourite energy drink but your friends hid them around the house to prank you. When you''re done searching you should return here and put them back.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(plant) :-
  i_am_at(Here), 
  (in(plant, Here) ->
    (unused(plant) ->
      write('It''s the big '), ansi_format([bold, fg(green)], 'plant', []), write(' on your balcony, perhaps a fern. It''s leaves are wide and sprawling. It would be very easy to hide something here.'), nl
      ;
      write('The leaves look a bit ruffled now, after you pushed them aside. The '), ansi_format([bold, fg(green)], 'plant', []), write(' doesn''t seem bothered'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(house_door) :-
  i_am_at(Here), 
  (in(house_door, Here) ->
    (unused(house_door) ->
      write('The '), ansi_format([bold, fg(green)], 'house_door', []), write(' is a solid ash grey color and the locks are pretty standard. You always make sure to lock it so you''ll need keys if you want to look out into the corridor.'), nl
      ;
      write('The '), ansi_format([bold, fg(green)], 'house_door', []), write(' is locked once again and there is no need for you to go outside right now.')
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(trashcan) :-
  i_am_at(Here), 
  (in(trashcan, Here) ->
    write('It''s a standard grey '), ansi_format([bold, fg(green)], 'trashcan', []), write('. The container itself isn''t heavy and you mostly throw out paper scraps here.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(table) :-
  i_am_at(Here), 
  (in(table, Here) ->
    (unused(table) ->
      write('This is were you usually eat your meals or work if you need more space. The '), ansi_format([bold, fg(green)], 'table', []), write(' is made of a dark reddish wood and it''s big enough for at least 8 people to sit around it. After taking a closer look at the things laid out on the table you notice the '), ansi_format([bold, fg(blue)], 'house_keys', []), write(' under the folded tablecloth.'), nl,
      retract(unused(table)), assert(at(house_keys, livingroom))
      ;
      write('This is were you usually eat your meals or work if you need more space. The '), ansi_format([bold, fg(green)], 'table', []), write(' is made of a dark reddish wood and it''s big enough for at least 8 people to sit around it.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(couch) :-
  i_am_at(Here), 
  (in(couch, Here) ->
    (unused(couch) ->
      write('This is your '), ansi_format([bold, fg(green)], 'couch', []), write('. It''s were you hang out during the day and read books. You hate napping on it. Right now the cushions and blanket are bunched up in a weird way, like something is underneath.'), nl
      ;
      write('This is your '), ansi_format([bold, fg(green)], 'couch', []), write('. It''s were you hang out during the day and read books. You hate napping on it. The cushions are back to laying flat after you pulled out Can #4 from underneath them.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).
  
inspect(desk) :-
  i_am_at(Here), 
  (in(desk, Here) ->
    (unused(desk) ->
      write('You take a closer look at the pile of notes. You''re prepping for exams so your desk is full of notes and loose pens. It looks like there''s something hidden behind the large stack of books to the side...'), nl
      ;
      write('You look at your notes again. The '), ansi_format([bold, fg(green)], 'desk', []), write(' is even more of a mess now since you rearanged it. Can #8 used to be hidden behind some books here.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(bed) :-
  i_am_at(Here), 
  (in(bed, Here) ->
    (unused(bed) ->
      write('You inspect the blankets and pillows on your '), ansi_format([bold, fg(green)], 'bed', []), write('. You made it this morning so everything is nice, tidy, and flat. The fluffy covers and soft pillows look very inviting'), nl
      ;
      write('You look at the '), ansi_format([bold, fg(green)], 'bed', []), write(' again. The blankets are no longer neatly folded and the pillows are clearly out of place. The nap you had must''ve been really good.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(string) :-
  i_am_at(Here), 
  (in(string, Here) ->
    write('It''s a thin white '), ansi_format([bold, fg(green)], 'string', []), write(', probably cotton. A little bow is tied at the end. It looks like there''s something heavy on the other end.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(clothing_rack) :-
  i_am_at(Here), 
  (in(clothing_rack, Here) ->
    (unused(clothing_rack) ->
      write('You look closer at one of your favourite denim jackets. The fabric is pretty thick but despite that you can still see something bulging in its inner pocket. You reach in and find '), ansi_format([bold, fg(magenta)], 'Can #9', []), nl,
      retract(unfound(can9)),  increment_can_counter, assert(found(can9)), retract(unused(clothing_rack))
      ;
      write('You inspect the '), ansi_format([bold, fg(green)], 'clothing_rack', []), write(' again. Your denim jacket now hangs flat on its hanger. Can #9 used to be in the inner pocket.')
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(paper_box) :-
  i_am_at(Here), 
  (in(paper_box, Here) ->
    (unused(paper_box) ->
      write('It''s a '), ansi_format([bold, fg(green)], 'paper_box', []), write(' completely covered in many many layers of packing tape. It''s definetely too sealed for you to just open it with your bare hands. A knife would surely help here.'), nl
      ;
      write('It''s the '), ansi_format([bold, fg(green)], 'paper_box', []), write(', now torn open. Inside only a heap of white packing peanuts remains.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(sink) :-
  i_am_at(Here), 
  (in(sink, Here) ->
    write('It''s the bathroom '), ansi_format([bold, fg(green)], 'sink', []), write(', perfectly clean and almost sparkling. So far there haven''t been any leaks.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(toilet) :-
  i_am_at(Here), 
  (in(toilet, Here) ->
    write('It''s the '), ansi_format([bold, fg(green)], 'toilet', []), write('. It makes a funny noise when you flush it.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).