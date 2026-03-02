This is a series of potential games which can be played on a particular
tessellation which I call “Turtle Shell”

TurtleShell64a has a fully developed Chess variant, complete with an
implementation for the classic Chess Variant Zillions of Games engine.

TurtleShell80a has the beginnings of another Chess variant, using a
slightly larger board.

TurtleShellGo has two boards which can be used for Go.  The 13x13 board
is for playing inside of the squares and triangles (it has 386 squares
and triangles, which is a little more than the 361 intersections 19x19 
Go uses; it also has 294 intersections which is more complex than 13x13 
Go [169] but less complex than 19x19 go).  The 15x15 board is for playing 
on the vertices (intersections) between the squares and triangles (the 
15x15 board has 368 vertices, which is slightly more complex than 19x19 
Go’s 361 vertices; however it has 498 squares and triangles, which is far 
more complex than even 19x19 Go).

turtleShellGrid.lua is a script for making SVG boards; it currently won’t
make the 64-board used by TurtleShell64a, but will make the 80-square board
used by TurtleShell80a, as well as the two Go boards in TurtleShellGo.

The folder various-boards has a large number of possible boards to use 
for verious kinds of games that could be played on this tessellation.
