# Elephant Savanna (Try #2)

In the game of [Congo](https://en.wikipedia.org/wiki/Congo_(chess_variant)),
there have been [complaints](https://www.chessvariants.com/index/listcomments.php?order=DESC&itemid=Congo) 
that the game is too drawish.

Indeed, the game inventors are open to Congo variants that are less
drawish.

That in mind, I have made a less drawish version of Congo which
has more active play, by using some of the same lessons learned
by the inventors of Chinese Chess:

* Repetition is a loss, not a draw

* Have fewer pawns so the armies can engage each other better

* Have the pawn move sideways on the other side of the river

And, in addition, a lesson learned by the inventors of ordinary Chess:

* Have the pawn promote to a powerful piece

In addition, the variant I use can be played with ordinary Chess pieces
and Chess board (by reducing the types of pieces from standard Congo) and 
the rules are easier to learn.

# The game

## The opening setup and terrain

```
EPCLCPE --###--
-Z#P#Z- --###--
PP###PP --###--
++~~~++ ++~~~++
pp###pp --###--
-z#p#z- --###--
epclcpe --###--
```

On the left is the opening setup. On the right is the game board without
any pieces (the terrain).

## The pieces

* `e` Elephante: This piece has a fairly complicated move: 1) It moves
  forward like a rook (or lance in Shogi) 2) It moves sideways one or
  two squares, and can leap two squares 3) It moves one square backwards
  like a rook.  It’s a wazir + sideways dabbaba + lance (forwards rook)
* `z` Zebra: Knight
* `c` Crocodile: Non-royal king + special Rook move: It can move like a 
  Rook towards the river (but not jumping over other pieces).  Once in
  the river, it can move like a rook left and right (again, without
  jumping).  It never drowns in the river.
* `l` Lion: Royal piece.  Moves like a King in chess, however: a) It
  can not move out of the 3x3 “palace” (C1-E3 for White, C5-E7 for Black)
  b) It can not directly face the other lion with no pieces between it 
  and the other lion without being captured.
* `p` mPawn: More powerful than the Chess pawn.  It can either move or
  capture straight forward or diagonally forward (like a combined Chess
  pawn and Berolina pawn).  Once it crosses the river, it can also move
  or capture sideways one square.  If it reaches the final rank, it gets
  promoted to the very powerful Megapawn.
* Megapawn: Knight + non-royal King + Alfil + Dabbaba.  It can slide or
  leap to any space within two squares.

## Terrain

* `~` The river (deep part).  If a non-Crocodile piece remains in the river 
  for more than one turn, it drowns and is removed from play.  The 
  Crocodile does not drown and has extra mobility in the river.
* `+` The river (island).  These squares are in the river, but since there 
  is an island present, pieces may stay in the square with no risk of 
  drowning.
* `#` Lion den.  Each Lion must stay in their 9-square den.
* `-` Empty square.

## Drowning in the river

The drowning rule is as follows:

* After a player has moved, any piece owned by the player (except the 
  crocodile), which was in the deep part of the river on the last turn 
  (i.e. on C4, D4, or E4) and is in the deep part of the river this
  turn is removed from play.  
* “wading” in the deep river does not keep a piece alive: A non-crocodile 
  piece can move in the deep river, but if they were in the deep river 
  last turn and are in the deep river this turn, they will be removed 
  from play after moving.
* A non-crocodile piece which was in the deep part of the river last
  turn may move to capture another piece in the deep river this turn, but 
  will be removed from play after capturing the piece.
* Any piece which was in the deep part of the river on the previous
  turn but is _not_ in the deep river this turn is still in play (as
  long as they do not get captured by an enemy piece).
* Moving to an island is the same as moving to any non-river square
  for all pieces except the crocodile.

## The opening

The first move not done on the D (middle) file has to be done on White’s
right hand side; i.e. one can not move a piece from or to White’s left
hand side (the A/B/C files) without having moved a piece on White’s
right hand side (the E/F/G files) first.  Once either player has moved
a piece on White’s right hand side, either player can move any piece
on the board.

For example, C-B2 can not be White’s opening move; White would have to
play the equivalent move C-F2 instead.  Once White plays C-F2, Black is
free to play C-B6 or any other legal move.  Likewise, if white opens D3,
Black may not play C-B6, since D3 is a move made on the center file,
but would have to play the equivalent C-F6 move instead.  Once Black
plays C-F6, White can play any legal move on either side of the board.

L-C2 is not a legal first move for White; L-E2 would have to be played
instead.

The reason for this rule is to prevent “mirror image” openings; any
given opening will have the same left-to-right orientation.

Note that the Zillions file does not enforce this rule; there
is a Lua script which will correct Zillions saved files where a
piece on White’s left hand side incorrectly moves before a piece on 
White’s right hand side.

## Notation

Notation is algebraic.  The square on the lower left corner is A1; the one
on the upper right hand corner is G7.  Here is an empty board with notation
and terrain:

```
7 -A7- -B7- #C7# #D7# #E7# -F7- -G7-
6 -A6- -B6- #C6# #D6# #E6# -F6- -G6-
5 -A5- -B5- #C5# #D5# #E5# -F5- -G5-
4 +A4+ +B4+ ~C4~ ~D4~ ~E4~ +F4+ +G4+
3 -A3- -B3- #C3# #D3# #E3# -F3- -G3-
2 -A2- -B2- #C2# #D2# #E2# -F2- -G2-
1 -A1- -B1- #C1# #D1# #E1# -F1- -G1-
   A    B    C    D    E    F    G
```

Movement is with standard Algebraic.  Piece names are:

* `P` Pawn
* `E` Elephante
* `Z` Zebra
* `C` Crocodile
* `L` Lion
* `MP` or `Q` Megapawn (“M” is a monkey in standard Congo; “G“ is a giraffe)
* `R` River.  While not a piece _per se_, the river can capture pieces

We allow `Q` to represent a megapawn so that ASCII boards can have the 
megapawn on them.  `Q` was chosen because, in normal Chess, pawns 
usually promote to a Queen, so `Q` represents a promoted pawn.

In order to make life easier for computers, if two pieces can move to a
given square, we specify the file (or row, if necessary), even if only
one move does not hang the Lion.  For example (upper case is Black,
lower case is white):

```
7 --##L--
6 --CC#--
5 --###--
4 ++~~~++
3 --###--
2 --c#c--
1 --##l--
  ABCDEFG
```

Here, C-D4 can be either C-CD4 or C-ED4.  Even though C-ED4 causes Black
to immediately take White’s Lion, it *is* a legal move in Congo, so we
have to specify the move as being C-CD4, which results in the following
position:

```
7 --##L--
6 --CC#--
5 --###--
4 ++~~~++
3 --###--
2 --#cc--
1 --##l--
  ABCDEFG
```

The piece does not have to be specified for pawn moves, unless more than
one pawn can move to a given square (more common in Congo than in Chess).
The `-` indicates a move in notation; `:` indicates a capture.  Placing
`#` after a move indicates that the opponent’s lion has been captured,
winning the game.  If a game is won because a previous position has
been repeated, the move will have a `/` after it, followed by the 
move number where the same position has already been seen.

River captures are indicated by, after the move made, `,R:` then the
square where a piece drowned in the river.

## Value of the pieces

Zillions of Games estimates the value of the pieces as follows:

* Pawn: 1.0
* Zebra: 1.5
* Elephant: 1.8
* Crocodile: 2.5
* Megapawn: 4.5

## A simple endgame position

```
7 --L##-- 
6 --###-- 
5 --###-- 
4 ++~~~++ 
3 --###-- 
2 --###-- 
1 --#l#-- 
  ABCDEFG
```

Here, because of the no repetition rule, the game is a win for White.

1. L-D2 L-C6
2. L-D1! L-C5

Black could not play L-C7 because that would repeat the initial position,
losing the game.

3. L-D2 L-D5 

Black could not play L-C6 because that would had repeated the position
at the end of move 1.

4. L:D5#

## Playing with a chess set

Elephante Savanna can be played with a standard Chess set:

* Use rooks for the Elephantes
* Use knights for the Zebras
* Use bishops for the Crocodiles
* Use a king for the Lion
* Use pawns for the mPawns
* Use queens for Megapawns

One can either play on a 7x7 subsection of a standard Chess board,
keeping a note of terrain squares either mentally or with checkers, or 
print out a board to play on, using either smaller pieces, by using a 
large sheet printer readily available at office printing stores, or 
even using a custom printed vinyl board.

## Game play

Elephante Savanna is very tactical; the pieces very quickly engage with
each other and games start off with pawn battles on the wings of the 
board.  There are many traps in the opening.

Since Elephante Savanna has a strong “no repetition” rule, draws are
impossible and each game will have a winner.

## Depth of Elephante Savanna

Because of the smaller board, while quite deep, Elephante Savanna
probably is not as deep as regular Chess.  A 9x9 or 11x11 Elephante
Savanna variant (which restores the Giraffe then Monkey) would probably be
as deep or possibly deeper than regular Chess.

Here, depth is defined as follows:

* Take two players.  Player #2 is a little more skilled than player #1. 
  Indeed, he can defeat player #1 in two out of three games they play
  together.  This corresponds to have 100 score difference in the Elo
  rating system which Chess has traditionally used.
* Likewise, when player #2 plays player #3, player #2 loses two out of
  three games against player #3.
* We continue this two thirds win/lose ratio with player #3 vs. player #4,
  player #4 vs. player #5, and so on.
* Eventually, the players will be strong enough that all games are a forced
  win (probably for White, but there’s a possibility that Elephante
  Savanna is a _zugzwang_ where Black always wins; Black seems to win more
  in Zillions-vs-Zillions games, but Zillions really isn’t strong enough
  to determine how the game would be played at Grandmaster level).
* The number of levels of players before pefect play is the depth of the
  game.
* In regular Chess, the difference between a player which makes random
  legal moves (player #1) and the strongest computers is about 3000 Elo
  points, or, to use the scale here, a near-perfect player would be 
  player #31 in this scale, giving Chess a depth of around 30.
* The depth of Elephante Savanna is unknown, but may be in the range
  of 20-25 (i.e. a random player would have an Elo of 500 and a computer
  playing perfectly would have a Elo between 2500 and 3000).

# Zillions file notes

Out of respect for the congo.zip copyright, the .zip is here unchanged.
In order to make the Zillions file which can play this proposed
Congo variant, one will need to have a *NIX like system with the
`unzip` and `patch` commands to make the actual Zillions file.

The islands are present but invisible on the map.  There is also
the original Congo .zrf file, as well as a file with all of the
variants but no islands in the river.

The Zillions file has, in addition to the above pieces, the following
pieces:

* Monkey.  Moves without capture like a non-royal king, captures by jumping 
  over other pieces.
* Giraffe.  Moves but does not capture like a non-royal king (one square in 
  all eight directions), moves or captures like Alfil + Dabbaba (leaping 
  two squares in a straight line all eight directions).
* Pawn.  Moves like Chess pawn + Berolina pawn.  Once across river, can
  make non-jumping non-capturing move one or two squares backwards.  
  Promotes on seventh rank to Superpawn.
* Superpawn.  Moves like Pawn, but can also move or capture one square
  sideways.  It may do a non-capture, non-jumping retreat one or two
  squares straight or diagonally backwards.
* Elephant (with an e at the end).  Wazir + Dabbaba.  Moves one or
  two squares like a rook, and can leap two squares.

The Pawn has the same image as the mPawn.  The Superpawn has the same image
as the Megapawn.  The Elephante has the same image as the Elephant.  It
is expected that one will not have Pawns and mPawns on the same board, nor
have Elephants and Elephantes on the same board.

# Results

Initial Zillions testing shows almost no draws.  Because of the 
no-repetition rule, even a Lion-vs-Lion endgame will have a decisive
result (since one player will be forced to either repeat a previous
position, or put their Lion in front of the other Lion).
