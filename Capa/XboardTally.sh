#!/bin/sh

# Tally xboard interface (HCE) games

FILENAME="$1"
if [ -z "$FILENAME" ] ; then
  FILENAME=Finesse12PlyHCE.txt.xz
fi
COMMAND=grep
if echo $FILENAME | grep -F .xz ; then
  COMMAND=xzgrep
fi

$COMMAND '{' $FILENAME | cut -f2 -d{ | tr -d '\015' | tr -d } | awk '
{a[$1]++;n++}END{for(b in a){print b " " a[b] " " a[b]/n*100 "%"}print n;
print ((a["White"] - a["Black"]) / n * 100) "% White winning edge"
print ((a["White"] + (a["Draw"] / 2)) / n * 100) "% White score"
}'

