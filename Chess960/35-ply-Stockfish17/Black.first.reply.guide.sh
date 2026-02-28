#!/bin/sh

# Make a guide for Black’s best reply to each and every possible first
# move by White
SETUP="RNBQKBNR"
PAWNA='a2a3 b2b3 c2c3 d2d3 e2e3 f2f3 g2g3 h2h3'
#PAWNB='a2a4 b2b4 c2c4 d2d4 e2e4 f2f4 g2g4 h2h4'
PAWNB='a2a4 b2b4 c2c4 d2d4 f2f4 g2g4 h2h4'
KNIGHT='b1a3 b1c3 g1f3 g1h3'
for a in $PAWNA $PAWNB $KNIGHT ; do
  echo $a
  time lunacy ../Stockfish960Eval.lua $SETUP 35 20 $a | \
	tail -1 > $SETUP.$a.35ply.txt
done
