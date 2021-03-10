In the game of [Congo](https://en.wikipedia.org/wiki/Congo_(chess_variant)),
there have been [complaints](https://www.chessvariants.com/index/listcomments.php?order=DESC&itemid=Congo) 
that the game is too drawish.

Indeed, the game inventors are open to Congo variants that are less
drawish.

That in mind, I have made a less drawish version of Congo which
has less passive play, by using some of the same lessons learned
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
EZCLCZE --###--
--#P#-- --###--
P-P#P-P --###--
++~~~++ ++~~~++
p-p#p-p --###--
--#p#-- --###--
ezclcze --###--
```

On the left is the opening setup. On the right is the game board without
any pieces (the terrain).

## The pieces

* `e` Elephant: Wazir + Dabbaba.  It can slide one square or leap two
  squares like a rook (when moving two squares, it jumps over other pieces)
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

## Notation

Notation is algebraic.  The square on the lower left corner is A1; the one
on the upper right hand corner is G7.  Here is an empty board with notation
and terrain:

```
7 -A7- -B7- #C7# #D7# #E7# -F7- -G7-
6 -A6- -B6- #C6# #D6# #E6# -F6- -G6-
5 -A5- -B5- #C5# #D5# #E5# -F5- -G5-
4 +A4+ +B4+ ~C4~ ~D4~ ~E4~ ~F4~ ~G4~
3 -A3- -B3- #C3# #D3# #E3# -F3- -G3-
2 -A2- -B2- #C2# #D2# #E2# -F2- -G2-
1 -A1- -B1- #C1# #D1# #E1# -F1- -G1-
   A    B    C    D    E    F    G
```

Movement is with standard Algebraic.  Piece names are:

* `P` Pawn
* `E` Elephant
* `Z` Zebra
* `C` Crocodile
* `L` Lion
* `MP` or `Q` Megapawn (“M” is a monkey in standard Congo; “G“ is a giraffe)

We allow `Q` to represent a megapawn so that ASCII boards can have the 
megapawn on them.  `Q` was chosen because, in normal Chess, pawns 
usually promote to a Queen, so `Q` represents a promoted pawn.

In order to make life easier for computers, if two pieces can move to a
given square, we specify the file (or row, if necessary), even if only
one move does not hang the Lion.  For example (upper case is Black,
lower case is white):

```
7 --##L--
6 --EE#--
5 --###--
4 ++~~~++
3 --###--
2 --e#e--
1 --##l--
  ABCDEFG
```

Here, E-D4 can be either E-CD4 or E-ED4.  Even though E-ED4 causes Black
to immediately take White’s Lion, it *is* a legal move in Congo, so we
have to specify the move as being E-CD4, which results in the following
position:

```
7 --##L--
6 --EE#--
5 --###--
4 ++~~~++
3 --###--
2 --#ee--
1 --##l--
  ABCDEFG
```

The piece does not have to be specified for pawn moves, unless more than
one pawn can move to a given square (more common in Congo than in Chess).
The `-` indicates a move in notation; `:` indicates a capture.  Placing
`#` after a move indicates that the opponent’s lion has been captured,
winning the game.

River captures are indicated by, after the move made, the river capture
is indicated by `,:` then the square where a piece drowned in the river.

## Example game

Here is an example game:

```
7 EZCLCZE 
6 --#P#-- 
5 P-P#P-P 
4 ++~~~++ 
3 p-p#p-p 
2 --#p#-- 
1 ezclcze 
  ABCDEFG
```
Starting position

1. D3 D5
2. C-F2 Z-D6
3. Z-D2 C-F6
4. E-A2 C-B6
5. Z-B3 P-AB4

Since two pawns could move to B4, we have to specify which pawn moved there.

```
7 EZ-L--E 
6 -C#Z#C- 
5 --PPP-P 
4 +P~~~++ 
3 pzppp-p 
2 e-###c- 
1 -zcl--e 
  ABCDEFG
```

6. P:AB4 P:B4
7. P:B4 C:B4
8. E-B2 Z-C5
9. C-C2 C-B5
10. Z-C3 C-C6
11. E-E1 E-E7
12. E-B4 Z:B3
13. C:B3 E:A5
14. E:E2 E:E6
15. E-A4 

```
7 --#L#-- 
6 --CZEC- 
5 E-#PP-P 
4 e+~~~++ 
3 -czpp-p 
2 --##ec- 
1 --#l#-- 
  ABCDEFG
```

15. ... E-C5
16. E-B4 C-B7
17. C-B2 E-EC6
18. E-C2 C-F5
19. Z-A4 E-A5
20. Z-C3 P-DD4
21. P:ED4 Z-E4

```
7 -C#L#-- 
6 --E##-- 
5 E-##PCP 
4 +e~pN++ 
3 -czp#-p 
2 -ce##c- 
1 --#l#-- 
  ABCDEFG
```

Black wins back the pawn because the E4 pawn will now drown in the river.

22. C-F3,:D4 Z-C5
23. E-D2 E-D6
24. C-E2 P-GF4
25. C-F2 P:G3
26. C:G3 E4
27. P:E4 Z:E4
28. Z:E4 C:E4

```
7 -C#L#-- 
6 --#E#-- 
5 E-###-- 
4 +e~~C++ 
3 --###-c 
2 -c#e#-- 
1 --#l#-- 
  ABCDEFG
```

29. E-B3 E-D5
30. E-E2 C-D4

Crocodiles do not drown in the river.

31. C-F2 E-AC5
32. E-E3 C-B6
33. L-D2 L-D6
34. E-BC3 E:C3
35. C:C3 C:C3
36. E:C3 E-D4
37. L-E1 E-D2

```
7 --###-- 
6 -C#L#-- 
5 --###-- 
4 ++~~~++ 
3 --e##-- 
2 --#E#c- 
1 --##l-- 
  ABCDEFG
```

L:D2?? can not be done because Black would then win the game with L:D2.
Black’s L:D2 is allowed because of the special rule that, if two lions 
face each other on the same file without any pieces in between them, 
one lion can capture the other lion.

38. C-F4 E-D1
39. L-E2 E-D2
40. L-E3 E-F2
41. C-E5 L-D7
42. C-E6 L-C6
43. L-D3

```
7 --###-- 
6 -CL#c-- 
5 --###-- 
4 ++~~~++ 
3 --el#-- 
2 --###E- 
1 --###-- 
  ABCDEFG
```

At this point, Black’s lion can not escape capture after C-D6 (Black can
not reply with L:D6 because then White can then play L:D6 winning the game).
However, Black can slow down capture by checking White’s king.  Since
Simple Megapawn Congo does not allow repetition, this delaying tactic
is ultimately futile.

43. ... E-F3 
44. L-D2 E-F2 
45. L-D1 E-F1 
46. L-D2 E-D1

E-F2 could not be played because that position has already been seen.

47. L:D1 C-B4
48. C-D6 L:D6

```
7 --###-- 
6 --#L#-- 
5 --###-- 
4 +C~~~++ 
3 --e##-- 
2 --###-- 
1 --#l#-- 
  ABCDEFG
```

Here, the two lions are on the D file with nothing between them.

49. L:D6#

White takes Black’s lion and wins.

## Playing with a chess set

Simple Megapawn Congo can be played with a standard Chess set:

* Use rooks for the Elephants
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
* Elephante (with an e at the end).  Lance + Wazir + sideways Dabbaba.  
  Moves one sqaure left or right.  Leaps two squares left or right.  Moves 
  one square backwards.  Moves forward like a rook (or the lance from Shogi).  
  All moves can be capturing.

The Pawn has the same image as the mPawn.  The Superpawn has the same image
as the Megapawn.  The Elephante has the same image as the Elephant.  It
is expected that one will not have Pawns and mPawns on the same board, nor
have Elephants and Elephantes on the same board.

# Results

Initial Zillions testing shows almost no draws.  Because of the 
no-repetition rule, even a Lion-vs-Lion endgame will have a decisive
result (since one player will be forced to either repeat a previous
position, or put their Lion in front of the other Lion).

# Old notes

## The control condition: Regular Chess

Here are the results playing regular Chess with the same engine:

* Game 1: White win
* Game 2: White win
* Game 3: Black win
* Game 4: Black win
* Game 5: Black win

## Stock Congo 

We had Zillions be at difficulty level 7, and had it play 5 games of
Stock Congo.  Here are the results:

* Game 1: Draw
* Game 2: Black win (White put all of their pawns on the third rank, in front
  of the river, and then both players aimlessly moved their pieces around
  on their side of the board, not daring to cross the river until move
  44, at which point White finally put a pawn in the river)
* Game 3: Draw
* Game 4: Black win
* Game 5: White win

## Congo with Islands

In this trial, repetition was a draw.

Now, let’s make a Congo variant where all of the rules are the same,
except squares A4, B4, F4, and G4 all have islands in the middle of 
the river which all pieces can stay on without risk of drowning.  The
crocodile moves as normal; this only affects the non-crocodile pieces.

Five games, level 7.  Results:

* Game 1: Draw
* Game 2: Black win
* Game 3: Draw (Black up material, draw by perpetual check.)
* Game 4: Draw
* Game 5: Draw

So, making the river safer on the sides, if anything, appears to
make the game *more* drawish.  Either that, or Zillions just doesn’t
know how to utilize the islands properly.

## Simpler Setup
Let’s have a different opening, with only elephants,
zebras, and crocs:

```
EZCLCZE
-PPPPP-
P-----P
++~~~++
p-----p
-ppppp-
ezclcze
```

* `+` River with island
* `~` River

Here, we only have elephants (wazir + dabbaba), Zebras (knights), and
Crocodiles (Commoners, except they move as a rook toward the river and
like a rook in the river), as well as the Lion (King) and enhanced pawn.
With only five piece types, this is a simplified version of Congo.

The reason for the advanced A and G pawns is to discourage an early
exchange of elephants.

And, with Zillions, it’s less drawish:

* Game 1: Black win
* Game 2: Black win
* Game 3: Draw
* Game 4: White win
* Game 5: Draw

## Crowded Congo

In this trial, repetition was a draw.

Another opening setup, “Crowded Congo”:

```
EZCLCZE
G--P--G
P-PMP-P
++~~~++
p-pmp-p
g--p--g
ezclcze
```

Here, the `G` is a giraffe: Moves (but does not capture) like a non-royal
king.  It leaps two squares (Alfil + Dabbaba) to either move or capture.

The `M` is a monkey: Moves (but does not capture) like a non-royal king.
Jumps like a checker to capture: It jumps precisely two squares (again,
like Alfil + Dabbaba) and captures the piece it jumps over.  A monkey
may capture multiple pieces.  Captures are never compulsory.

* Game 1: Black win
* Game 2: White win
* Game 3: White win
* Game 4: Draw
* Game 5: Draw

So, even with a more crowded setup, we still have a high draw rate.

## Mega Pawn Congo

Let’s make the pawns “mPawns”

* On the player’s side of the river, the pawns can move like a Chess
  pawn + Berolina pawn (move and capture n, nw, and ne)
* After crossing the river, the pawns move like Chess Pawn + Berolina
  pawn + move and capture one space sideways (n/nw/ne/w/e).  The
  pawns may not move backwards
* Once hitting the final rank, the pawns become very powerful megapawns:
  The pawns can move or capture to any space within two squares.  Unless
  one is recaptured right away, the enemy Lion will soon be captured.

The megapawns allow games to be resolved more quickly.

Since the pawns are more powerful, we have fewer of them:

```
EZCLCZE
---P---
P-P-P-P
++~~~++
p-p-p-p
---p---
ezclcze
```

7-ply games (repetition draw):

* Game 1: Black win
* Game 2: Draw
* Game 3: White win
* Game 4: White win
* Game 5: Black win

Fewer draws.  The pawns in stock Congo look to be too weak.

## Three minute Zillions games

Since even at 7-ply Zillions can not do basic endgame mates, I
have increased the skill level to the highest Zillions can do: 3
mintues per move on my i7-7600U CPU.  This means we are 12 ply deep
at the end of the search, hopefully deep enough to not completely
butcher the opening and endgame.

In the stock Congo game, White won after about 80 moves.

Experimentation showed that repetition-is-draw Simple Megapawn Congo
had too many draws.  A losing side could too easily force a draw
with perpetual check.  This is why repetition now loses.
