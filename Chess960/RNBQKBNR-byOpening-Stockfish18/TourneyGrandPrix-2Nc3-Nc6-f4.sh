#!/bin/sh

N=1
OPENING="GrandPrix-e4-c5-Nf3-Nc6-f4"
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
	lunacy PlayClassicChess-opening.lua 'e2e4 c7c5 b1c3 b8c6 f2f4' >> $FILE 
	sleep 3
done


