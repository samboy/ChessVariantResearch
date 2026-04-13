#!/bin/sh

GROUP=02
SETUP=RNABCKBQNR

for PLY in 07 08 09 10 11 12 13 14 15 ; do 
	lunacy64 ../../../../EvalOrPlay.lua \
		--play ${SETUP} \
		$PLY 5 > ${SETUP}-${GROUP}-${PLY}ply.txt
done
