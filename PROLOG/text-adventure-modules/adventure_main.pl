/* this is a text adventure for PARP 26L*/
:- use_module(adv_describe, [describe/1]).
:- use_module(adv_inspects, [inspect/1]).
:- use_module(adv_interacts, [interact/1]).
:- use_module(adv_notice, [notice/2]).

:- use_module(library(ansi_term)).

:- dynamic i_am_at/1, at/2, in/2, holding/1, unfound/1, found/1, unused/1, running/1, action_counter/1, can_counter/1.
:- retractall(at(_, _)), retractall(in(_, _)), retractall(i_am_at(_)), retractall(action_counter(_)), retractall(can_counter(_)), assert(action_counter(0)), assert(can_counter(0)).

/* List of locations in this adventure: */
location(kitchen).
location(livingroom).
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
unused(string).
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
at(chair, livingroom).
/*at(house_keys, livingroom).*/
/*this becomes true after inspecting the table in the dining room.*/
at(boots, hall).
at(towel, bathroom).

/* this is unique only to can5 as it need to be noticed when enterring the room*/
at(can5, livingroom).

/* List of locations of the setpieces: */
in(dishwasher, kitchen).
in(cupboard, kitchen).
in(trashcan, kitchen).
in(fridge, kitchen).
in(table, livingroom).
in(couch, livingroom).
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
/* possible one way path */
path(kitchen, livingroom).
path(livingroom, kitchen).
path(livingroom, balcony).
path(balcony, livingroom).
path(livingroom, hall).
path(hall, livingroom).
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

  /* This is a debug tool meant to speed up testing of all the areas*/
  teleport(There) :-
    i_am_at(Here),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    !, look.
  teleport(_) :-
    write('Invalid location').

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
    inventory.

    found :-
            found(X),
            describe(X),
            fail.
    found.

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
            write('You can see that from here you can reach the '), ansi_format([bold, fg(yellow)], Destination, []), nl,
            fail.
    notice_destination_from(_).

  /* This rule just writes out game instructions. */

  instructions :-
          nl,
          write('Enter commands using standard Prolog syntax.'), nl,
          write('Available commands are:'), nl,
          write('start.             -- to start the game.'), nl,
          write('go(Place).         -- to go to that Place.'), nl,
          write('take(Object).      -- to pick up an object.'), nl,
          write('drop(Object).      -- to put down an object.'), nl,
          write('look.              -- to look around you again.'), nl,
          write('interact(Item).    -- to interact with something in the scene.'), nl,
          write('inspect(Item).     -- to take a closer look at something.'), nl,
          write('inventory.         -- to check what items you have.'), nl,
          write('found.             -- to check which trophies you''ve already found.'), nl,
          write('instructions.      -- to see this message again.'), nl,
          write('halt.              -- to end the game and quit.'), nl,
          write('When something is '), ansi_format([bold, fg(blue)], 'blue', []), write(' then it''s an item and it can be picked up.'), nl,
          write('When something is '), ansi_format([bold, fg(green)], 'green', []), write(' then it''s a setpiece and can be interracted or inspected but not picked up.'), nl,
          write('When something is '), ansi_format([bold, fg(yellow)], 'yellow', []), write(' then it''s a location.'), nl,
          ansi_format([bold, fg(magenta)], 'purple', []), write(' means you found one of the hidden items. They are automatically checked as found and do not enter your inventory.'), nl,
          write('The goal of the game is to find as many '), ansi_format([bold, fg(magenta)], 'cans', []), write(' as possible hidden around the house. When you think you''re done return to the '), ansi_format([bold, fg(yellow)], 'kitchen', []), write(' and interact with the '), ansi_format([bold, fg(green)], 'fridge', []), write(' for the final score.'), nl,
          write('---------------------------------------------------------'), nl, !.


/* This rule prints out instructions and tells where you are at the beginning of the game. */

start :-
        write('You are in your kitchen staring into your fridge. Lately you''ve bought exactly 12 cans of your favourite energy drink to last you through the exam season. You had some friends over last night and they must have decided on a prank to hide all of them from you, because the fridge is nearly empty without a single perfectly chilled can. They''re not in the fridge but your friends wouldn''t steal so they must be around the house. Better get to searching!'), nl,
        instructions,
        look.

i_am_at(kitchen).