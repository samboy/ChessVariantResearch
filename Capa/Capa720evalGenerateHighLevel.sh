#!/bin/sh

# This script evaluates all 720 Capa720 positions to see white’s 
# centipawn advantage

CAPATHREESIX="$2"
WINNERS="$3"
PLIES="$1"

for setup in $( 
	lunacy Capa720Study.lua $CAPATHREESIX $WINNER | awk '
		{print toupper($1)}' ) ; do
  #echo $setup
  lunacy SchoolMarshallEval.lua $setup $PLIES | tail -1 
done
