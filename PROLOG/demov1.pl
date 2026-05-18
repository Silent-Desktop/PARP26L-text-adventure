/* This is DEMO v0.1 for PARP by Żą. */
/* this is a demo meant to test mechanics and solutions to some item usages and is not a part of the final adventure game */

:- dynamic i_am_at/1, at/2, holding/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

/* List of locations in this demo:
  - Your room
  - Courtyard
  - Garden
  - Locked Gate
*/

i_am_at(your_room).

/* List of possible passages between locations 
All paths are assumed to be oneway and must be explicitly declared if they
are meant to go both ways*/
path(your_room, courtyard).
path(courtyard, garden).
path(garden, courtyard).
path(courtyard, locked_gate).
path(locked_gate, courtyard).

/* List of items and their initial (upon game start) locations.
Items can be picked up, dropped somewhere else and potentially used */
at(lantern, your_room).
at(key, garden).
at(shears, garden).

/* List of set pieces and where they are located
Set pieces cannot be picked up or moved but can be interracted with*/
in(nighstand, your_room).
in(thick_hedge, garden).
in(bench, garden).
in(padlock, locked_gate).

/*List of places or items or set pieces locked or requiring interraction with a different item*/
locked(padlock, key).

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

/* This rule describes interacting with items and set pieces */

% interract :-
%           i_am_at(Place).
          

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


/* This rule tells how to die. */

die :-
        finish.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.


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
        write('inventory.         -- to check what items you have.'), nl,
        write('instructions.      -- to see this message again.'), nl,
        write('halt.              -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the various rooms. */

describe(your_room)      :- write('You are in your room.'), nl.
describe(courtyard)      :- write('You are out in the courtyard, completely alone.'), nl.
describe(garden)         :- write('You are in the garden, amongst the hedges and flower beds.'), nl.
describe(locked_gate)    :- write('You reach a locked gate made of thick wooden boards.'), nl.

/* These rules describe text upon noticing an item. There are separate texts for when an item is spotted in each location
This might a common over-ambitious blunder.*/
  /* items */
    /*your room*/
      notice(key, your_room)         :- write('You left the key here, lying on the nighstand.'), nl.
      notice(lantern, your_room)     :- write('There is a lantern on the nighstand.'), nl.
      notice(shears, your_room)      :- write('You left the shears here, lying on the floor by the bed.'), nl.
    /*garden*/
      notice(key, garden)            :- write('There is a key here, lying in the tall uncut grass.'), nl.
      notice(lantern, garden)        :- write('You left the lantern here, standing on a small patch of dried grass.'), nl.
      notice(shears, garden)         :- write('There are shears here, propped up against a bench.'), nl.
    /*courtyard*/
      notice(key, courtyard)         :- write('You left the key here, lying on the stone pavement.'), nl.
      notice(lantern, courtyard)     :- write('You left the lantern here, standing in the middle of the courtyard.'), nl.
      notice(shears, courtyard)      :- write('You left the shears here, lying on the stone ground.'), nl.
    /*locked_gate*/
      notice(key, locked_gate)       :- write('You left the key here, lying just by the gate.'), nl.
      notice(lantern, locked_gate)   :- write('You left the lantern here, now its hanging from a small hook on the wall'), nl.
      notice(shears, locked_gate)    :- write('You left the shears here, propped up against the gate'), nl.

/* set pieces */
notice(nighstand, your_room)   :- write('Next to the bed there is a simple nighstand with no drawers.').
notice(thick_hedge, garden)    :- write('At the edge of the garden you can see a very thick overgrown hedge.').
notice(bench, garden)          :- write('There is a bench here, it looks sturdy and well made.').
notice(padlock, locked_gate)   :- write('There is a heavy tarnished padlock keeping the gate shut.').


/* These rules describe text upon picking up an item. */
picked_up(key)      :- write('You take the key. Its heavy and cold in your palm and barely fits in any of your pockets.'), nl.
picked_up(lantern)  :- write('You pick up the lantern. There is no candle inside and the glass panes are smoky, it seems well used.'), nl.
picked_up(shears)   :- write('You pick up the shears. They are heavy and you need to use both hands to use them. The blades are sharp, almost unused'), nl.

/* These rules describe text upon dropping an item. */
dropped(key)      :- write('You take the key out of your largest pocket and leave it here.'), nl.
dropped(lantern)  :- write('You leave the lantern here.'), nl.
dropped(shears)   :- write('You leave the shears here, they were to big and heavy anyway.'), nl.