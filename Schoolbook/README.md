# What this is

In 2006, I created a chess variant called Schoolbook Chess.

Back in the mid-first-2000s-decade, there was a lot of discussion about
which setup was the best setup for Capablanca chess. Capablanca chess
is a variant of chess where the board is made 2 files (columns) wider
but remains 8 ranks (rows) high, and two new pieces are added:

* A piece which moves like a bishop or knight, which I call, in Schoolbook, 
  an *archbishop*.
* A piece which moves like a rook or knight, which I call, in Schoolbook, 
  a *marshal* (or *marshall* with two “l”s).

Schoolbook was the opening setup I proposed for Capablanca chess back
in 2006. It puts the queen on the left wing, the archbishop next to the
king, and the marshal on the right wing. Knights and bishops more or
less develop as they do in “normal” Chess (as an aside, we can no
longer call normal chess “FIDE Chess” as we used to do, for reasons
I will detail below).

Schoolbook initially had complicated castling rules, but in its current
form, castling is always three squares towards the corresponding rook.

Initial testing did not find significant advantage for White. Then, later
on, back in 2009, the strongest engine which could play Schoolbook chess
was H.G. Muller’s excellent Joker80 engine, which seemed to show White
had a strong advantage after 1. c3. Because of this, I put Schoolbook
chess on the shelf and tried out another opening setup.

More recently, the even stronger Fairy Stockfish engine has come out,
which can handily defeat Joker80, and it shows that Schoolbook chess,
in fact, is one of the most balanced Capablanca chess opening setups,
with a relatively low advantage for White. This in mind, I have gone
back to considering Schoolbook to be the best Capablanca opening setup
I have come up with.

# The environment

The environment here is a Windows 10 machine using Cygwin.  The 
directions are similar but might vary in other environments.

# The files here

Included is the following file:

`capablanca-bb644ef32758-2022-05.nnue`

This is a neural network optimized to play Capablanca (and Schoolbook)
Chess as strongly as possible.

Since this file is 101,518,240 bytes in size uncompressed, I have 
compressed it using the `xz` program.

To decompress the file:

`xz -k -d capablanca-bb644ef32758-2022-05.nnue.xz`

The file, once uncompressed, has a MD5 sum of 
`3cbb35a76799176837990410c18c6a54`, a SHA-256 sum of
`bb644ef32758eb8e1e6d795226290ec2c816beee479c8cd82939aa5f53517732`, and a
RadioGatún[32] sum of
`53e10b9a18d5a0e1892f6d13a95d03b10ceb4721f3e05be174a9d3d6b157c81a`

# Testing Schoolbook

To test Schoolbook with this NNUE file, one will need Fairy Stockfish:

https://github.com/ianfab/Fairy-Stockfish/releases/tag/fairy_sf_14_0_1_xq

As a courtesy, I have included a Windows binary of this program here;
as per the GPL, source code is also available as a `.tar.xz` file.

To evaluate the opening do the following:

`./fairy-stockfish-largeboard_x86-64-bmi2.exe | tee fs-out.txt`

Then, let’s set things up for Schoolbook Chess:

```
uci
setoption name UCI_Variant value capablanca
position fen rqnbakbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RQNBAKBNCR w KQkq - 0 1
setoption name Use NNUE value true
setoption name Evalfile value capablanca-bb644ef32758-2022-05.nnue
setoption name MultiPV value 7
```

Some points here:

* `uci` is the interface we use (the commands we send)
* `UCI_Variant` tells us to play an 8x10 Capablanca variant
* `position` sets up the Schoolbook opening position
* `Use NNUE` sets up the best possible evaluation
* `Evalfile` points to the Capablanca chess NNUE we have
* `MultiPV` here means we look at the seven best possible moves

Let’s verify we’re ready to evaulate things with the NNUE file and
the Schoolbook position.  Again, in Fairy Stockfish:

```
d
eval
```

Now we can evaluate the starting position and start to build up
a Schoolbook opening book:

```
go
```

To make moves before evaluating the position, we can do a command
in this form:

```
position fen  rqnbakbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RQNBAKBNCR w KQkq - 0
 1 moves i1h3
```

# OK, let’s look at the output

The output will look like this after a few minutes:

info depth 25 seldepth 32 multipv 1 score cp 55 nodes 225830104 nps
568789 hashfull 1000 tbhits 0 time 397036 pv f2f4 f7f5 i1h3 i8h6 h3h6
g7h6 h1g3 e7e6 e2e4 f5e4 d2d3 g8f7 d3e4 h8i6 c1d3 f8i8 j2j4 h8g8 d1i6
h7i6 j4j5 i6j5 e1f3 i7i6 e4e5 c8e7

info depth 25 seldepth 31 multipv 2 score cp 48 nodes 225830104 nps 568789
hashfull 1000 tbhits 0 time 397036 pv i1h3 e7e5 e2e4 c8e7 d2d4 f7f6 c1d3
c7c5 d4c5 b7b6 f2f4 e5f4 d3f4 h8g6 g1e3 g6f4 e3f4 d8c7 f4c7 g8c4 f1g1

info depth 25 seldepth 30 multipv 3 score cp 43 nodes 225830104 nps
568789 hashfull 1000 tbhits 0 time 397036 pv h1g3 h8g6 e2e4 e7e5 d2d4
e5d4 i1h3 c7c5 c1e2 c8e7 c2c3 h7h5 h3h5 g8i6 h5c5 d4c3 e2c3 d8b6 c5g5
e8f6 g5h3 i6d1 b1d1 i8h6 e1d2 h6h3

info depth 25 seldepth 31 multipv 4 score cp 43 nodes 225830104 nps 568789
hashfull 1000 tbhits 0 time 397036 pv e2e4 h8g6 i1h3 e7e5 d2d4 f7f6 c1d3
d7d5 f2f3 c7c6 h1i3 c8d6 c2c3 e8d7 g2g4 d5e4 f3e4 d6e4 i3h5 e5d4 g1d4 g8c4

info depth 25 seldepth 28 multipv 5 score cp 37 nodes 225830104 nps
568789 hashfull 1000 tbhits 0 time 397036 pv c2c3 h8g6 h1i3 d7d5 d2d4
c8d6 f2f3 f7f5 c1d3 j7j5 g2g3 j5j4 i3g2 e7e6 d3e5 g6e5 d4e5 d6c4 g1c5
d8e7 c5e7 f8e7 i1h3 c4e5

info depth 25 seldepth 30 multipv 6 score cp 18 nodes 225830104 nps
568789 hashfull 1000 tbhits 0 time 397036 pv c1d3 f7f5 f2f4 e7e6 i1h3
h8i6 h1i3 i8h6 h3h6 i7h6 e2e3 c8d6 d3e5 d6f7 e5f3 j7j5 c2c3 j5j4 i3h5
f7d6 f3e5 d6e4 d2d3 e4f6

info depth 24 seldepth 26 multipv 7 score cp 15 nodes 225830104 nps
568789 hashfull 1000 tbhits 0 time 397036 pv d2d4 f7f5 c2c3 c8d6 f2f3
h8g6 e2e4 f5e4 f3e4 e7e5 c1d3 d6e4 h1f2 e4f2 e1f2 c7c6 i1h3 i8h6 h3h6 i7h6

Some things we can see here:

* 24-25 nodes deep, White has a very slight edge compared to standard 
  international chess.  An equivalent evaluation of standard international
  chess shows white has a 42 centipawn advantage after 1. e4 e5 2. Nf3
  Nc6 3. Nb5 a6 4. Ba4 Nf6 5. O-O Nxe4 6. d4 b5 etc.; with Schoolbook
  the advantage is 55 centipawns, or a little over 1/10 of a pawn better.
* White’s best opening looks to be 1. f4 f5 2. Mh3 Mh6 3. Mxh6 gxh6 4. Ng3 e6
  5. e4 fxe4 6. d3 Bf7 7. dxe4 Ni6
* White has five good opening moves: f4, Mh3, Ng3, e4, and c3.

