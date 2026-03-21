#!/bin/sh

N=1
SETUP="$1"
if [ -z "$SETUP" ] ; then
  # Finesse chess is default
  SETUP=RNABCKBQNR
fi
FILE=${SETUP}-240-1/${SETUP}-${N}-Chess18PlyNNUE.txt
while [ -e "$FILE" ] || [ -e "${FILE}.xz" ] ; do
  N=$(( $N + 1 ))
  FILE=${SETUP}-240-1/${SETUP}-${N}-Chess18PlyNNUE.txt
done
echo $FILE
COUNT="$2"
if [ -z "$COUNT" ] ; then
  COUNT=500
fi
A=1 
while [ $A -le $COUNT ] ; do 
	echo $A; A=$(( $A + 1 )); 
	lunacy FinessePlayJoker80.lua $SETUP 240 1 >> $FILE 
	sleep 3
done

