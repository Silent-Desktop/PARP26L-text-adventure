/* These rules describe the locations and trophies. */
:- module(adv_describe, [describe/1]).


describe(kitchen):- 
  write('This is the '),
  ansi_format([bold, fg(yellow)], 'kitchen', []),
  write('. The countertops are clean and there are no dirty dishes in the sink. Clearly you''ve been busy or just haven''t eaten in a long time.'), !, nl.

describe(livingroom):-
  write('This is the '),
  ansi_format([bold, fg(yellow)], 'livingroom', []),
  write(' where you spend your free time. You never take naps here though.'), !, nl.

describe(balcony):-
  write('This is the '),
  ansi_format([bold, fg(yellow)], 'balcony', []),
  write('. From here you have a nice outlook onto the yard behind your building.'), !, nl.

describe(hall):-
  write('This is the '),
  ansi_format([bold, fg(yellow)], 'hall', []),
  write(' where you keep your coats and shoes. There''s some unvacuumed sand on the tiled floor.'), !, nl.

describe(bedroom):-
  write('This is the '),
  ansi_format([bold, fg(yellow)], 'bedroom', []),
  write(' where you spend most of your time. The blinds are shut but there is a small desk lamp illuminating the room.'), !, nl.

describe(closet):-
  write('This is the '),
  ansi_format([bold, fg(yellow)], 'closet', []),
  write(' where you keep most of your daily clothes. There are dust speckles in the air and you can smell your laundry detergent faintly.'), !, nl.

describe(bathroom):-
  write('This is the '),
  ansi_format([bold, fg(yellow)], 'bathroom', []),
  write(' and it looks scrubbed clean. You must have been very bored lately.'), !, nl.

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