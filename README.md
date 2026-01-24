# Chess variant research

This is my attempt to find Chess variants which are balanced while not
being drawish: Draws are rare, and white does not have a significant
advantage.

In the `Turtle Shell` directory, there is research showing
a playable set of chess variants on an [unusual 
tiling](https://en.wikipedia.org/wiki/33344-33434_tiling).

There is also some look at both Chess (Chess960 setup #518 if you will)
and Chess960 in the `Chess960` directory.

`ShortRange` has some research about the number of non-colorbound possible
short range pieces a Chess variant on a square board can have.  Almost
all possible short range pieces are not colorbound.

# Capablanca variants

World chapion #3, Capablanca, proposed a 10x8 variant with two extra
pieces: One that moves like a rook and a bishop, and another that moves
like a knight and a bishop.  Since there, there have been various
proposals to change the opening setup of Capablanca.

I’ve done a lot of study and have found a variant which looks remarkably
balanced.

Quick summary:

![RNABMKBQNR](https://samboy.github.io/blog/pics/FinesseChess.png)

Knight + Bishop pices moves like knight or bishop; Knight + Rook piece
moves like knight or rook.  King moves three (instead of two) squares
when castling.

## My 2009 research

To the right of each setup is the white advantage and draw percentage
from my 2009 research which used Joker80 (`m` here is the Rook + Knight
piece, `a` is bishop + knight):

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

## My 2026 research


