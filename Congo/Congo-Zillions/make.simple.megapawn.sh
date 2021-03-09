#!/bin/sh

# Unzip needed to extract the congo.zip file

unzip congo.zip
cd Congo

# Make A4/B4/F4/G4 "islands" where one does not drown
patch < ../Congo.zrf.islands.patch

# Add a variant with a different setup and a very powerful "Megapawn"
cat ../megapawn.txt >> Congo.zrf

mv Congo.zrf congo-megapawn.zrf

cd ..
mv Congo congo-megapawn
tar cvzf congo-megapawn.tar.gz congo-megapawn
