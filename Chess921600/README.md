# What this is

There is a concern that 960 possible setups may not be enough, and some
really smart grandmaster may have the ability to remember openings for
all 960 setups.  While that seems far fetched, if it ever were to become
a problem, we can have “Double Fischer Random” which has different 
Chess960 setups for White and Black.

There are 921,600 possible “Double Fischer Random” setups, hence the
name Chess921600.

However, then the concern is: Does a setup unfavorably favor Black or
White?  And the answer is, with many setups, less so than with 
Classic Chess (which gives White a 39 centipawn advantage).

## This program

This program looks at a Double Fischer Random setup, evaluates it with
Stockfish (21-ply) and tells us how balanced it is.

If the evaluation is 0, that means the setup is balanced: At Stockfish’s
12-ply evaluation, neither White nor Black have an advantage.

For example, the seed 1772053877 gives us a 0 eval right off the bat:

```
$ lunacy FindBalancedSetup.lua 100 1772053877
1772053877,1,nbrqbkrn/pppppppp/8/8/8/8/PPPPPPPP/QNRBBKNR w KQkq - 0 1:0,c2c4;
Eval 0 found, job done
```

To use FindBalancedSetup.lua, the arguments are (both optional)

* Iterations: How many random setups do we choose and then have Stockfish
  evaluate at 21-ply depth?
* Seed: The seed to make the setups (one seed can make unlimited setups,
  the seed can be a number or a String)

If we find a setup with an eval of 0, we stop our search.  Otherwise, 
we list setups we find which have a lower White or Black advantage than 
the last setup listed:

```
$ lunacy FindBalancedSetup.lua 500 777
777,1,bbnqrknr/pppppppp/8/8/8/8/PPPPPPPP/NRNQKBBR w KQkq - 0 1:-116,d2d4;
777,2,rnknbqrb/pppppppp/8/8/8/8/PPPPPPPP/RBNQBKNR w KQkq - 0 1:45,c2c3;
777,4,bbqrknrn/pppppppp/8/8/8/8/PPPPPPPP/RKBBNRNQ w KQkq - 0 1:11,a2a4;
777,37,bbrnkrnq/pppppppp/8/8/8/8/PPPPPPPP/QNNRBKRB w KQkq - 0 1:-3,g2g3;
777,137,rnbkrbqn/pppppppp/8/8/8/8/PPPPPPPP/RKBBQNRN w KQkq - 0 1:-1,d2d4;
777,246,qbrknrbn/pppppppp/8/8/8/8/PPPPPPPP/BRKBQNNR w KQkq - 0 1:0,b2b3;
Eval 0 found, job done
```

Here, the first setup we found really favored Black, the second setup
we found really favored White, and the fourth setup has a much smaller
White advantage than Classic Chess does.  On the 37th setup, we found 
a setup which only slightly favores Black, on the 137th setup we 
got a setup which barely favors Black, and finally on the 246th setup
we got a balanced setup.

## TCEC evaluation of all 921,600 positions

The TCEC, a few years ago, did a [20-ply analysis of all 921,600
positions of Double Fischer Random 
Chess](https://tcec-chess.com/misc/dfrc/DFRC_depth20.csv.xz).  I
have taken that data, and sorted it by White’s evaluation (in 
centipawns) and the setup.  

There are 14,406 setups that evaluation found to be perfectly
balanced.

