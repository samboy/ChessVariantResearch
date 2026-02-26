Let’s take Capablanca Chess, which is an 8x10 variant where two pieces
are added to the usual army: A piece that can move like either a rook
or knight (“Marshal” or “Chancellor”), and another piece that can move
like either a Bishop or Knight (“Archbishop”).

When I say 8x10, the board is eight squares high but 10 squares wide.

Now, what happens when we adopt Fischer Random Chess (Chess960) to this
larger 8x10 Capablanca board?

## Many more possible setups

Let’s take Chess, and choose a setup where:

* The rooks remain in the corners
* The king remains on the “e” file
* The bishops are on opposite colors
* Besides these restrictions, the pieces may be placed anywhere

With standard Chess, this gives us only 18 possible setups.

Now, let’s take Capablanca Chess, and choose a setup where:

* The rooks remain in the corners
* The king remains on the “f” file
* The bishops are on opposite colors
* Besides these restrictions, the pieces may be placed anywhere

With Capablanca Chess, this gives us 720 possible setups.

OK, now let’s look at Fischer Random Chess:

* The king has to be between the rooks
* The bishops are on opposite colors
* Besides these restrictions, the pieces may be placed anywhere

This gives us 960 different setups: Chess960

What happens when we do the same with Capablanca Chess:

* The king is between the rooks
* The bishops are on opposite colors
* Besides these restrictions, the pieces may be placed anywhere

This gives us 84,000 setups, a setup sometimes incorrectly called
“Capa960” but is better called “Capa84000”.

## Is that enough setups?

So, is it possible for Black and White to have different setups?

Yes!

When we do this with Chess960 (“Double Fischer Random Chess”), we get
960 * 960 (921,600) different setups.  That’s a lot of setups, but all
setups have been evaluated with a 20-ply evaluation (see the folder
Chess921600 for more discussion); about 14,000 of them look to be
balanced (where White and Black have equal chances in the opening 
position).  I wrote a script which runs setups of Chess921600 at
ramdom until Stockfish feels the setup, with a 21-ply evaluation,
looks balanced.

We can do the same thing with Capa84000, giving us some 7,056,000,000 
different possible starting setups.  Just as I have a script for
finding balanced setups for Chess921600, I also have a script for
finding balanced setups for Capa7056000000.  Since it takes more time
to evaluate a position in Capa than it does with ClassicChess, the
script does, by default, a 17-ply instead of a 21-ply search.

Example of using the script:

```
$ lunacy FindBalancedSetup.lua 500 777
777,1,rbqcbknrna/pppppppppp/10/10/10/10/PPPPPPPPPP/RNBBQKNRCA w KQkq - 0 1:84,g2g4;
777,2,anbbqcrkrn/pppppppppp/10/10/10/10/PPPPPPPPPP/BCRQKRABNN w KQkq - 0 1:-58,e2e3;
777,5,nbqrkrbcan/pppppppppp/10/10/10/10/PPPPPPPPPP/ABCRBKNQRN w KQkq - 0 1:31,c2c4;
777,6,nbrankbqcr/pppppppppp/10/10/10/10/PPPPPPPPPP/NARBKQBRNC w KQkq - 0 1:3,i1h3;
777,100,rbkrqnnabc/pppppppppp/10/10/10/10/PPPPPPPPPP/QBNCANRKBR w KQkq - 0 1:0,d2d4;
Eval 0 found, job done
```

Here, 500 is the number of different setups we try.  777 is the seed; the
seed can be a number or a string.  There is an optional third argument:
The search depth.  Since it’s not specified here, the search depth 
defaults to 17 (as in 17 plies; i.e. 8 1/2 moves).
