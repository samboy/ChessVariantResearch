#!/bin/sh

# Tally xboard interface (HCE) games

FILENAME="$1"
if [ -z "$FILENAME" ] ; then
  FILENAME=Finesse12PlyHCE.txt.xz
fi
COMMAND=cat
if echo $FILENAME | grep -F .xz > /dev/null ; then
  COMMAND=xzcat
fi
COUNT="$2"
if [ -n "$COUNT" ] ; then
  $COMMAND '{' $FILENAME | head -$COUNT > foo-$$
  FILENAME="foo-$$"
fi

LINE=$( $COMMAND $FILENAME | fgrep '{' | cut -f2 -d{ | \
	tr -d '\015' | tr -d } | awk '
{a[$1]++;n++}END{
print n " games - "
print a["White"] / n * 100 "/" a["draw"] / n * 100 "/" a["Black"] / n * 100
#print ((a["White"] - a["Black"]) / n * 100) "% White edge - "
#print ((a["White"] + (a["Draw"] / 2)) / n * 100) "% Score - "
#print a["Draw"] / n * 100 "% Draw"
print (a["White"] / (a["White"] + a["Black"]) * 100) "% White decisive wins"
}' )

#SETUP=$( echo $FILENAME | cut -f1 -d- )
#echo $SETUP $LINE
echo $LINE

rm -f foo-$$
