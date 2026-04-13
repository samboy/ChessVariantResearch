#!/bin/sh

N=1
OPENING="Evans"
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
	lunacy PlayClassicChess-opening.lua 'e2e4 e7e5 g1f3 b8c6 f1c4 f8c5 b2b4' >> $FILE 
	#lunacy PlayClassicChess-opening.lua 'e2e4 e7e5 g1f3 b8c6 f1c4 f8c5 b2b4' | grep { >> $FILE 
	sleep 3
done


