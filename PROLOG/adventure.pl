/* this is a text adventure for PARP 26L in prolog by Żą */

:- dynamic i_am_at/1, at/2, holding/1.
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

  /* These rules set up a loop to mention all the items in the current location.*/

    notice_items_at(Place) :-
            at(X, Place),
            notice(X, Place), nl,
            fail.

    notice_items_at(_).

  /* These rules set up a loop to mention all set pieces in the current location.*/

    notice_setpieces_in(Place) :-
            in(Y, Place),
            notice(Y, Place), nl,
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
          write('instructions.      -- to see this message again.'), nl,
          write('halt.              -- to end the game and quit.'), nl,
          nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the locations. */

describe(kitchen)      :- write('TODO'), nl.
describe(living_room)      :- write('TODO'), nl.
describe(balcony)      :- write('TODO'), nl.
describe(hall)      :- write('TODO'), nl.
describe(bedroom)      :- write('TODO'), nl.
describe(closet)      :- write('TODO'), nl.
describe(bathroom)      :- write('TODO'), nl.

/* These rules describe text upon noticing an item. There are separate texts for when an item is spotted in each location
This might a common over-ambitious blunder.*/
  /* items */
    /*kitchen*/
      notice(knife, kitchen)         :- write('TODO'), nl.
      notice(chair, kitchen)         :- write('TODO'), nl.
      notice(house_keys, kitchen)         :- write('TODO'), nl.
      notice(boots, kitchen)         :- write('TODO'), nl.
    /*living_room*/
      notice(knife, living_room)         :- write('TODO'), nl.
      notice(chair, living_room)         :- write('TODO'), nl.
      notice(house_keys, living_room)         :- write('TODO'), nl.
      notice(boots, living_room)         :- write('TODO'), nl.
    /*balcony*/
      notice(knife, balcony)         :- write('TODO'), nl.
      notice(chair, balcony)         :- write('TODO'), nl.
      notice(house_keys, balcony)    :- write('TODO'), nl.
      notice(boots, balcony)         :- write('TODO'), nl.
    /*hall*/
      notice(knife, hall)            :- write('TODO'), nl.
      notice(chair, hall)            :- write('TODO'), nl.
      notice(house_keys, hall)       :- write('TODO'), nl.
      notice(boots, hall)            :- write('TODO'), nl.
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
notice(dishwasher, kitchen)   :- write('TODO'), nl.
notice(cupboard, kitchen)   :- write('TODO'), nl.
notice(trashcan, kitchen)   :- write('TODO'), nl.
notice(table, living_room)   :- write('TODO'), nl.
notice(couch, living_room)   :- write('TODO'), nl.
notice(desk, bedroom)   :- write('TODO'), nl.
notice(bed, bedroom)   :- write('TODO'), nl.
notice(plant, balcony)   :- write('TODO'), nl.
notice(railing, balcony)   :- write('TODO'), nl.
notice(string, balcony)   :- write('TODO'), nl.
notice(house_door, hall)   :- write('TODO'), nl.
notice(clothing_rack, closet)   :- write('TODO'), nl.
notice(taped_paper_box, closet)   :- write('TODO'), nl.


/* These rules describe text upon picking up an item. */
picked_up(knife)      :- write('TODO'), nl.
picked_up(chair)      :- write('TODO'), nl.
picked_up(chair)      :- write('TODO'), nl.
picked_up(boots)      :- write('TODO'), nl.

/* These rules describe text upon dropping an item. */
dropped(knife)      :- write('TODO'), nl.
dropped(chair)      :- write('TODO'), nl.
dropped(house_keys)      :- write('TODO'), nl.
dropped(boots)      :- write('TODO'), nl.

/* The game starts in the kitchen */
  i_am_at(kitchen).

