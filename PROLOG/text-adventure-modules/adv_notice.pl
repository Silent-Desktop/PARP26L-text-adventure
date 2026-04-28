/* These rules describe text upon noticing an item. There are separate texts for when an item is spotted in each location*/
:- module(adv_notice, [notice/2]).

  /* items */
    /*unique interaction for can5*/
      notice(can5, livingroom) :-
        write('When you look at the '), ansi_format([bold, fg(green)], 'table', []), write(' you see some used plates, a folded tablecloth and next to them, slightly obscured by an empty cup is '), ansi_format([bold, fg(magenta)], 'Can #5', []), nl,
        retract(unfound(can5)),  increment_can_counter, assert(found(can5)),
        retract(at(can5, livingroom)).
    /*kitchen*/
      notice(knife, kitchen)         :- write('There is a '), ansi_format([bold, fg(blue)], 'knife', []), write(' on the countertop near the sink. It looks sharp.'), nl.
      notice(chair, kitchen)         :- write('You left the '), ansi_format([bold, fg(blue)], 'chair', []), write(' here, not sure why but maybe you could stand on it.'), nl.
      notice(house_keys, kitchen)    :- write('You left the '), ansi_format([bold, fg(blue)], 'house_keys', []), write(' on the countertop. The cabinets aren''t even locked so any keys are pointless here but alright.'), nl.
      notice(boots, kitchen)         :- write('You left the '), ansi_format([bold, fg(blue)], 'boots', []), write(' here. And now theres mud on the floor. In the kitchen. Great.'), nl.
      notice(towel, kitchen)         :- write('YOu left your '), ansi_format([bold, fg(blue)], 'towel', []), write(' here. It''s still a bit moist and might leave a wet stain on the countertop'), nl.
    /*livingroom*/
      notice(knife, livingroom)         :- write('You left the '), ansi_format([bold, fg(blue)], 'knife', []), write(' on the table. There is no use for it here right now but maybe you''ll have dinner soon.'), nl.
      notice(chair, livingroom)         :- write('There is a '), ansi_format([bold, fg(blue)], 'chair', []), write(' here, just next to the table. Usually you''d just sit on it but sometimes you use it to reach higher places.'), nl.
      notice(house_keys, livingroom)    :- write('The '), ansi_format([bold, fg(blue)], 'house_keys', []), write(' are here, on the table. Usually you leave them here anyway, easier to find later.'), nl.
      notice(boots, livingroom)         :- write('You left the '), ansi_format([bold, fg(blue)], 'boots', []), write(' on the floor, a safe distance from the couch. They''re still muddy.'), nl.
      notice(towel, livingroom)         :- write('You left your '), ansi_format([bold, fg(blue)], 'towel', []), write(' here, on the couch. Terrible idea since the towel isn''t perfectly dry. Why would you do that?'), nl.
    /*balcony*/
      notice(knife, balcony)         :- write('You left the '), ansi_format([bold, fg(blue)], 'knife', []), write(' here. You can''t really do anything with it here.'), nl.
      notice(chair, balcony)         :- write('You left the '), ansi_format([bold, fg(blue)], 'chair', []), write(' here. You could sit and enjoy the morning sun, just don'' stand on it here. That can''t be safe near the edge.'), nl.
      notice(house_keys, balcony)    :- write('You left the '), ansi_format([bold, fg(blue)], 'house_keys', []), write(' here, behind the potten '), ansi_format([bold, fg(green)], 'plant', []), write(' in the corner. A safe spot for sure.'), nl.
      notice(boots, balcony)         :- write('You left the '), ansi_format([bold, fg(blue)], 'boots', []), write(' on the dirty tiled floor. Maybe the mud on them will dry out in the sun.'), nl.
      notice(towel, balcony)         :- write('You left your '), ansi_format([bold, fg(blue)], 'towel', []), write(' here, next to the other ones hanging on the railing. Perfect spot for it to dry.'), nl.
    /*hall*/
      notice(knife, hall)            :- write('You left your '), ansi_format([bold, fg(blue)], 'knife', []), write(' here. The shiny blade is lying on the tiled floor.'), nl.
      notice(chair, hall)            :- write('You left the '), ansi_format([bold, fg(blue)], 'chair', []), write(' here. It''s standing near the door, almost blocking it'), nl.
      notice(house_keys, hall)       :- write('You left the '), ansi_format([bold, fg(blue)], 'house_keys', []), write(' here, hanging on the door handle. This is the exact place you could use them you know.'), nl.
      notice(boots, hall)            :- write('There is a pair of your heavy duty '), ansi_format([bold, fg(blue)], 'boots', []), write(' here. They''re still covered with wet mud from outside.'), nl.
      notice(towel, hall)            :- write('You left the '), ansi_format([bold, fg(blue)], 'towel', []), write(' here, on the empty coat rack. At least you didn''t put it on the muddy floor.'), nl.
    /*bedroom*/
      notice(knife, bedroom)         :- write('You left the '), ansi_format([bold, fg(blue)], 'knife', []), write(' here, on top of the bed. Please don''t fall asleep on it.'), nl.
      notice(chair, bedroom)         :- write('You left the '), ansi_format([bold, fg(blue)], 'chair', []), write(' here, near the desk.'), nl.
      notice(house_keys, bedroom)    :- write('You let the '), ansi_format([bold, fg(blue)], 'house_keys', []), write(', on the desk. Right now they''re in plain view but often they get lost amoung your notes and books.'), nl.
      notice(boots, bedroom)         :- write('You left your '), ansi_format([bold, fg(blue)], 'boots', []), write(' here. Horrible idea honestly since now there is mud on the wooden flooring.'), nl.
      notice(towel, bedroom)         :- write('You left the '), ansi_format([bold, fg(blue)], 'towel', []), write(' here. It''s still a bit wet so you jsut left it on the edge of the desk.'), nl.
    /*closet*/
      notice(knife, closet)         :- write('You left the '), ansi_format([bold, fg(blue)], 'knife', []), write(' here. Clearly it would be useful here, but you aren''t using it at the moment.'), nl.
      notice(chair, closet)         :- write('You set down the '), ansi_format([bold, fg(blue)], 'chair', []), write(' here. It barely fits in the small space.'), nl.
      notice(house_keys, closet)    :- write('You left the '), ansi_format([bold, fg(blue)], 'house_keys', []), write(' here, in the pocket of one of your jackets. This a perfect way to forget about them and lose them later.'), nl.
      notice(boots, closet)         :- write('You left the dirty '), ansi_format([bold, fg(blue)], 'boots', []), write(' here. The soft rug in the floor in now caked in black mud. Congrats.'), nl.
      notice(towel, closet)         :- write('You left your '), ansi_format([bold, fg(blue)], 'towel', []), write(' here. It''s not a great place for it, the wetness from it might transfer to some of your shirts and jackets.'), nl.
    /*bathroom*/
      notice(knife, bathroom)        :- write('You left the '), ansi_format([bold, fg(blue)], 'knife', []), write(' here, on the sink. Just remember that you have razors somewhere and they are much better for shaving than a kitchen knife.'), nl.
      notice(chair, bathroom)        :- write('You left the '), ansi_format([bold, fg(blue)], 'chair', []), write(' here. Why.'), nl.
      notice(house_keys, bathroom)   :- write('You left the '), ansi_format([bold, fg(blue)], 'house_keys', []), write(' here. There aren''t any locks in your bathroom so no reason to keep them here.'), nl.
      notice(boots, bathroom)        :- write('You left your '), ansi_format([bold, fg(blue)], 'boots', []), write(' here. At least the mud won''t leave any permanent stains on the bathroom tiles. Probably.'), nl.
      notice(towel, bathroom)        :- write('Theres a '), ansi_format([bold, fg(blue)], 'towel', []), write(' here, hanging from the top of the shower door. It''s still a bit wet and you can see a few drops of water hit the tiles below it.'), nl.

/* set pieces */
notice(dishwasher, kitchen)   :- write('There is a '), ansi_format([bold, fg(green)], 'dishwasher', []), write(' here, a true lifesaver since you hate washing the dishes by hand.'), nl.
notice(cupboard, kitchen)   :- write('There is a large '), ansi_format([bold, fg(green)], 'cupboard', []), write(' right at your eye-level and it''s slightly ajar.'), nl.
notice(trashcan, kitchen)   :- write('Next to your feet, there is a big square '), ansi_format([bold, fg(green)], 'trashcan', []), write(', with its lid closed.'), nl.
notice(table, livingroom)   :- write('There is a '), ansi_format([bold, fg(green)], 'table', []), write(' here, used for dining or gatherings.'), nl.
notice(couch, livingroom)   :- write('There is a '), ansi_format([bold, fg(green)], 'couch', []), write(' here, it looks very comfortable with all its cushions and the fluffy blanket on top.'), nl.
notice(desk, bedroom)   :- write('There is a '), ansi_format([bold, fg(green)], 'desk', []), write(' pushed up against the wall. This is where you work during the day.'), nl.
notice(bed, bedroom)   :- write('Your '), ansi_format([bold, fg(green)], 'bed', []), write(' is in the far corner of the room. It''s messy and unmade, the usual sight given your sleep schedule.'), nl.
notice(plant, balcony)   :- write('On the floor in the corner there is a large potted '), ansi_format([bold, fg(green)], 'plant', []), write('. It''s most likely a fern but you never bothered to make sure. It''s leaves are large and sprawling.'), nl.
notice(railing, balcony)   :- write('The balcony has a thick metal '), ansi_format([bold, fg(green)], 'railing', []), write(' and right now there are a couple of towels hanging from it.'), nl.
notice(string, balcony)   :- write('Over the edge of the '), ansi_format([bold, fg(green)], 'railing', []), write(' there is a thin '), ansi_format([bold, fg(green)], 'string', []), write(' hanging. It''s tied to one of the metal bars and it''s pulled.'), nl.
notice(house_door, hall)   :- write('The '), ansi_format([bold, fg(green)], 'house_door', []), write(' to your apartment is here and it''s currently locked.'), nl.
notice(clothing_rack, closet)   :- write('There is a '), ansi_format([bold, fg(green)], 'clothing_rack', []), write(' here, where you keep your shirts and some pants. It looks dusty.'), nl.
notice(paper_box, closet) :-
  (unused(paper_box) ->
    write('On the floor there is a small '), ansi_format([bold, fg(green)], 'paper_box', []), write(' completely covered in packing tape. You''ll need something sharp to open it.'), nl
    ;
    write('The '), ansi_format([bold, fg(green)], 'paper_box', []), write(' on the floor has already been opened with a knife, inside are only white packing peanuts.'), nl
  ).

notice(toilet, bathroom)    :- write('There is a '), ansi_format([bold, fg(green)], 'toilet', []), write(' here, also very clean. You had guests over so you had to scrub the bathroom.'), nl.
notice(shower, bathroom) :- 
  (unused(shower) ->
    write('Your '), ansi_format([bold, fg(green)], 'shower', []), write(' is here. The walls are clear glass but they''re a bit cloudy since you haven''t cleaned them in a while. On a shelf built into the wall you keep your shampoo bottles. Are there more of them than usual...?'), nl
    ;
    write('Your '), ansi_format([bold, fg(green)], 'shower', []), write(' is here. The walls are clear glass but they''re a bit cloudy since you haven''t cleaned them in a while. On a shelf built into the wall you keep your shampoo bottles.'), nl
  ).

notice(sink, bathroom)      :- write('There is a '), ansi_format([bold, fg(green)], 'sink', []), write(' here, with nothing on it. You must have put everything away to make it cleaner.'), nl.
