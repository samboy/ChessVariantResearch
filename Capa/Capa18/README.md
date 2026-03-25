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

[RNCBAKBQNR](index.html#RNMBAKBQNR)  

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

### RNQBAKBCNR

[RNQBAKBCNR](index.html#RNQBAKBMNR)

This is the same setup with the Queen and Marshal (“C”) swapped.  Like
the previous setup, there is an unprotected pawn, which is why this
setup was never named, but here the unprotected pawn is the “I” pawn
instead of the B pawn.

Like the previous setup, the “I” pawn is poisoned, and 1. Mi3 to try and
get the pawn is White’s worst opening move.  E.g. 1. Mi3? e5 2. Mxi7? h5
3. d4 Bi6 and the Marshal, just as it was with the previous setup, is
now hemmed in.

I call this the “Poisoned I Pawn” setup, so it finally has a name.

### RQNBCKBNAR

[RQNBCKBNAR](index.html#RQNBMKBNAR) 

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

# The previously named positions

The other 15 positions have names (I came up with 6 names: Finesse,
Blackbook, Narcotic, Notebook, Schoolbook, and Consulate)

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
remarkably balanced, but not as balanced as Finesse Chess which I proposed
at the same time.

## Nalls

Nalls came up with this optimized setup for Capablanca Chess, and,
indeed, it’s one of the most balanced Capa18 setups.

## Capablanca’s Second Proposal

Trice correctly noted that Capa’s second proposal favors white.  It’s
still a good game, but we’re starting to reach the setups where we
either play a double round robin or implement the “pie rule”, where
player one chooses White’s first move and player two chooses whether
to play White or Black.

## Murray-Carrera

Murray’s famous 1913 book on the history of Chess ended up misreading
Carrera’s original 1617 proposal for an 8x10 variant, placing the
Marshal on the left and the Archbishop on the right, instead of Carrera’s
idea to place the archbishop on the left and the Marshal on the right.

As it turns out, Murray’s misreading results in a game more balanced
than Carrera’s original proposal.

## Narcotic

One of my joke proposals from 2008, and an unbalanced one at that.

## Notebook

Another 2008 joke proposal.

## Bird’s Chess

In the 19th century, Chessmaster Bird proposed a different setup than
Carrera’s original setup.  It’s not the most balanced setup, but it’s
the first setup to have the knights on the b and i files, and the bishops
on the c and h files.

## Schoolbook Chess

My own proposal from 2006.  I did a lot of research on this setup and
went to a lot of effort to make this setup as balanced as possible.
Ultimately, it was not as balanced as I thought it was, and by 2010
I began looking for a more balanced setup.

## Teutonic Chess

This proposal, which Mats Winther made and quickly withdrew once it
was pointed out White has a first move mating threat, is rather
unbalanced: Unprotected pawns, first move mating threat, and 
modern Stockfish analysis also shows White has a considerable
advantage.

## Embassy Chess

Once the admins of Brainking.com decided they didn’t want to allow people
to play Trice’s setup on their server, they replaced it with Embassy Chess.
To avoid any patent concerns, they used the 1984 Grand Chess opening setup,
adapted to a 10x8 board.  Stockfish analysis shows it favors White, but
White only has a 3.5% edge across the thousands of games played with this
setup:

```
white	7801 (50.58%)
black	7268 (47.12%)
draw 	 354 (2.29%)
```

## Carrera Chess

The original setup.  The reason for this placement is so that one’s
Knights, Bishops, and Queen develop the same way they do in Classic
Chess.  It results in a placement that favors White, though, although
that advantage can be reduced by swapping the Marshal and Archbishop.

## Consulate Chess

Another joke proposal I made in 2008: Take Embassy Chess and swap the
Marshal and Archbishop.  Stockfish finds this setup very unbalanced,
although, strangely enough, my 2022 testing did not show White having
an edge.

