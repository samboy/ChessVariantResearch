This zip archive is both a rules file for the commercial game Zillions 2.0 
that allows people to play Schoolbook (Zillions is available at
http://www.zillions-of-games.com) and a set of Chess piece graphics
which are either public domain or released under a liberal license (see
the file copying.txt for details).

There are four .zrf files here:

* Schoolbook2.zrf, which implements the rules for version 2.0 of
  Schoolbook, where the king always moves three squares when castling.

* Schoolbook-a.zrf, which uses Mats Winther's tweaks to make Zillions
  play a better game.  A few variants with different pawn moves
  (including Mats' Scorpions) are included in the .zrf file.
  This has not been updated for Schoolbook 2.0; if one wishes a
  strong engine, use Fairy Stockfish along with a Capablanca NNUE
  file.

* Schoolbook-b.zrf, which is a "stock" set of rules for Zillions.
  This file makes the standard mistakes Zillions makes: Developing
  knights and archbishops before pawns, moving the queen too early,
  etc.  The advantage of this .zrf file is that it offers a number
  of interesting variants not offered in the Schoolbook-a.zrf file.
  This uses the version 1 rules of Schoolbook.

* Schoolbook-compat.zrf.  This is a "compatibility" .zrf file, which
  is compatible with saved games created by early versions of the
  Schoolbook .zrf.  Only use this if you have an old saved game you want
  to replay.  This uses the version 1 rules of Schoolbook.

There is also a good deal of documentation here, including 20 different
mating problems and some opening analysis.

A description of Schoolbook is in the file schoolbook.html in the
directory doc/, and is as follows:

---

                               Introduction

   Schoolbook is my take on 8x10 chess with the rook + knight and bishop
   + knight pieces added. While a number of different opening setups
   using these pieces and board have been proposed, I have not been
   completely satisfied with any of them. My goal, in designing
   Schoolbook, was to come up with an 8x10 opening setup with the
   following characteristics:

     * All of the pawns are defended in the opening array; as many
       pieces as possible are defended in the opening array.
     * The development of the knights and bishops resembles their
       development in FIDE chess; other arrays seem to be detrimental.
       For example, some 8x10 arrays have it so moving the center pawns
       two squares forward blocks the development of the bishops.
     * The rooks are placed in the corners, and the king is centrally
       placed. This makes the opening setup more ascetically pleasing.

   There are two opening setups which meet this criteria. I chose the
   one where white's queen is left of his king, since this allows a
   right-side castle to be done more quickly, and since this preserves
   the traditional idea of having a "king side" and a "queen side".

   Schoolbook is for people who like 19th century tactical chess. By
   putting the archbishop in the center like that results in having the
   archbishop pawn undefended when moved forward two squares. This
   results in the kind of intensely tactical games that Morphy or
   Anderssen played. 1. d4 in FIDE chess was very uncommon (Morphy only
   opened with 1. e4 and always responded to 1. e4 with 1. ... e5) and
   Morphy once said that the Sicilian results in "uninteresting games
   and dreary analytical labours".

   Schoolbook is designed to play sharp games where tactics is King (or
   at least checkmates the other King) and where games are interesting
   and never dreary, while keeping the general feel of FIDE games.

   The name "schoolbook" comes from the recent tradition of naming 8x10
   chess variants after fonts.

                                   Setup

   Schoolbook chess' opening setup is as follows:

   R Q N B A K B N M R
   P P P P P P P P P P
   - - - - - - - - - -
   - - - - - - - - - -
   - - - - - - - - - -
   - - - - - - - - - -
   p p p p p p p p p p
   r q n b a k b n m r


                                  Pieces

Names of the pieces

   R: Rook. Moves as a Chess rook; the only difference is in how this
   piece may castle.

   Q: Queen. Identical to a chess queen.

   N: kNight. Identical to a chess knight.

   B: Bishop. Identical to a chess bishop.

   K: King. Moves a a Chess king; object is to checkmate this piece. The
   only difference is how this piece castles.

   A: Archbishop. Has the combined moves of a knight and bishop.

   M: Marshall. Has the combined moves of a knight and rook.

Value of the pieces

   A lot of research has been done in determining the values of the
   pieces in 8x10 chess variants with the rook + knight and bishop +
   knight pieces. Schoolbook is able to utilize the fruits of this
   research.

   Here is a table of five different derived values for the pieces,
   obtained from three different chess variant playing computer programs
   and two other sources.

   +--------------------------------------------------------+
   | Piece      | ChessV | SMIRF | Zillions | Aberg | Nalls |
   |------------+--------+-------+----------+-------+-------|
   | Pawn       | 1.000  | 1.000 | 1.000    | 1.000 | 1.000 |
   |------------+--------+-------+----------+-------+-------|
   | Knight     | 2.500  | 3.053 | 2.362    | 3.000 | 3.077 |
   |------------+--------+-------+----------+-------+-------|
   | Bishop     | 3.250  | 3.500 | 2.859    | 3.300 | 3.535 |
   |------------+--------+-------+----------+-------+-------|
   | Rook       | 4.700  | 5.815 | 4.262    | 5.000 | 5.777 |
   |------------+--------+-------+----------+-------+-------|
   | Queen      | 8.750  | 9.617 | 7.060    | 9.000 | 9.312 |
   |------------+--------+-------+----------+-------+-------|
   | Archbishop | 6.500  | 6.858 | 5.127    | 6.800 | 6.612 |
   |------------+--------+-------+----------+-------+-------|
   | Marshall   | 8.250  | 8.870 | 6.659    | 8.700 | 8.854 |
   +--------------------------------------------------------+

   The ChessV numbers were obtained by looking at the source code for
   ChessV. The SMIRF values, derived by Reinhard Scharnagl for his SMIRF
   chess computer program, were obtained from this web page. The
   Zillions of Games' values were obtained by looking at the values of
   pieces by right-clicking on them after loading a fresh Schoolbook zrf
   file, and before moving any pieces. Aberg's figures come from the
   Chess variants server. Nalls' figures come from a document on his web
   page.

   All four agree on the following:

     * A bishop is about a half-pawn more valuable than a knight.
     * Two knights are worth more than a rook.
     * An archbishop is worth more than two knights.
     * A marshall is worth more than an archbishop.
     * A queen is worth more than a marshall.
     * Two rooks are worth more than a queen.
     * A marshall is worth more than a rook and knight.
     * A marshall is worth more than two bishops.
     * A rook and knight are worth more than an archbishop.

   The verdict is still out on some other exchanges:

     * A rook and bishop vs. a queen.
     * A rook and bishop vs. a marshall.
     * A bishop and knight vs. an archbishop.
     * Two bishops vs. an archbishop (Two bishops are probably worth
       more).

                                   Rules

   In Schoolbook 2.0, the king always moves three squares towards the
   corresponding rook when castling.

   Castling in the older Schoolbook 1.0 comes from Fergus Duniho's 
   Grotesque Chess: The king may castle two or three squares towards the 
   rook on the right hand side, and two, three, or four squares towards 
   the rook on the left hand side. The rook leaps over the king to land 
   besides the king. The king can not castle out of, through, or in to 
   check. Both the king and rook that the king castles with must not 
   have previously moved.

   The name of the rook + knight piece in Schoolbook is called the
   "marshall". The name of the bishop + knight piece in Schoolbook is
   called the "archbishop". Pawns may promote to become a rook, knight,
   bishop, archbishop, marshall, or queen, regardless of the number of
   pieces already on the board.

   The notation used for this game is standard algebraic opening, where
   the lower left corner is square a1, the upper right corner square j8,
   and 'A' signifies the Archbishop and 'M' signifies the Marshall. When
   no piece name is specified, a pawn is assumed to move. For example,
   f4 is the move that moves the King's pawn to the forth rank. When
   castling, only the King's move is noted, such as "Kh1" to signify
   that the king has moved to h1 and the rook to g1. In order to
   minimize the confusion between "i" and "j", the I file is always
   upper case in notation.

   The rules are otherwise as in FIDE chess.

                                   Notes

The opening

   The opening of Schoolbook has many similar themes to the opening of
   FIDE chess, since both games have the knights and bishops in the same
   position relative to the king in the opening setup. There are,
   however, a number of differences. For example:

     * Any opening that is dependent on the queen pawn (which has become
       the archbishop pawn in Schoolbook) being protected by the queen
       will not work in Schoolbook. This makes the center game, the
       center counter (Scandinavian game), the Scotch game, and so on
       not translate to Schoolbook. For example, the Schoolbook version
       of the Scotch just loses a pawn without compensation: 1. f4 f5 2.
       Ng3 Nd6 3. e4?? fxe4

     * The "Queen's gambit" does not translate to Schoolbook; this
       "gambit" depends on Black's queen rook being undefended in the
       opening array.

     * The Schoolbook equivalent of the Nimzovich defense (1. f4 Nd6) is
       more feasible here than it is in FIDE chess, since this defense
       delays white making an immediate e4 move.

     * Openings that take advantage of the weakness with the king bishop
       pawn in FIDE Chess do not work in Schoolbook. For example, the
       Damiano defense is feasible in Schoolbook chess: 1. f4 f5 2. Ng3
       g6 3. Nxf5?? gxf5 4. Ai5+ and now black can defend nicely with
       either Ag7 or h6 (since Af5+ is not a legal move), and white gets
       no compensation for the lost knight.

       While this change removes many of the opening traps enjoyed in
       FIDE chess, this is offset by the increased power of the pieces
       in Schoolbook chess.

   One good opening position for white is as follows:

   - - - b p p b - - -
   p - p n - a n m - -
   - p - p q - p p p p
   - - - - r r - - k -

   Black's goal is to stop this kind of opening setup. Considering the
   tactical power of all of the Schoolbook pieces, Black has many
   options to try and equalize.

   For example, the following moves stop 1. f4 from being followed by 2.
   e4: Nd6, Af6 (Problem: blocks Black's f pawn), Ad6 (Blocks black's
   best developing square for his queenside Knight), f5 (the King's pawn
   opening Schoolbook-style), d5 (Schoolbook's version of the Sicilian),
   and Ng6 (Schoolbook's version of the Alekine).

   Since Schoolbook has a higher branching factor than FIDE chess, rote
   memorization of openings is not as fruitful in Schoolbook as it is in
   FIDE chess. Since the general themes in Schoolbook are the same,
   players who understand the concepts behind a good opening in FIDE
   chess will feel right at home playing Schoolbook.

   More information about the Schoolbook opening can be found in the
   opening theory document.

Tactics

   A sense of Schoolbook's tactics can be gleamed by solving the
   included mating problems, which are not composed problems, but
   positions from actual games of Schoolbook.

Fool's mate

   The shortest possible game in Schoolbook is the following fool's
   mate: 1. f3 Ad6 2. Bf2?? Axh2#

   David Paulowich found the following 4-move mate that mates with a
   bishop: 1. e4 g6 2. f4 Kg7? 3. Bf2 Kh6?? 4. Bi5#

Intellectual property claims

   I make no intellectual property claims whatsoever with this (such as
   it is) invention.

Playing Schoolbook Chess

   This Zillions of Games implementation of Schoolbook chess requires
   the proprietary Zillions of game program available at
   www.zillions-of-games.com. Note that this implementation does not
   implement all of the rules of Schoolbook; in particular the "50 moves
   without a capture or pawn move is a draw" rule and the "insufficient
   mating material is a draw" rules are not implemented.

   I have made a Game Courier preset which is available on the
   chessvariants server at play.chessvariants.org.

   ChessV version 0.9 and later can also play Schoolbook. This is a free
   open-source Chess playing program for Windows.

