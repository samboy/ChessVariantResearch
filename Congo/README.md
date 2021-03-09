In the game of [Congo](https://en.wikipedia.org/wiki/Congo_(chess_variant)),
what is the draw percentage.  Can we reduce draws by making it so one
can only drown in C4/D4/E4?

# Results

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

As an aside, let’s have a different opening, with only elephants,
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

