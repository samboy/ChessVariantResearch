#!/bin/sh

# Tally xboard interface (HCE) games

FILENAME="$1"
if [ -z "$FILENAME" ] ; then
  FILENAME=Finesse12PlyHCE.txt.xz
fi
COMMAND=cat
if echo $FILENAME | grep -F .xz ; then
  COMMAND=xzcat
fi
COUNT="$2"
if [ -n "$COUNT" ] ; then
  $COMMAND '{' $FILENAME | head -$COUNT > foo-$$
  FILENAME="foo-$$"
fi

$COMMAND $FILENAME | fgrep '{' | cut -f2 -d{ | tr -d '\015' | tr -d } | awk '
{f=$1;if(f == "draw"){f="Draw"}a[f]++;n++}
END{
  for(b in a){print b " " a[b] " " a[b]/n*100 "%"}
  print n " games played";
  print ((a["White"] - a["Black"]) / n * 100) "% White winning edge"
  print ((a["White"] + (a["Draw"] / 2)) / n * 100) "% White score"
  print (a["White"] / (a["White"] + a["Black"]) * 100) "% White decisive wins"
}'

rm -f foo-$$
