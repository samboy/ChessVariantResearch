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

