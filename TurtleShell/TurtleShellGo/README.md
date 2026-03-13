What would it be like to play Go on a Turtle Shell grid?

The best discussion about Go on other boards is probably
on [this page](https://archive.ph/20260206013421/https://jpneto.github.io/world_abstract_games/boards.htm). 

To summarize that page, a Go variant where we have either three or
four liberties per square is more tactical than normal square grid
Go, while a variant with five liberties per point is more strategic
then normal Go.  

To play Go on a Turtle Shell board so each connection has three or
four liberties, play in the trangles and squares.  To play Go on a
Turtle Shell board so each connection has five liberties, play on the
vertices (the corners of each square/triangle).

As it turns out, for grids large enough to make interesting Go
variants, a given Turtle Shell grid has a lot more squares/triangles
than vertices.  That in mind, different grids should be used for
a game played inside the cells versus a game played at the vertices.

Let’s look at the number of squares in the three main Go variants:

```
Size    Number of vertices
9x9     81
13x13   169
19x19   361
```

And let’s compare that to the girds here in this directory:

```
Size    Cells   Vertices
7x7     106     88
9x9     186     150
13x13   386     294
15x15   498     368
17x13   504     378
```

Point being 7x7 is good for a quick game, rougly equivalent to 9x9 Go, 
either as a tactical game in the cells (triangles and squares) or
a strategic game on the vertices.

9x9 is good for something roughly equivalent to 13x13 Go, again as a 
tactical game in the cells or a strategic game on the vertices.

13x13 is roughly equivalent to 19x19 Go when played as a tactical game
in the cells.  If played on the vertices, it’s roughly equivalent to
17x17 Go; this is the size used in Tibetan Go, which has 289 vertices, 
compared to the 294 vertices in this grid.

Both 15x15 and 17x13 make good games, roughly equivalent to full 
sized Go, when played as a strategic game on the vertices.  15x15 has
different edge dynamics than the 9x9 or 13x13 board, so one can also
play the 17x13 board to get the same edges as the 9x9 and 13x13 
boards.
