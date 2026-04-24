#!/bin/sh

COUNTER=1
GROUP=$( echo $COUNTER | awk '{print sprintf("%03d",$0)}' )
SETUP=RNABCKBQNR
PLY=19
while : ; do
	GROUP=$( echo $COUNTER | awk '{print sprintf("%03d",$0)}' )
	lunacy64 ./Play.lua \
		--play ${SETUP} \
		$PLY 5 > ${SETUP}-${GROUP}-${PLY}ply.txt
	echo $COUNTER
	COUNTER=$(( $COUNTER + 1 ))
done
