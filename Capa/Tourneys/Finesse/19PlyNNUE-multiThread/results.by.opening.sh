#!/bin/sh

# This needs the non-standard Perl tool
cat scores.txt | perl -pe 's/\([^)]+\)//g' | awk '
  /White/{White[$2]++} /Black/{Black[$2]++} /draw/{Draw[$2]++} 
  END {for(a in White){
  total = White[a] + Draw[a] + Black[a]
  total = total / 100
  w = White[a]
  d = Draw[a]
  b = Black[a] 
print a " " w "/" d "/" b 
print a " " w/total "/" d/total "/" b/total
}}'

