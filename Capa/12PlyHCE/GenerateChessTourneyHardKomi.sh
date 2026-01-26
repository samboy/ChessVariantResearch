#!/bin/sh

N=1
SETUP="$1"
if [ -z "$SETUP" ] ; then
  SETUP=RNBQKBNR
fi
FILE=${SETUP}-hardKomi/${SETUP}-${N}-Chess12PlyNNUE.txt
while [ -e "$FILE" ] || [ -e "${FILE}.xz" ] ; do
  N=$(( $N + 1 ))
  FILE=${SETUP}-hardKomi/${SETUP}-${N}-Chess12PlyNNUE.txt
done
echo $FILE
COUNT="$2"
if [ -z "$COUNT" ] ; then
  COUNT=500
fi
A=1 
while [ $A -le $COUNT ] ; do 
	echo $A; A=$(( $A + 1 )); 
	lunacy PlayClassicChessUCI-hardKomi.lua $SETUP >> $FILE 
	#lunacy PlayClassicChessUCI-hardKomi.lua | grep { >> $FILE 
	sleep 3
done


