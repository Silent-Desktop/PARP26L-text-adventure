/* this is a text adventure for PARP 26L in prolog by Żą */

:- dynamic i_am_at/1, at/2, in/2, holding/1, unfound/1, found/1, unused/1, running/1, action_counter/1, can_counter/1.
:- retractall(at(_, _)), retractall(in(_, _)), retractall(i_am_at(_)), retractall(action_counter(_)), retractall(can_counter(_)), assert(action_counter(0)), assert(can_counter(0)).

/* List of locations in this adventure: */
location(kitchen).
location(living_room).
location(balcony).
location(hall).
location(bedroom).
location(closet).
location(bathroom).

/* List of items in this adventure: */
item(knife).
item(chair).
item(house_keys).
item(boots).

/* List of setpieces in this adventure: */
setpiece(dishwasher).
setpiece(cupboard).
setpiece(fridge).
setpiece(trashcan).
setpiece(table).
setpiece(couch).
setpiece(desk).
setpiece(bed).
setpiece(plant).
setpiece(railing).
setpiece(string).
setpiece(house_door).
setpiece(clothing_rack).
setpiece(paper_box).
setpiece(shower).
setpiece(sink).
setpiece(toilet).

/* list of things that have a special one-time interaction, which is almost all of them*/
unused(house_door).
unused(cupboard).
unused(paper_box).
unused(desk).
unused(boots).
unused(trashcan).
unused(plant).
unused(table).
unused(railing).
unused(dishwasher).
unused(couch).
unused(bed).
unused(shower).
unused(clothing_rack).
/*unused(string)*/
/*logically this could be here but the string has a one time interaction and then its removed completely so this isnt required*/

/* this is an action counter */
increment_action_counter  :-
  action_counter(V1),
  retractall(action_counter(_)),
  succ(V1, V2),
  assert(action_counter(V2)).

how_many_actions :-
  action_counter(Value),
  write('You''ve taken '), write(Value), write(' action(s).'), nl.

/* this is can counter */
increment_can_counter  :-
  can_counter(V1),
  retractall(can_counter(_)),
  succ(V1, V2),
  assert(can_counter(V2)).

/* list of more individual interactions */
running(dishwasher). /*you better go catch it */


/* List of initial locations of items: */
at(knife, kitchen).
at(chair, living_room).
/*at(house_keys, living_room).*/
/*this becomes true after inspecting the table in the dining room.*/
at(boots, hall).
at(towel, bathroom).

/* this is unique only to can5 as it need to be noticed when enterring the room*/
at(can5, living_room).

/* List of locations of the setpieces: */
in(dishwasher, kitchen).
in(cupboard, kitchen).
in(trashcan, kitchen).
in(fridge, kitchen).
in(table, living_room).
in(couch, living_room).
in(desk, bedroom).
in(bed, bedroom).
in(plant, balcony).
in(railing, balcony).
/* in(string, balcony). */ 
  /*generally speaking the string is supposed to be there but unnoticed at first
    see inspect(railing) for updates to this */
in(house_door, hall).
in(clothing_rack, closet).
in(paper_box, closet).
in(sink, bathroom).
in(shower, bathroom).
in(toilet, bathroom).

/* List of paths between locations: */
path(kitchen, living_room).
path(living_room, kitchen).
path(living_room, balcony).
path(balcony, living_room).
path(living_room, hall).
path(hall, living_room).
path(hall, bathroom).
path(bathroom, hall).
path(hall, bedroom).
path(bedroom, hall).
path(bedroom, closet).
path(closet, bedroom).

/* This is a list of trophies to obtain */
unfound(can1).
unfound(can2).
unfound(can3).
unfound(can4).
unfound(can5).
unfound(can6).
unfound(can7).
unfound(can8).
unfound(can9).
unfound(can10).
unfound(can11).
unfound(can12).

/* This is a counter of trophies found during the adventure:
TOmDO */

/* Standard command and ways of interacting with the game: */
  /* These rules describe how to pick up an object. */
    take(_) :-
      increment_action_counter, fail.

    take(X) :-
            holding(X),
            write('You''re already holding it!'),
            !, nl.

    take(X) :-
            i_am_at(Place),
            at(X, Place),
            retract(at(X, Place)),
            assert(holding(X)),
            picked_up(X),
            !, nl.

    take(_) :-
            write('I don''t see it here.'),
            nl.

  /* These rules describe how to put down an object. */

    drop(_) :-
      increment_action_counter, fail.

    drop(X) :-
            holding(X),
            i_am_at(Place),
            retract(holding(X)),
            assert(at(X, Place)),
            dropped(X),
            !, nl.

    drop(_) :-
            write('You aren''t holding it!'),
            nl.

  /* This rule tells how to move for one location to another. */
    go(_) :-
      increment_action_counter, fail.

    go(There) :-
            i_am_at(Here),
            path(Here, There),
            retract(i_am_at(Here)),
            assert(i_am_at(There)),
            !, look.

    go(Here) :-
            i_am_at(Here),
            write('You are already here.'), !.

    go(_) :-
            write('You can''t go there.').

  /* This rule tells how to look about you. */

    look :-
            increment_action_counter,
            i_am_at(Place),
            describe(Place),
            nl,
            notice_setpieces_in(Place),
            nl,
            notice_items_at(Place),
            nl,
            notice_destinations_from(Place),
            nl.

  /* This rule describes inspecting your own inventory */

    inventory :-
              holding(X),
              write(' -'), write(X), nl,
              fail.

    found :-
            found(X),
            describe(X),
            fail.
    
    % unfound :-
    %         unfound(X),
    %         write(' -'), write(X), nl,
    %         fail.

  /* These rules set up a loop to mention all the items in the current location.*/

    notice_items_at(Place) :-
            at(X, Place),
            notice(X, Place),
            fail.

    notice_items_at(_).

  /* These rules set up a loop to mention all set pieces in the current location.*/

    notice_setpieces_in(Place) :-
            in(Y, Place),
            notice(Y, Place),
            fail.

    notice_setpieces_in(_).

  /* These rules set up a loop to mention all possible destinations
  reachable from the current location */

    notice_destinations_from(Place) :-
            path(Place, Destination),
            write('You can see that from here you can reach '), write(Destination), nl,
            fail.

    notice_destination_from(_).

  /* This rule just writes out game instructions. */

  instructions :-
          nl,
          write('Enter commands using standard Prolog syntax.'), nl,
          write('Available commands are:'), nl,
          write('start.             -- to start the game.'), nl,
          write('go(Place)          -- to go to that Place.'), nl,
          write('take(Object).      -- to pick up an object.'), nl,
          write('drop(Object).      -- to put down an object.'), nl,
          write('look.              -- to look around you again.'), nl,
          write('interact.         -- to interact with something in the scene. (NOT FINISHED)'), nl,
          write('inspect.           -- to take a closer look at something. (NOT IMPLEMENTED)'), nl,
          write('inventory.         -- to check what items you have.'), nl,
          write('found.             -- to check which trophies you''ve already found.'), nl,
          write('unfound.           -- to check which trophies you''re still missing.'), nl,
          write('instructions.      -- to see this message again.'), nl,
          write('halt.              -- to end the game and quit.'), nl,
          write('The goal of the game is to find as many cans as possible hidden around the house. When you think you''re done return to the kitchen and interract with the FRIDGE for the final score.'), nl,
          nl.


/* This rule prints out instructions and tells where you are at the beginning of the game. */

start :-
        write('You are in your kitchen, staring into your fridge. Lately you''ve bought exactly 12 cans of your favourite energy drink to last you through the exam season. You had some friends over last night and they must have decided on a prank to hide all of them from you, because the fridge is nearly empty without a single perfectly chilled can. They''re not in the fridge but they wouldn''t steal so they must be around the house. Better get to searching!'), nl,
        instructions,
        look.

/* These rules describe the locations and trophies. */

describe(kitchen)      :- write('This is the kitchen. The countertops are clean and there are no dirty dishes in the sink. Clearly you''ve been busy or just haven''t eaten in a long time.'), nl.
describe(living_room)      :- write('This is the living room, where you spend your free time and occasionaly nap.'), nl.
describe(balcony)      :- write('This is the balcony. From here you have a nice outlook onto the yard behind your building.'), nl.
describe(hall)      :- write('This is the hall, where you keep your coats and shoes. There''s some unvacuumed sand on the tiled floor.'), nl.
describe(bedroom)      :- write('This is the bedroom, where you spend most of your time. The blind are shut but there is a small desk lamp illuminating the room.'), nl.
describe(closet)      :- write('This is the closet, where you keep most of your daily clothes. There are dust speckles in the air and you can smell your laundry detergent faintly.'), nl.
describe(bathroom)      :- write('This is the bathroom and it looks scrubbed clean. You must have been very bored lately.'), nl.

describe(can1) :- write('Can #1, There are pictures of butterflies on it. The drink falvour is disgustingly peachy.'), nl.
describe(can2) :- write('Can #2, There are drawings of fish and underwater algae all the way around it. You''re pretty sure the flavour is pineapple.'), nl.
describe(can3) :- write('Can #3, It''s a vivid neon green color. It''s the best flavour - sour apple.'), nl.
describe(can4) :- write('Can #4, It''s pink in color and the drink is probably strawberry flavored.'), nl.
describe(can5) :- write('Can #5, The color of it is a really bright cheerful yellow. There''s some drawing on it as well but they''re pretty meaningless. The flavour is bad.'), nl.
describe(can6) :- write('Can #6, It''s a uniform soft pinkish-orange color. The drink tastes like peach and lemon.'), nl.
describe(can7) :- write('Can #7, It has a gold coating with sparkling silver details. It''s reeeaaaly shiny. The drink tastes like cream soda.'), nl.
describe(can8) :- write('Can #8, It''s a really bright pastel pink. The drink inside tastes like bubblegum.'), nl.
describe(can9) :- write('Can #9, It''s black with some green gradient. There''s "NITRO" written at the bottom. Why did you buy this flavour?'), nl.
describe(can10) :- write('Can #10, It''s black with red details. The drink flavour is cherry.'), nl.
describe(can11) :- write('Can #11, completely white with some grey shading and silver details. You''re not sure what the flavour is supposed to be.'), nl.
describe(can12) :- write('Can #12, It''s a deep purple color with some vines drawn around it. The drink flavour is most likely grape.'), nl.

/* These rules describe text upon noticing an item. There are separate texts for when an item is spotted in each location
This might a common over-ambitious blunder.*/
  /* items */
    /*unique interaction for can5*/
      notice(can5, living_room) :-
        write('When you look at the table you see some used plates, a folded tablecloth and next to them, slightly obscured by an empty cup is Can #5!'), nl,
        retract(unfound(can5)),  increment_can_counter, assert(found(can5)),
        retract(at(can5, living_room)).
    /*kitchen*/
      notice(knife, kitchen)         :- write('There is a KNIFE on the countertop near the sink. It looks sharp.'), nl.
      notice(chair, kitchen)         :- write('You left the CHAIR here, not sure why but maybe you could stand on it.'), nl.
      notice(house_keys, kitchen)    :- write('You left the HOUSE KEYS on the countertop. The cabinets aren''t even locked so any keys are pointless here but alright.'), nl.
      notice(boots, kitchen)         :- write('You left the boots here. And now theres mud on the floor. In the kitchen. Great.'), nl.
      notice(towel, kitchen)         :- write('YOu left your towel here. It''s still a bit moist and might leave a wet stain on the countertop'), nl.
    /*living_room*/
      notice(knife, living_room)         :- write('You left the KNIFE on the table. There is no use for it here right now but maybe you''ll have dinner soon.'), nl.
      notice(chair, living_room)         :- write('There is a CHAIR here, just next to the table. Usually you''d just sit on it but sometimes you use it to reach higher places.'), nl.
      notice(house_keys, living_room)    :- write('The HOUSE KEYS are here, on the table. Usually you leave them here anyway, easier to find later.'), nl.
      notice(boots, living_room)         :- write('You left the BOOTS on the floor, a safe distance from the couch. They''re still muddy.'), nl.
      notice(towel, living_room)         :- write('You left your TOWEL here, on the couch. Terrible idea since the towel isn''t perfectly dry. Why would you do that?'), nl.
    /*balcony*/
      notice(knife, balcony)         :- write('You left the KNIFE here. You can''t really do anything with it here.'), nl.
      notice(chair, balcony)         :- write('You left the CHAIR here. You could sit and enjoy the morning sun, just don'' stand on it here. That can''t be safe near the edge.'), nl.
      notice(house_keys, balcony)    :- write('You left the HOUSE KEYS here, behind the potten PLANT in the corner. A safe spot for sure.'), nl.
      notice(boots, balcony)         :- write('You left the BOOTS on the dirty tiled floor. Maybe the mud on them will dry out in the sun.'), nl.
      notice(towel, balcony)         :- write('You left your TOWEL here, next to the other ones hanging on the railing. Perfect spot for it to dry.'), nl.
    /*hall*/
      notice(knife, hall)            :- write('You left your KNIFE here. The shiny blade is lying on the tiled floor.'), nl.
      notice(chair, hall)            :- write('You left the CHAIR here. It''s standing near the door, almost blocking it'), nl.
      notice(house_keys, hall)       :- write('You left the HOUSE KEYS here, hanging on the door handle. This is the exact place you could use them you know.'), nl.
      notice(boots, hall)            :- write('There is a pair of your heavy duty BOOTS here. They''re still covered with wet mud from outside.'), nl.
      notice(towel, hall)            :- write('You left the TOWEL here, on the empty coat rack. At least you didn''t put it on the muddy floor.'), nl.
    /*bedroom*/
      notice(knife, bedroom)         :- write('You left the KNIFE here, on top of the bed. Please don''t fall asleep on it.'), nl.
      notice(chair, bedroom)         :- write('You left the CHAIR here, near the desk.'), nl.
      notice(house_keys, bedroom)    :- write('You let the HOUSE KEYS, on the desk. Right now they''re in plain view but often they get lost amoung your notes and books.'), nl.
      notice(boots, bedroom)         :- write('You left your BOOTS here. Horrible idea honestly since now there is mud on the wooden flooring.'), nl.
      notice(towel, bedroom)         :- write('You left the TOWEL here. It''s still a bit wet so you jsut left it on the edge of the desk.'), nl.
    /*closet*/
      notice(knife, closet)         :- write('You left the KNIFE here. Clearly it would be useful here, but you aren''t using it at the moment.'), nl.
      notice(chair, closet)         :- write('You set down the CHAIR here. It barely fits in the small space.'), nl.
      notice(house_keys, closet)    :- write('You left the HOUSE KEYS here, in the pocket of one of your jackets. This a perfect way to forget about them and lose them later.'), nl.
      notice(boots, closet)         :- write('You left the dirty BOOTS here. The soft rug in the floor in now caked in black mud. Congrats.'), nl.
      notice(towel, closet)         :- write('You left your TOWEL here. It''s not a great place for it, the wetness from it might transfer to some of your shirts and jackets.'), nl.
    /*bathroom*/
      notice(knife, bathroom)        :- write('You left the KNIFE here, on the sink. Just remember that you have razors somewhere and they are much better for shaving than a kitchen knife.'), nl.
      notice(chair, bathroom)        :- write('You left the CHAIR here. Why.'), nl.
      notice(house_keys, bathroom)   :- write('You left the HOUSE KEYS here. There aren''t any locks in your bathroom so no reason to keep them here.'), nl.
      notice(boots, bathroom)        :- write('You left your BOOTS here. At least the mud won''t leave any permanent stains on the bathroom tiles. Probably.'), nl.
      notice(towel, bathroom)        :- write('Theres a TOWEL here, hanging from the top of the shower door. It''s still a bit wet and you can see a few drops of water hit the tiles below it.'), nl.

/* set pieces */
notice(dishwasher, kitchen)   :- write('There is a DISHWASHER here, a true lifesaver since you hate washing the dishes by hand.'), nl.
notice(cupboard, kitchen)   :- write('There is a large CUPBOARD right at your eye-level and its slightly ajar.'), nl.
notice(trashcan, kitchen)   :- write('Next to your feet, there is a big square TRASHCAN, with its lid closed.'), nl.
notice(table, living_room)   :- write('There is a TABLE here, used for dining or gatherings.'), nl.
notice(couch, living_room)   :- write('There is a COUCH here, it looks very comfortable with all its cushions and the fluffy blanket on top.'), nl.
notice(desk, bedroom)   :- write('There is a DESK pushed up against the wall. This is where you work during the day.'), nl.
notice(bed, bedroom)   :- write('Your BED is in the far corner of the room. It''s messy and unmade, the usual sight given your sleep schedule.'), nl.
notice(plant, balcony)   :- write('On the floor in the corner there is a large potted PLANT. It''s most likely a fern but you never bothered to make sure. It''s leaves are large and sprawling.'), nl.
notice(railing, balcony)   :- write('The balcony has a thick metal RAILING and right now there are a couple of towels hanging from it.'), nl.
notice(string, balcony)   :- write('Over the edge of the RAILING there is a thin STRING hanging. Its tied to one of the metal bars and its pulled.'), nl.
notice(house_door, hall)   :- write('The HOUSE DOOR to your apartment is here and it''s currently locked.'), nl.
notice(clothing_rack, closet)   :- write('There is a CLOTHING RACK here, where you keep your shirts and some pants. It looks dusty.'), nl.
notice(paper_box, closet) :-
  (unused(paper_box) ->
    write('On the floor there is a small PAPER BOX completely covered in packing tape. You''ll need something sharp to open it.'), nl
    ;
    write('The PAPER BOX on the floor has already been opened with a knife, inside are only white packing peanuts.'), nl
  ).

notice(toilet, bathroom)    :- write('There is a TOILET here, also very clean. You had guests over so you had to scrub the bathroom.'), nl.
notice(shower, bathroom) :- 
  (unused(shower) ->
    write('Your shower is here. The walls are clear class but they''re a bit cloudy since you haven''t cleaned them in a while. On a shelf built into the wall you keep your shampoo bottles. Are there more of them than usual...?'), nl
    ;
    write('Your shower is here. The walls are clear class but they''re a bit cloudy since you haven''t cleaned them in a while. On a shelf built into the wall you keep your shampoo bottles.'), nl
  ).

notice(sink, bathroom)      :- write('There is a SINK here, with nothing on it. You must have put everything away to make it cleaner.'), nl.

/* These rules describe text upon picking up an item. */
picked_up(knife)      :- write('You pick up the KNIFE. The handle is solid black and cold to the touch.'), nl.
picked_up(chair)      :- write('You somehow manage to pick up the CHAIR. It''s a bit weird to hold but you''ev done this before.'), nl.
picked_up(house_keys)      :- write('You pick up the HOUSE_KEYS, and they fit neatly in your back pocket.'), nl.
picked_up(boots)  :- 
  write('You pick up the BOOTS and get some mud on your hands. Yuck.'), nl,
  write('When you rotate on of the boots something cylindrical falls out into your hand. It''s Can #11!'), nl, 
  retract(unfound(can11)),  increment_can_counter, assert(found(can11)).
picked_up(towel)  :- write('You pick up the TOWEL. It cold and wet to the touch. It still hasn''t dried'), nl.

/* These rules describe text upon dropping an item. */
dropped(knife)      :- write('You leave the KNIFE here, you don''t want to accidentally stab your self with it later.'), nl.
dropped(chair)      :- write('You put down the CHAIR. It''s a bit useless without the table next to it but at least you could stand on it.'), nl.
dropped(house_keys) :- write('You take the HOUSE KEYS out of your pocket and leave them here. No point carrying a bundle of keys without a reason.'), nl.
dropped(boots)      :- write('You leave the dirty BOOTS here. The mud is on your clothes now as well. Disgusting.'), nl.
dropepd(towel)      :- write('You drop the wet TOWEL. This might leave a puddle.'), nl.

/* These rules describe interactions with setpieces */

interact(_) :-
      increment_action_counter, fail.

interact(dishwasher)    :- 
  i_am_at(Here), 
  (in(dishwasher, Here) ->
    (unused(dishwasher) ->
      (running(dishwasher) ->
        write('The dishwasher is rumbling and the little display is on - there''s a wash cycle still going. You''l have to wait some time before opening it.'), nl
        ;
        write('The little display is off and the dishwasher isn''t making any noises - the wash cycle must be done. You grab the handle and open the door. Inside it''s still warm and humid. Between plates and pots you find Can #1!.'), nl,
        retract(unfound(can1)),  increment_can_counter, assert(found(can1)),
        retract(unused(dishwasher))
      )
      ;
      write('The dishwasher has already been opened. The plates inside are drying. Can #1 used to be here.'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).


interact(couch)    :-
  i_am_at(Here), 
  (in(couch, Here) ->
    (unused(couch) ->
      write('You decide to take a break and sit down on the COUCH. The cushions are soft but there is something hard poking you in the hip. You reach under the blanket and find Can #4!'), nl,
      retract(unfound(can4)),  increment_can_counter, assert(found(can4)),
      retract(unused(couch))
      ;
      write('Against better judgment you decide to sit on the couch again and waste more time. It''s way comfier than previously. Can #4 used to be hidden beneath the blanket here.'), nl
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
        write('You use the sharp knife to cut through the packing tape. Inside the box is a lot of white packing peanuts but underneath them you find Can #10!'), nl,
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

interact(cupboard)  :-
  i_am_at(Here),
  (in(cupboard, Here) ->
    write('You open the door of the cupboard wider.'), nl,
    (unused(cupboard) ->
      (holding(chair) ->
        write('You climb the chair to reach the top shelf and grab Can #2!'), nl,
        retract(unfound(can2)),  increment_can_counter, assert(found(can2)),
        retract(unused(cupboard))
        ;
        write('You can see something on the top shelf but It''s much too high for you to reach.'), nl
      )
      ;
      write('You look into the cupboard again but besides some clean cups and plates there''s nothing of interest anymore. Can #2 used to be on the top shelf.')
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(string) :-
  i_am_at(Here), 
  (in(string, Here) ->
    write('You grab the string at the edge of the railing and start gently pulling. There is something heavy tied to it. Finally you grab a hold of Can #6!'), nl,
    retract(unfound(can6)),  increment_can_counter, assert(found(can6)), retract(in(string, balcony)), retract(unused(string))
  ).

interact(fridge)    :- 
  i_am_at(Here), 
  (in(fridge, Here) ->
    write('You open the fridge and return all the cans that you''ve found to their shelf. You''re looking forward to ejoying a cold drink'), nl,
    how_many_actions, nl, 
    write('In total you have found  '),
    can_counter(Value),
    write(Value), write(' can(s).'), nl, nl,
    write('You have finished your search, type "halt." to end the game. Thank you for playing.'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(trashcan)    :- 
  i_am_at(Here), 
  (in(trashcan, Here) ->
    (unused(trashcan) ->
      write('You grab the plastic lid and open the trashcan. Inside nestled between old takeout boxes and paper scraps is Can #3!'), nl,
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
      write('You squat down to touch the plant. After some searching under its many leaves you find Can #7!'), nl,
      retract(unfound(can7)),  increment_can_counter, assert(found(can7)),
      retract(unused(plant))
      ;
      write('You ruffle the plants leaves again but besides a couple of dried petals and small bugs nothing of interest falls out. Can #3 used to be hidden below the leaves.')
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(house_door)  :-
  i_am_at(Here), 
  (in(house_door, Here) ->
    (unused(house_door) ->
      write('You stand in front of the door of your aparment'), nl,
      (holding(house_keys) ->
        write('You pull out the house keys and use them to easily open both locks. The door is now open. On your doorstep you find Can #12!'), nl,
        retract(unfound(can12)),  increment_can_counter, assert(found(can12)),
        retract(unused(house_door))
        ;
        write('The door is locked and with your current equipment there isn''t much you can do about it.'), nl
      )
      ;
      write('You''ve already open the door. Can #12 used to be outside standing on your doormat. You made sure to lock the door again right?'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(bed)  :-
  i_am_at(Here), 
  (in(bed, Here) ->
    (unused(bed) ->
      write('Despite being unmade the bed looks really inviting. You lie down and the moment your cheek touches the pillow you drift off for a nap.'), nl, nl,
      write('You wake up sometime later, unsure what time it is really is. The house is quiet, even the rumble of the dishwasher in the kitchen has stopped.'), nl,
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
    write('You grab the shower nozle and turn on the water. It splashes a bit an wets your socks.'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(sink) :-
  i_am_at(Here), 
  (in(sink, Here) ->
    write('You turn on the water to rinse your hands. It''s pleasantly cold and leaves droplets on the white sink.'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(toilet) :-
  i_am_at(Here), 
  (in(toilet, Here) ->
    write('You pull up the seat to check for any uncleaned spots. Luckily you''ve been diligent so the white porcelain is spotless. You flussh the toilet and it does indeed make a funny gurgling sound.'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(table) :-
  i_am_at(Here), 
  (in(table, Here) ->
    write('You''re not planning to work right now and it''s ways before dinner time so the table isn''t really useful to you right now.'), nl
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).

interact(desk) :-
  i_am_at(Here), 
  (in(desk, Here) ->
    (unused(desk) ->
      write('You sit down at your desk determined to read through some of your notes. After sifting through piles of paper you reach for a book. Before you can even open it you notice Can #8 was hiding behind it!'), nl,
      retract(unused(desk)), retract(unfound(can8)),  increment_can_counter, assert(found(can8))
      ;
      write('You''ve already looked through your notes and books, creating an even bigger mess. Can #8 used to be hidden behind some books.'), nl
    )
    ;
    write('Whatever you are trying to do you can''t do that here'), nl
  ).
  /*this could be a side quest to clean the boots*/

/* interact(_)  :- write('You can''t do anything interesting with this.'), nl. */

/* These rules are for inspecting setpieces */

inspect(_) :-
      increment_action_counter, fail.

inspect(shower) :-
  i_am_at(Here), 
  (in(shower, Here) ->
    (unused(shower) ->
      write('You walk into the shower, careful not to wet your socks on the moist floor. There''s a sponge here and some shampoo and conditioner bottles on a built-in shelf. After taking a closer look one of the bottles turns out to be Can #7!'), nl,
      retract(unfound(can7)),  increment_can_counter, assert(found(can7)),
      retract(unused(shower))
      ;
      write('You''ve already looked the shower up and down and there isn''t anything else of note here. Can #7 used to be hidden bewteen your shampoo bottles.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(dishwasher) :-
  i_am_at(Here), 
  (in(dishwasher, Here) ->
    (unused(dishwasher) ->
      write('The little display is flashing some numbers and you can hear rumbling and water sloshing inside. It might be a good idea to just take nap instead of waiting here for it to finish.'), nl
      ;
      write('The dishwasher is now open, and you can see some steam coming from inside, There''s warm plates inside and they need some time to fully dry. Can #1 used to be here'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(railing) :-
  i_am_at(Here), 
  (in(railing, Here) ->
    (unused(railing) ->
      write('After looking closer at the railing and the towels hanging from it you notice a thin STRING tied to the edge. Its pulled taut and goes over the edge, as if something heavy was at the end of it.'), nl,
      assert(in(string, balcony))
      ;
      write('It''s the railing. You''ve already found the string at the end of which used to be Can #6.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(cupboard) :-
  i_am_at(Here), 
  (in(cupboard, Here) ->
    (unused(cupboard) ->
      write('The kitchen cupboard is where you keep your plates and cups. However on the top shelf you can see something shiny. You will definetely need a chair to reach it.'), nl
      ;
      write('Your plates and cups are still here. Luckily you didn''t break anything when trying to reach the top shelf.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(plant) :-
  i_am_at(Here), 
  (in(plant, Here) ->
    (unused(plant) ->
      write('It''s the big plant on your balcony, perhaps a fern. It''s leaves are wide and sprawling. It would be very easy to hide something here.'), nl
      ;
      write('The leaves look a bit ruffled now, after you pushed the aside. The plant doesn''t seem bothered'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(house_door) :-
  i_am_at(Here), 
  (in(house_door, Here) ->
    (unused(house_door) ->
      write('The door to your aparments is a solid ash grey color and the locks are pretty standard. You always make sure to lock it so you''ll need keys to look out into the corridor.'), nl
      ;
      write('The door is locked once again and there is not need for you to go outside right now.')
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(trashcan) :-
  i_am_at(Here), 
  (in(trashcan, Here) ->
    write('It''s a standard grey trashchan. The container itself isn''t heavy and you mostly throw out paper scraps here.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(table) :-
  i_am_at(Here), 
  (in(table, Here) ->
    (unused(table) ->
      write('This is were you usually eat your meals or work if you need more space. The table is made of a dark reddish wood and it''s big enough for at least 8 people to sit around it. After taking a closer look at the things laid out on the table you notice the HOUSE KEYS under the folded tablecloth.'), nl,
      retract(unused(table)), assert(at(house_keys, living_room))
      ;
      write('This is were you usually eat your meals or work if you need more space. The table is made of a dark reddish wood and it''s big enough for at least 8 people to sit around it.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(couch) :-
  i_am_at(Here), 
  (in(couch, Here) ->
    (unused(couch) ->
      write('This is your couch. It''s were you hang out during the day and read books. You hate napping on it. Right now the cushions and blanket are bunched up in a weird way, like somethign is underneath.'), nl
      ;
      write('This is your couch. It''s were you hang out during the day and read books. You hate napping on it. The cushions are back to laying flat after you pulled out Can #4 from underneath them.'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).
  
inspect(desk) :-
  i_am_at(Here), 
  (in(desk, Here) ->
    (unused(desk) ->
      write('You take a closer look at the pile of notes. At first nothing cathes your eye but then you notice something shiny behind a stack of library books. After pushing them aside you find Can #8!'), nl,
      retract(unfound(can8)),  increment_can_counter, assert(found(can8)), retract(unused(dGesk))
      ;
      write('You look at your notes again. The desk is even more of a mess now since you rearanged it. Can #8 used to be hidden behind some books here.')
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(string) :-
  i_am_at(Here), 
  (in(string, Here) ->
    write('It''s a think white string, probably cotton. A little bow is tied at the end.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(clothing_rack) :-
  i_am_at(Here), 
  (in(clothing_rack, Here) ->
    (unused(clothing_rack) ->
      write('You look closer at one of your favourite denim jackets. The fabric is pretty thick but despite that you can still see something bulging in its inner pocket. You reach in and find Can #9!'), nl,
      retract(unfound(can9)),  increment_can_counter, assert(found(can9)), retract(unused(desk))
      ;
      write('You inspect the clothing rack again. Your denim jacket now hangs flat on its hanger. Can #9 used to be in the inner pocket.')
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(paper_box) :-
  i_am_at(Here), 
  (in(paper_box, Here) ->
    (unused(paper_box) ->
      write('It''s a paper box completely covered in many many layers of packing tape. It''s definetely too sealed for you to just open it with your bare hands. A knife would surely help here.'), nl
      ;
      write('It''s the paper box, now torn open with your kitchen knife. Inside only a heap of white packing peanuts remains'), nl
    )
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(sink) :-
  i_am_at(Here), 
  (in(sink, Here) ->
    write('It''s the bathroom sink, perfectly clean and almost sparkling. So far there havent been any leaks.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).

inspect(toilet) :-
  i_am_at(Here), 
  (in(toilet, Here) ->
    write('It''s the toilet. It makes a funny noise when you flush it.'), nl
    ;
    write('Whatever you are looking for, it isn''t here'), nl
  ).
/*and every other setpiece */

/* inspect(_)  :- write('There''s nothing interesting about this.'), nl. */

/* The game starts in the kitchen */
  i_am_at(kitchen).

