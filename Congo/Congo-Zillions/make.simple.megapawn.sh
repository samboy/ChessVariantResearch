#!/bin/sh

# Unzip needed to extract the congo.zip file

#rm -fr Congo congo-megapawn
unzip congo.zip
cd Congo
head -562 Congo.zrf > foo
mv foo Congo.zrf

# Make A4/B4/F4/G4 "islands" where one does not drown
patch < ../Congo.zrf.islands.patch

# Add a variant with a different setup and a very powerful "Megapawn"
cat ../megapawn.txt >> Congo.zrf

mv Congo.zrf congo-megapawn.zrf

cd ..
mv Congo congo-megapawn
