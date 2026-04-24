#!/bin/sh

# Make sure capablanca-bb644ef32758.nnue is here
COUNTER=1
GROUP=$( echo $COUNTER | awk '{print sprintf("%03d",$0)}' )
SETUP=RNABCKBQNR
PLY=19
while : ; do
	GROUP=$( echo $COUNTER | awk '{print sprintf("%03d",$0)}' )
	lunacy64 ./Play.lua \
		--play ${SETUP} \
		$PLY 5 > ${SETUP}-${GROUP}-${PLY}ply.txt
	if [ "$?" == "1" ] ; then
	  echo Warning: Exit with non 0 exit code
	  echo Is capablanca-bb644ef32758.nnue here?
	fi
	echo $COUNTER
	COUNTER=$(( $COUNTER + 1 ))
done
