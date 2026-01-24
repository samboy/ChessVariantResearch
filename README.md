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

`Capa` has research on Capablanca variants.

# Capablanca variants

World chapion #3, Capablanca, proposed a 10x8 variant with two extra
pieces: One that moves like a rook and a bishop, and another that moves
like a knight and a bishop.  Since there, there have been various
proposals to change the opening setup of Capablanca.

I’ve done a lot of study and have found a variant which looks remarkably
balanced.

Quick summary:

![RNABMKBQNR](https://samboy.github.io/blog/pics/FinesseChessBorder.png)

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

These are free 8x10 Knighted Chess setups which existed in 2008, as per
[a blog I posted back then](https://archive.ph/20090923161739/https://maradns.blogspot.com/2008/12/capa-opening-setups.html):

```
    Setup           Name               21-ply score    Notes	
    --------------  -----------------  --------------  -----------------
    RNABCKBQNR      Finesse            12              Pieces flipped
    RNBAQKCBNR      Capa 1             19
    RCNBQKBNAR      Carrera            26
    RNCBQKBANR      Nalls              29
    RBNCQKANBR      Univers            30
    RCNBAKBNQR      Notebook           35              Pieces flipped
    RNQBCKBANR      Blackbook          37
    RQNBAKBNCR      Schoolbook         38
    RBANCKNQBR      Grotesque          40              Pieces flipped
    RANBQKBNCR      Aberg              42
    RBCNAKNQBR      Landorean          45              Pieces flipped
    RNBACKQBNR      Embassy            45
    RNBQAKCBNR      Teutonic           50
    RNBCQKABNR      Bird               51
    RANBCKBNQR      Narcotic           52              Pieces flipped
    RNABQKBCNR      Capa 2             56
    RNBCAKQBNR      Consulate          60              Pieces flipped
```

### Finesse Chess

![RNABMKBQNR](https://samboy.github.io/blog/pics/FinesseChessBorder.png)

Finesse Chess has the best 21-ply score of a variant that existed in 2008,
and its 40-ply (20 move) NNUE (AI-based) evaluation is 22, i.e. White
in the Finesse setup is only 0.22 pawns ahead of Black when evaulated to
the 20th move; this is similar to classic Chess, where deep NNUE analysis
shows White 0.2 paws or so ahead.

White looks to, after 1,000 12-ply games, have a 3% or 4% edge, with a 12%
or so draw rate:

```
White 462 46.2%
Draw 115 11.5%
Black 423 42.3%
1000 games played
3.9% White winning edge
51.95% White score
```

This is much better than Classic (RNBQKBNR) chess using the same game engine
and game parameters:

```
White 197 39.4%
Draw 150 30%
Black 153 30.6%
500 games played
8.8% White winning edge
54.4% White score
```

Note that we need more games to get a better sense of White’s edge because
the tournaments have long streaks of mainly White wins or Black wins and
the White edge flucuates wildly.

Point being:

* Finesse Chess has been around since 2008, I claim no intellectual property
  on its design, and it’s incredibly balanced.
* More to the point, in Finesse Chess, White wins less often than he does
  in classic Chess, and draws are much less common.
