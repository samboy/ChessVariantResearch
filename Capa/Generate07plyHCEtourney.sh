#!/bin/sh

SETUP="$1"
if [ -z "$SETUP" ] ; then
  # Embassy chess is default
  SETUP = RNBACKQBNR
fi
A=1 
while [ $A -le 500 ] ; do 
	echo $A; A=$(( $A + 1 )); 
	lunacy FinessePlayXboard.lua $SETUP >> ${SETUP}Chess07PlyHCE.txt; 
	echo 'Game ended' >> ${SETUP}Chess07PlyHCE.txt; sleep 3 
done


