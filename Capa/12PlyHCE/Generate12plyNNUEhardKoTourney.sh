#!/bin/sh

N=1
SETUP="$1"
if [ -z "$SETUP" ] ; then
  # Finesse chess is default
  SETUP=RNABCKBQNR
fi
FILE=${SETUP}-hardKo/${SETUP}-${N}-Chess12PlyNNUE.txt
while [ -e "$FILE" ] || [ -e "${FILE}.xz" ] ; do
  N=$(( $N + 1 ))
  FILE=${SETUP}-hardKo/${SETUP}-${N}-Chess12PlyNNUE.txt
done
echo $FILE
COUNT="$2"
if [ -z "$COUNT" ] ; then
  COUNT=500
fi
cp ../capablanca-bb644ef32758.nnue .
A=1 
while [ $A -le $COUNT ] ; do 
	echo $A; A=$(( $A + 1 )); 
	lunacy Play12plyUCI-hardKo.lua $SETUP >> $FILE 
	#lunacy Play12plyUCI-hardKo.lua $SETUP | grep { >> $FILE 
	sleep 3
done


