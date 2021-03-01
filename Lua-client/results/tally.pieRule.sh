#!/bin/sh

# Tally the results based on White's first move.  + is White win, - is Black
# win, = is draw

awk '{a=$(NF-1);
if(a ~ /White/){white[$2]++}
if(a ~ /Black/){black[$2]++}
if(a ~ /1\/2/){draw[$2]++}}
END {
for(a in white){print a " +"white[a]}
for(a in black){print a " -"black[a]}
for(a in draw) {print a " ="draw[a]}
}' | sort
