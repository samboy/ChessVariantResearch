#!/bin/sh

N=1
OPENING="c4-c6"
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
	lunacy PlayChess18-opening.lua 'c2c4 c7c6' 18 RBBQKNNR >> $FILE 
	sleep 3
done


