#!/bin/sh

SETUP="$1"
if [ -z "$SETUP" ] ; then
  # Embassy chess is default
  SETUP=RNBACKQBNR
fi
COUNT="$2"
if [ -z "$COUNT" ] ; then
  COUNT=100
fi
cp ../capablanca-bb644ef32758.nnue .
A=1 
while [ $A -le $COUNT ] ; do 
	echo $A; A=$(( $A + 1 )); 
	lunacy FinessePlayXboard.lua $SETUP >> ${SETUP}-Chess07PlyHCE.txt; 
	echo 'Game ended' >> ${SETUP}-Chess07PlyHCE.txt; sleep 3 
done


