#!/bin/sh

SET=02

for PLY in 07 08 09 10 11 12 13 14 15 ; do 
	lunacy64 ../../../EvalOrPlay.lua --play ${SETUP} \
		$PLY 5 > ${SETUP}-${SET}-${PLY}ply.txt
done
