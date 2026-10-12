#!/bin/sh
cat R*txt >> scores.txt
grep -F '{' scores.txt | tr -d '\015' | sort -u > foo.$$
mv foo.$$ scores.txt

