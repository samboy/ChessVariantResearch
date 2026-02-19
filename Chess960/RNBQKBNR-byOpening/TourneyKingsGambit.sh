#!/bin/sh

N=1
SETUP="$1"
if [ -z "$SETUP" ] ; then
  # Finesse chess is default
  SETUP=RNABCKBQNR
fi
OPENING="KingsGambit"
FILE=${OPENING}/${OPENING}-${N}-Chess18PlyNNUE.txt
while [ -e "$FILE" ] || [ -e "${FILE}.xz" ] ; do
  N=$(( $N + 1 ))
  FILE=${OPENING}/${OPENING}-${N}-Chess18PlyNNUE.txt
done
echo $FILE
COUNT="$2"
if [ -z "$COUNT" ] ; then
  COUNT=100
fi
A=1 
while [ $A -le $COUNT ] ; do 
	echo $A; A=$(( $A + 1 )); 
	lunacy PlayClassicChess-opening.lua 'e2e4 e7e5 f2f4' >> $FILE 
	#lunacy PlayClassicChess-opening.lua 'e2e4 e7e5 f2f4' | grep { >> $FILE 
	sleep 3
done


