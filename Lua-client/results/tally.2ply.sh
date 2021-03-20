#!/bin/sh

# Tally the results based on White's first move.  + is White win, - is Black
# win, = is draw

perl -pe 's/\([^)]*\)//g' | awk '{a=$(NF-1);
opening = $1 " " $2
if(a ~ /White/){white[opening]++ ; score[opening]++}
if(a ~ /Black/){black[opening]++ ; score[opening] += 0}
if(a ~ /1\/2/){draw[opening]++ ; score[opening] += 0.5 }
total[opening]++
}
END {
for(a in white){print a " +"white[a]}
for(a in black){print a " -"black[a]}
for(a in draw) {print a " ="draw[a]}
for(a in score) {print a " result: " (score[a] / total[a]) * 100 "%"}
for(a in draw) {print a " draws: " (draw[a] / total[a]) * 100 "%"}
}' | sort
