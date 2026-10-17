#!/bin/sh

# Tally.sh, but standard input
fgrep '{' | cut -f2 -d{ | tr -d '\015' | tr -d } | awk '
{f=$1;if(f == "draw"){f="Draw"}a[f]++;n++}
END{
  print n " games played"
  print a["White"] " White wins"
  print a["Draw"] " Draws"
  print a["Black"] " Black wins"
  if(n > 0) {
  print ((a["White"] - a["Black"]) / n * 100) "% White winning edge"
  print ((a["White"] + (a["Draw"] / 2)) / n * 100) "% White score"
  print (a["White"] / (a["White"] + a["Black"]) * 100) "% White decisive wins"
 }
}'
