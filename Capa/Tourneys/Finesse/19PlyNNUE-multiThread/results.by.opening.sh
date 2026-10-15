#!/bin/sh

# This needs the non-standard Perl tool
cat scores.txt | perl -pe 's/\([^)]+\)//g' | awk '
  /White/{White[$2]++} /Black/{Black[$2]++} /draw/{Draw[$2]++} 
  END {for(a in White){
print a " " White[a] "/" Draw[a] "/" Black[a] " " White[a] + Draw[a] + Black[a]
}}'

