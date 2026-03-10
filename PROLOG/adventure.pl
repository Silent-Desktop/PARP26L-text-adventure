/* this is a text adventure for PARP 26L in prolog by Żą */

:- dynamic i_am_at/1, at/2, holding/1, unfound/1, found/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

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
setpiece(taped_paper_box).

/* List of initial locations of items: */
at(knife, kitchen).
at(chair, living_room).
at(house_keys, bed_room).
at(boots, hall).

/* List of locations of the setpieces: */
in(dishwasher, kitchen).
in(cupboard, kitchen).
in(trashcan, kitchen).
in(table, living_room).
in(couch, living_room).
in(desk, bedroom).
in(bed, bedroom).
in(plant, balcony).
in(railing, balcony).
in(string, balcony).
in(house_door, hall).
in(clothing_rack, closet).
in(taped_paper_box, closet).

/* List of paths between locations: */
path(kitchen, living_room).
path(living_room, kitchen).
path(living_room, balcony).
path(balcony, living_room).
path(living_room, hall).
path(hall, bathroom).
path(bathroom, hall).
path(hall, bedroom).
path(bathroom, hall).
/* path(hall, corridor). #This is a path that will be availabke after opening the house_door with house_keys */
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


/* This is a counter of action taken during the adventure:
TODO */

/* This is a counter of trophies found during the adventure:
TODO */

/* Standard command and ways of interracting with the game: */
  /* These rules describe how to pick up an object. */
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
            describe(X), nl,
            fail.

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
          write('interract.         -- NOT IMPLEMENTED YET.'), nl,
          write('inspect.           -- NOT IMPLEMENTED YET.'), nl,
          write('inventory.         -- to check what items you have.'), nl,
          write('inventory.         -- to check which trophies you''ve already found.'), nl,
          write('instructions.      -- to see this message again.'), nl,
          write('halt.              -- to end the game and quit.'), nl,
          nl.


/* This rule prints out instructions and tells where you are at the beginning of the game. */

start :-
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

describe(can1) :- write('TODO'), nl.
describe(can2) :- write('TODO'), nl.
describe(can3) :- write('TODO'), nl.
describe(can4) :- write('Can #4, its pink in color and probably strawberry flavored.'), nl.
describe(can5) :- write('TODO'), nl.
describe(can6) :- write('TODO'), nl.
describe(can7) :- write('TODO'), nl.
describe(can8) :- write('TODO'), nl.
describe(can9) :- write('TODO'), nl.
describe(can10) :- write('TODO'), nl.
describe(can11) :- write('TODO'), nl.
describe(can12) :- write('TODO'), nl.

/* These rules describe text upon noticing an item. There are separate texts for when an item is spotted in each location
This might a common over-ambitious blunder.*/
  /* items */
    /*kitchen*/
      notice(knife, kitchen)         :- write('There is a KNIFE on the countertop near the sink. It looks sharp.'), nl.
      notice(chair, kitchen)         :- write('You left the CHAIR here, not sure why but maybe you could stand on it.'), nl.
      notice(house_keys, kitchen)         :- write('You left the HOUSE KEYS on the countertop. The cabinets aren''t even locked so any keys are pointless here but alright.'), nl.
      notice(boots, kitchen)         :- write('You left the boots here. And now theres mud on the floor. In the kitchen. Great.'), nl.
    /*living_room*/
      notice(knife, living_room)         :- write('You left the KNIFE on the table. There is no use for it here right now but maybe you''ll have dinner soon.'), nl.
      notice(chair, living_room)         :- write('There is a CHAIR here, just next to the table. Usually you''d just sit on it but sometimes you use it to reach higher places.'), nl.
      notice(house_keys, living_room)         :- write('You left the HOUSE KEYS on the table. Usually you leave them here anyway, easier to find later.'), nl.
      notice(boots, living_room)         :- write('You left the BOOTS on the floor, a safe distance from the couch. They''re still muddy.'), nl.
    /*balcony*/
      notice(knife, balcony)         :- write('You left the KNIFE here. You can''t really do anything with it here.'), nl.
      notice(chair, balcony)         :- write('You left the CHAIR here. You could sit and enjoy the morning sun, just don'' stand on it here. That can''t be safe near the edge.'), nl.
      notice(house_keys, balcony)    :- write('You left the HOUSE KEYS here, behind the potten PLANT in the corner. A safe spot for sure.'), nl.
      notice(boots, balcony)         :- write('You left the BOOTS on the dirty tiled floor. Maybe the mud on them will dry out in the sun.'), nl.
    /*hall*/
      notice(knife, hall)            :- write('TODO'), nl.
      notice(chair, hall)            :- write('TODO'), nl.
      notice(house_keys, hall)       :- write('TODO'), nl.
      notice(boots, hall)            :- write('There is a pair of your heavy duty BOOTS here. They''re still covered with wet mud from outside.'), nl.
    /*bedroom*/
      notice(knife, bedroom)         :- write('TODO'), nl.
      notice(chair, bedroom)         :- write('TODO'), nl.
      notice(house_keys, bedroom)    :- write('TODO'), nl.
      notice(boots, bedroom)         :- write('TODO'), nl.
    /*closet*/
      notice(key, closet)            :- write('TODO'), nl.
    /*bathroom*/
      notice(knife, bathroom)        :- write('TODO'), nl.
      notice(chair, bathroom)        :- write('TODO'), nl.
      notice(house_keys, batchroom)  :- write('TODO'), nl.
      notice(boots, bathroom)        :- write('TODO'), nl.

/* set pieces */
notice(dishwasher, kitchen)   :- write('There is a DISHWASHER here, a true lifesaver since you hate washing the dishes by hand. Right now there is a cycle going so you can''t open it.'), nl.
/*notice(dishwasher, actiavted) - actiavted is a cirtual "location for items or things that will need a different description later on. That might get reworked*/
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
notice(taped_paper_box, closet)   :- write('On the floor there is a small PAPER BOX completely covered in packing tape. You''ll need something sharp to open it.'), nl.
/*notice (taped_paper_box, activated) after its been opened*/

/* These rules describe text upon picking up an item. */
picked_up(knife)      :- write('You pick up the KNIFE. The handle is solid black and cold to the touch.'), nl.
picked_up(chair)      :- write('You somehow manage to pick up the CHAIR. It''s a bit weird to hold but you''ev done this before.'), nl.
picked_up(house_keys)      :- write('You pick up the HOUSE_KEYS, and they fit neatly in your back pocket.'), nl.
picked_up(boots)      :- write('You pick up the BOOTS and get some mud on your hands. Yuck.'), nl.

/* These rules describe text upon dropping an item. */
dropped(knife)      :- write('You leave the KNIFE here, you dont''t want to accidentally stab your self with it later.'), nl.
dropped(chair)      :- write('You put down the CHAIR. It''s a bit useless without the table next to it but at least you could stand on it.'), nl.
dropped(house_keys)      :- write('You take the HOUSE KEYS out of your pocket and leave them here. No point carrying a bundle of keys without a reason.'), nl.
dropped(boots)      :- write('You leave the dirty BOOTS here. The mud is on your clothes now as well. Disgusting.'), nl.

/* These rules describe interractions with setpieces */

interract(couch)    :- 
  write('You decide to take a break and sit down on the COUCH. The cushions are soft but there is something hard poking you in the hip. You reach under the blanke and find Can #4!'), nl,
  retract(unfound(can4)), assert(found(can4)).
  % fail.

/* The game starts in the kitchen */
  i_am_at(kitchen).

