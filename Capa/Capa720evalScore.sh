#!/bin/sh

# Rank Capa720 setups, but ties all have same rank

cat Capa720evalNNUE21ply.txt  | tr -d '\015' | awk '
  {print $3 " " $0 " " ++a}' | sort -n | awk '
  {n++;score=$1;if(score != oldscore){show=n}print $0 " " show;oldscore=score}'
