DONKEYSLUG
==========
*Donkeylube Software Studios*

Donkeyslug should be some kind of a rougelike game, a dungeon creeper. The player should die easily, and death is permanent,
but I would like some kind of "leftovers" from previous characters, making the game easier over time. The world
should be autogenerated, maybe with additional support for static, hand-made levels. It should stay the same between
characters, though, making new and more "permabuffed" characters able to reach deeper into the levels. I would also like
to make some kind of garden or something that the player could tend to - maybe a place to grow herbs for potions...

What I am really trying to do is to get into Test Driven Development, and apply my freshly accumulated knowledge
procured from the various literature I've been reading. :)


CURRENT GOAL(S)
---------------
* Items
* Make Creatures
  - carry items
  - wear armor
* Automatic map generation


FUTURE
------
* System for importing Items and Creatures, taking it out of the code.
  - Maybe JSON is suited for this?
* Monster AI
  - movement (run away, search for player, patrol, sleep, ...)
  - aggro
  - call swarm
  - attack enemy monsters
* Leveling
* Some kind of view that makes the game playable
* Ranged combat



COMPLETED
---------
Currently the game supports (extremely simple) parsing of acii-maps, where you can place things like Items, Players and
Creatures. Creatures can move around (not by themselves, though), and they can fight each other with a preliminary
battle algorithm.
