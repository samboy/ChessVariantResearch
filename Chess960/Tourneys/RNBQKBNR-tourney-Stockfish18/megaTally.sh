#!/bin/sh

# Make a chart with tallies for all plies

for a in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 ; do 
	echo -n ${a}' ' 
	./1line-tally.sh RNBQKBNR-01-${a}ply.txt.xz 
done
