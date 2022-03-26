Since 1994, I have wanted to create a playable Chess variant using
this particular tessellation, a tiling that the Wikpedia calls a
[33344-33434 tiling](https://en.wikipedia.org/wiki/33344-33434_tiling).

When I was trying to come up with a Chess variant with this tiling back
then, my then roommate said my board looked like a “Turtle Shell”, which
is why this variant is called “Turtle Shell Chess”.

It took me 28 years, but I have *finally* formalized the rules for “Turtle
Shell Chess”.

# The board

This Chess variant is played on a board using a tiling which combines
squares and triangles.  Pieces are placed and moved inside of the
squares and triangles.  The places where pieces may go are called
*cells*; there are 64 cells in Turtle Shell Chess.

![Turtle shell board](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell.png)

# Naming the cells

A modified form of algebraic notation is using to give each cell on
the board a unique designation, as follows:

![Turtle shell board with notation](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-algebraic.png)

# Rows

The board has 10 rows in it.  Because of the nature of the tiling, some
cells are in more than one row.  Rooks (see below) can move left and
right along rows.

![Turtle shell rows](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-sideMovePaths.png)

# Files

The board has six files.  As with rows, some cells are in more than one 
file.  Rooks can move up and down files, and pawns can move as well as
capture one square towards the opponent’s endzone on a given file.

![Turtle shell files](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-lancePaths.png)

# Promotion zones

Any pawn placed in the opponent’s promotion zone may be promoted to
a rook.  A pawn not in the opponent’s endzone is not required to promote;
promotion is mandatory once in the endzone.  There is no limit on the
number of promoted pawns allowed on the board.

In this image, white pawns may promote in the yellow cells, and black
pawns may promote in the red cells.

![Turtle shell promotion zone](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-promotionZone.png)

# End zones

Any pawn placed in the opponent’s end zone is *required* to promote to
a rook.  If a player is able to place his king in the opponent’s end 
zone, they immediately win the game.

In this image, white pawns must promote on the yellow cells, and a
white king on any of the yellow cells is victory for white.  Likewise,
black pawns must promote on the red cells, and a black king on any
of the red cells is victory for black.

![Turtle shell end zone](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-endzone.png)

# Movement and capture

Each piece is Turtle shell chess has a given movement to it.  If a piece
moves to a square occupied by an opponent’s piece, the opponent’s piece
in question is removed from the board; this is called *capture*.

# The rook

A rook may move any number of cells along a row or file until it is
blocked by a piece of the same color.  If there is an enemy piece on the
rook’s path, the rook may capture that piece, but the rook may not
continue moving after capturing.

![Turtle shell rook](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-rook.png)

# The guard

The guard may move or capture to any cell it shares an edge with.
If a cell is a triangle, a guard may move or capture to any of the up
to three adjacent cells.  If the cell is a square, a guard may move or
capture to any of the up to four adjacent cells.

![Turtle shell guard](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-guard.png)

# The knight

A knight in Turtle Shell Chess may move or capture to any cell that it
shares a corner with, as long as the cell in question does *not* share
an edge with the cell the knight is in.

A knight, if in a triangle cell, may move to up to six different cells.
If in a square cell, a kngith might be able to move to up to eight different
cells.

![Turtle shell knight moves 1](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-knight1.png)

![Turtle shell knight moves 2](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-knight2.png)

# The pawn

A pawn has the same move and capture: It may move one square forward
towards the opponent’s endzone along a file.  If a pawn ends its move in
the opponent’s promotion zone, it may, at the player’s discretion,
promote in to a rook immediately after ending its move in the promotion
zone.  If a pawn ends its move in the opponent’s end zone, it *must* 
promote in to a rook immediately after ending its move.

For example, if the white player moves a pawn from C5 to C6, they may
make the pawn on C6 a rook on the same turn the pawn moved from C5 to C6.

A pawn must have moved on the same turn when it is promoted.

A white pawn on the E2 triangle cell may move or capture to either the
D3 cell or the E3 cell.  A black pawn on the E7 triangle cell may move
or capture to either the D6 cell or E6 cell.  Otherwise, each pawn may
only move to the cell immediately in front of it on the same file.

![Turtle shell pawn](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-pawn.png)

# The king

A king moves as a guard.  If the opponent threatens to capture the king,
the king is said to be *in check* and must make a move to stop the
threat of capture.  If it is not possible to stop the check (by either
capturing the piece giving check, interposing a piece between a rook
giving check and the king, or moving the king to a square not under
threat of opponent capture), the king is under *checkmate* and the
player giving checkmate has won the game.

If a king ends its turn on a square in the opponent’s end zone without
being in check, the game is immediately won for the person who moved
their king across the board.

# Repetition of move

It is not allowed to make a move which recreates a position previously
played in this game.  This is called, in Go, a “Ko” rule.  When playing
with a computer, the computer would enforce this rule.  When playing on
a physical board, the rule would be more subjectively enforced: Someone
appearing to repeat the same move would be asked to make another move
or forfeit the game.

# Objective

The object of the game is to checkmate the opponent’s king, or to place
one’s own king on a square in the opponent’s end zone without the king
being in check.

# Setup

In the initial setup, each side has seven pawns, two rooks, two knights,
two guards, and one king.

![Turtle shell setup](https://raw.githubusercontent.com/samboy/ChessVariantResearch/main/TurtleShell/TurtleShell-setup.png)

# Notes

Some notes about this game:

* While a number of hexagonal chess variants have been invented, chess
  variants using other tilings are relatively rare.  One such variant
  is Rhombic chess by Tony Paletta.  Other variants are the
  variants by Dekle (Triangular chess, Tri-chess, Masonic chess,
  Trishogi, Masonic shogi, etc.)
* The knight is more like the ferz piece, but it is called the “Knight”
  here because that is a more familiar name, because “fers” means
  “queen” in Russian, and because the piece has more mobility with
  this tiling (6-8 squares instead of the four a ferz has on a square 
  board).
* I have, in the last 28 years of speculating about this variant,
  considered pieces with circular moves.  One issue with circular 
  moves is that chess doesn’t have circular moves, so they might not
  be very intuitive for chess players, and because they can make the 
  C3, C6, F3, and F6 cells too powerful.
* It’s possible to play Go with this board: One Go variant would be
  played inside the cells, where each piece would have three or four
  liberties (unless on the edge or next to another piece), depedning 
  on whether the cell was a square or triangle.  It would also be 
  possible to play Go on the corners of the cells; here each piece 
  would normally have five liberties.  In both cases, a larger board 
  would be closer to 19x19 Go.
* There are 360 possible starting positions if we shuffle the pieces
  along the back row.
* Playing with Shogi style drops is also a rule I considered while
  inventing this variant.
* Other possible pieces include: a piece which moves forwards or backwards
  like a rook, but otherwise like a guard, akin to Chu Shogi’s shugyo 
  (vertical mover); a piece which combines a rook and knight (a cardinal
  or marshall, if you will); and a piece which combines the guard and 
  knight.
* A combination of the Ko rule and the end zone win rule eliminates
  draws.  Because of the geometry of the board, one king can not block
  the other king from reaching the end zone (there is no opposition
  in Turtle Shell Chess).

# Copyright

I dedicate the rules of this game and all graphics and code illustrating
this game to the public domain.

