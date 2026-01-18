#!/bin/sh

FILENAME="$1"
if [ -z "$FILENAME" ] ; then
  FILENAME="Capa720evalNNUE21ply.txt"
fi

# Rank Capa720 setups, but ties all have same rank

cat $FILENAME | tr -d '\015' | awk '
  {print $3 " " $0}' | sort -n | awk '
  {n++;score=$1;if(score != oldscore){show=n}print $0 " " show;oldscore=score}'
