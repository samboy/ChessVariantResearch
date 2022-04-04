#!/bin/sh

# Make a release of the Zillions version of Turtle Shell Chess

# Requires: unix2dos zip
# Optional: advdef (advzip, etc.)

HERE=$( /bin/pwd )
if [ ! -e "$HOME/tmp" ] ; then
  mkdir $HOME/tmp
  echo Directory $HOME/tmp made
fi
if [ ! -e Zillions ] ; then
  echo Zillions not found\; aborting
  exit 1
fi

mkdir $HOME/tmp/$$
VERSION=$( date +%Y-%m-%d-%H%M )
DIR=$HOME/tmp/$$/TurtleShellZillions-$VERSION
mkdir $DIR
mkdir $DIR/images
mkdir $DIR/images/TurtleShellChess/
cp Zillions/images/TurtleShellChess/*bmp $DIR/images/TurtleShellChess/
cp Zillions/TurtleShell.zrf $DIR
cp Zillions/TurtleShell.txt $DIR/ReadMe.txt
cp TurtleShellRules*pdf $DIR/TurtleShell.pdf
echo Version $VERSION >> $DIR/TurtleShell.txt
echo \; Version $VERSION >> $DIR/TurtleShell.zrf
unix2dos $DIR/TurtleShell.txt
unix2dos $DIR/TurtleShell.zrf
cd $HOME/tmp/$$
zip -r TurtleShellZillions-${VERSION}.zip TurtleShellZillions-$VERSION
advzip -z -4 TurtleShellZillions-${VERSION}.zip
cp TurtleShellZillions-${VERSION}.zip $HERE
echo TurtleShellZillions-${VERSION}.zip made
rm -fr $HOME/tmp/$$
