# Chess variant research

This is my attempt to find Chess variants which are balanced while not
being drawish: Draws are rare, and white does not have a significant
advantage.

# Capablanca variants

World chapion #3, Capablanca, proposed a 10x8 variant with two extra
pieces: One that moves like a rook and a bishop, and another that moves
like a knight and a bishop.  Since there, there have been various
proposals to change the opening setup of Capablanca.

Here is some of my study of these variants, using Fairy-Stockfish.

## How to look at Capablanca setups in Fairy-Stockfish

It’s actually possible to run commands directly from Fairy-Stockfish’s
command line.

Let’s look at a variant:

```
xboard
variant capablanca
setboard ranbqkbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RANBQKBNCR w KQkq - 0 1
d
analyze
```

First number is plies.  Second number is white’s advantage, in centipawns.
Third number is elapsed time (centiseconds), fourth number is nodes searched.

As per 
https://maradns.blogspot.com/2009/10/capablanca-opening-setup-research.html
here are some other set ups to look at:

```
setboard ranbqkbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RANBQKBNCR w KQkq - 0 1
setboard rqnbakbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RQNBAKBNCR w KQkq - 0 1
setboard rqnbckbnar/pppppppppp/10/10/10/10/PPPPPPPPPP/RQNBCKBNAR w KQkq - 0 1
setboard ranbckbnqr/pppppppppp/10/10/10/10/PPPPPPPPPP/RANBCKBNQR w KQkq - 0 1
setboard rcnbakbnqr/pppppppppp/10/10/10/10/PPPPPPPPPP/RCNBAKBNQR w KQkq - 0 1
setboard rcnbqkbnar/pppppppppp/10/10/10/10/PPPPPPPPPP/RCNBQKBNAR w KQkq - 0 1
```

Since Fairy Stockfish is deterministic, playing 1000 games will just
result in the same game being played 1000 times.  So, we will just perform
a 30-ply analysis of the above six opening positions.

## Results 

`RQNBAKBNCR` (+8% White, 13% Draws)

```
30 60 37392 81774242 42 218694 0         e2e4 e7e5 c2c3 h8g6 f2f3 d7d5 (etc.)
```

`RANBCKBNQR` (+8% White, 10% Draws)

```
30 71 36180 78484478 44 216923 0         d2d4 h8g6 e2e4 e7e5 d4e5 f7f6 (etc.)
```

`RCNBAKBNQR` (+16% White, 10% Draws)

```
30 75 26930 56640413 43 210323 0         e2e4 f7f6 d2d4 e7e5 f2f3 h8g6 (etc.)
```

`RANBQKBNCR` (+3% White, 12% draws)

```
30 87 43785 99279922 46 226740 0         d2d4 f7f6 e2e4 e7e5 d4e5 h8g6 (etc.)
```

`RCNBQKBNAR` (+5% White, 12% draws)

```
30 87 41632 86329874 47 207362 0         f2f4 f7f5 i1h3 c8d6 e2e4 f5e4 (etc.)
```

`RQNBCKBNAR` (+8% White, 10% draws)

```
30 114 30852 67721988 46 219499 0        i1h3 e7e6 e2e4 i8h6 f2f4 c7c6 (etc.)
```

## My 2009 research

To the right of each setup is the white advantage and draw percentage
from my 2009 research which used Joker80 (`m` here is the Rook + Knight
piece):

```
Setup	        Wins	Losses	Draws	White	Games played
ranbqkbnmr	46%	43%	12%	+3%	1010
rmnbqkbnar	47%	42%	12%	+5%	1017
ranbmkbnqr	49%	41%	10%	+8%	1002
rqnbakbnmr	48%	40%	13%	+8%	1006
rqnbmkbnar	50%	38%	11%	+12%	1004
rmnbakbnqr	53%	37%	10%	+16%	1011
Numbers may not add up to 100% because of rounding
```

# Standard western Chess

As a point of comparison, here is what Fairy Stockfish has to say
about standard western Chess:

`RNBQKBNR`

```
30 67 22524 58470334 44 259590 0         d2d4 g8f6 c2c4 d7d5 c4d5 c7c6
```

(Queen's Gambit Declined: Marshall Defense, Tan Gambit)

## Looking at multiple possible lines

Let us start up the Fairy-Stockfish program from the command line.
We should see something like this:

```
Fairy-Stockfish 11.2 LB 64 by Fabian Fichter
```

Let’s start off by typing this command:

```
setoption name MultiPV value 7
```

This instructs Fairy Stockfish to tell us the seven best possible moves
for any given position.

We can also, if we have the memory, increase the hash size.  For example,
since my computer has 32 gigs of memory, we will use 16 gigs for the
hash table:

```
setoption name Hash value 16384
```

Use a smaller number than 16384 if one’s computer has less memory.

Then, type in `xboard` and then `variant chess` to get in “xboard” mode
to play a game of standard FIDE chess.

The `variant chess` command gives us this output:

```
setup (PNBRQ................Kpnbrq................k) 8x8+0_fairy 
rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
piece P& fmWfceFifmnD
piece N& N
piece B& B
piece R& R
piece Q& RB
piece K& KO2
```

Then we type in `d` for “display board” and see this:

```
 +---+---+---+---+---+---+---+---+
 | r | n | b | q | k | b | n | r |8  
 +---+---+---+---+---+---+---+---+
 | p | p | p | p | p | p | p | p |7
 +---+---+---+---+---+---+---+---+
 |   |   |   |   |   |   |   |   |6
 +---+---+---+---+---+---+---+---+
 |   |   |   |   |   |   |   |   |5
 +---+---+---+---+---+---+---+---+
 |   |   |   |   |   |   |   |   |4
 +---+---+---+---+---+---+---+---+
 |   |   |   |   |   |   |   |   |3
 +---+---+---+---+---+---+---+---+
 | P | P | P | P | P | P | P | P |2
 +---+---+---+---+---+---+---+---+
 | R | N | B | Q | K | B | N | R |1 *
 +---+---+---+---+---+---+---+---+
   a   b   c   d   e   f   g   h

Fen: rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
Sfen: rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR b - 1
Key: 9160F14A6C929FCE
Checkers: 
```

Then `analysis`, and after about an hour we get something like this:

```
1 110 0 119 1 39666 0	 e2e3
1 102 0 119 1 39666 0	 e2e4
1 95 0 119 1 39666 0	 d2d4
1 79 0 119 1 39666 0	 d2d3
1 70 0 119 1 39666 0	 b1c3
1 63 0 119 1 39666 0	 g1f3
1 25 0 119 1 39666 0	 b2b3
[Lots of lines removed; following sorted by strength]
35 44 430940 1299596665 53 301571 0	 d2d4 e7e6 c2c4 d7d5 b1c3 g8f6 (etc.)
35 44 430940 1299596665 52 301571 0	 e2e4 e7e6 d2d4 d7d5 b1d2 c7c5 (etc.)
35 40 430940 1299596665 50 301571 0	 c2c4 e7e5 g2g3 d7d5 c4d5 d8d5 (etc.)
35 36 430940 1299596665 49 301571 0	 a2a3 e7e6 d2d4 c7c5 e2e3 d7d5 (etc.)
34 29 423382 1276264758 46 301445 0	 e2e3 d7d5 g1f3 e7e6 d2d4 g8f6 (etc.)
35 29 430940 1299596665 53 301571 0	 g1f3 d7d5 d2d4 g8f6 c2c4 e7e6 (etc.)
34 24 430940 1299596665 48 301571 0	 c2c3 d7d5 d2d4 g8f6 c1f4 e7e6 (etc.)
```

The only fields we will look at are the first one (the search depth, in 
plies), the second one (how strong the current player’s advantage is, in 
centipawns; when the other player is ahead, this is a negative number),
and the fields showing the move on the right hand side.

Fairy Stockfish thinks 1. d4 and 1. e4 are White’s strongest moves,
which is consistent with classical Chess theory.  1. c4 is almost as 
strong.  For some reason, it thinks 1. a3 is strong (???), followed by
e3 (??), Nf3, and c3 (???).

