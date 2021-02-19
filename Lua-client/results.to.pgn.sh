#!/bin/sh

# This doesn't generate "correct" PGN, but Winboard will import this
# PGN and output a correct PGN file from it.
N=1
head -$N results.current | \
	tail -1 | \
	perl -pe '
	s/\([^)]*\)\s*//g;
	s/([a-h][1-8][a-h][1-8][a-z]? [a-h][1-8][a-h][1-8][a-z]?) /\1\n/g;
	' | \
	awk '{a++;print a ". " $0}' > $N-pre.pgn
