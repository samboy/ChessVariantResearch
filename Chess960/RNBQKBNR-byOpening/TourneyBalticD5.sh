#!/bin/sh

N=1
OPENING="BalticD5"
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
	lunacy PlayClassicChess-opening.lua 'b1c3 d7d5' >> $FILE
	sleep 3
done


