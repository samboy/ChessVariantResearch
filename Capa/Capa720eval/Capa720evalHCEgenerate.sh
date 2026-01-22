#!/bin/sh

# This script evaluates all 720 Capa720 positions to see white’s 
# centipawn advantage

touch Capa720evalHCE07ply.txt
for setup in $( lunacy Capa720Setups.lua | awk -F/ '{print toupper($1)}' ) ; do
  echo $setup
  lunacy HCE7plyEval.lua $setup | tail -1 >> Capa720evalHCE07ply.txt
done
