# Capa18

Capa18 is a variant of Capablanca Chess where:

* We place the rooks in the corners
* We place the King on the “f” file
* The knights and bishops are symmetrical
* The bishops are closer to the center than the knights

I listed [some Capa setups back in
2008](https://archive.ph/20090923161739/https://maradns.blogspot.com/2008/12/capa-opening-setups.html); of the 18 possible Capa18 setups, 15 of them had
names back then.

As an aside, I call the Rook + Knight piece “C” here in the setups, even 
though I also call it the Marshal (or “M” piece).

## Ranking the setups

I have analyzed all 18 setups at a depth of 18 plies, 19 plies, and so on
up until 30 plies, then I weighted the setups, giving more plies more
weight than fewer plies.  In addition, I look at the mean and median for
every evaluation between 18 and 30 plies.

Here are the results:

```
Weighted avg    Mean    Median  Setup
17.32           17.54   16      RNABCKBQNR      (Finesse)
23.67           24.15   24      RNBAQKCBNR      (Capa1)
27.15           26.69   27      RNBQCKABNR      (Trice)
27.37           29.85   30      RNQBCKBANR      (Blackbook)
29.96           32.08   32      RNCBAKBQNR
31.64           30.77   29      RNCBQKBANR      (Nalls)
38.04           34.62   36      RNABQKBCNR      (Capa2)
40.36           41.77   42      RCNBQKBNAR      (MurrayCarrera)
40.92           41.69   42      RNQBAKBCNR
41.21           43.38   45      RANBCKBNQR      (Narcotic)
42.85           40.77   36      RCNBAKBNQR      (Notebook)
43.65           44.77   43      RNBCQKABNR      (Bird)
43.68           42.15   41      RQNBAKBNCR      (Schoolbook)
46.91           48.08   45      RNBQAKCBNR      (Teutonic)
48.09           46.62   43      RNBACKQBNR      (Embassy)
51.90           48.46   47      RANBQKBNCR      (Carrera)
62.36           59.23   60      RNBCAKQBNR      (Consulate)
89.14           91.23   94      RQNBCKBNAR
```

## The unnamed positions

Let’s look at the three unnamed positions.

### RNCBAKBQNR

[RNCBAKBQNR](Capa36.html#RNMBAKBQNR)  

This setup was neglected back in the first 2000s decade because the B pawn
is undefended, in an era when we felt all of the pawns had to be defended.

However, the pawn is a poisoned pawn.  Moving 1. Mb3 to threaten the
pawn is White’s worst opening move.  This is because, while White can
get the pawn, he loses multiple tempi doing so, especially since Black
can hem in the Marshal, e.g. 1. Mb3? g6 2. Mxb7? c5 3. g3 Bb6 and now
the Marshal is trapped.

Point being, White had an edge in this setup, but it’s not that big
of an edge, and trying to attack the unprotected B pawn in the opening 
gives Black a considerable lead.

I call this the “Poisoned B Pawn” setup, so it finally has a name.

## RNQBAKBCNR

[RNQBAKBCNR](Capa36.html#RNQBAKBMNR)

This is the same setup with the Queen and Marshal (“C”) swapped.  Like
the previous setup, there is an unprotected pawn, which is why this
setup was never named, but here the unprotected pawn is the “I” pawn
instead of the B pawn.

Like the previous setup, the “I” pawn is poisoned, and 1. Mi3 to try and
get the pawn is White’s worst opening move.  E.g. 1. Mi3? e5 2. Mxi7? h5
3. d4 Bi6 and the Marshal, just as it was with the previous setup, is
now hemmed in.

I call this the “Poisoned I Pawn” setup, so it finally has a name.

## RQNBCKBNAR

[RQNBCKBNAR](Capa36.html#RQNBMKBNAR) 

This is a really unbalanced setup really favoring White:

* The D pawn is undefended
* The I pawn is also undefended
* White can threated mate on the first move with 1. Md3
* 1. Ah3 also threatens mate on the first move
* Fairy Stockfish evaluation of this position shows White with a strong
  edge, over a pawn strong in some cases (depending on how many plys we
  look ahead)

It will be very hard for Black to equalize with this setup unless “Pie
Rule” is implemented, or we restrict which moves White is allowed to 
make on his first move.  

If one has to use this setup, good Pie Rule moves are 1. c3 or 1. Nb3.
Another option is to force White to move a pawn only one square
forward on his first move; 1. f3, with a mere 2 centipawn advantage,
is White’s best move when we impose that restriction.  While the
restriction to move a pawn one square forward on White’s first
move doesn’t balance things with other setups (in Classic Chess,
for example, White can simply play 1. g3! and maintain an edge), it
balances things with this setup.

I call this setup “Unbalanced Capa” because it is so unbalanced.

## Finesse Chess

Finesse Chess is the most balanced of Capa18 setups.  I originally
proposed this setup as a joke back in 2008, but the name sticks
and, if I were to promote a single setup for Capablanca Chess
today, it would be this setup.

## Capa’s first setup

Capa’s first setup either is farily balanced or greatly favors
White, depending on how deep we search.  Capa himself abandoned
the setup, but it looks to be more balanced than his second
attempt.

## Trice’s Chess

This used to be called “Gothic Chess”, but Trice came to prefer
the name “Trice’s Chess”.  After seeing Capa’s second setup
prefer Black too much, Trice came up with this setup and patented
it.  The patent has long since expired, and, like almost all
Chess Variants, the game never drew much interest.

It’s one of the most balanced Capablanca 18 setups, but Finesse
has an edge over it.

## Blackbook

Blackbook is another one of my joke proposals from 2008.  It’s
remarkably balanced, but as balanced as Finesse Chess which I proposed
around the same time.

