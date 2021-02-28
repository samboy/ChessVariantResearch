To run a tourney looking at all 20 possible first White moves in
regular Chess, run this script:

```
rm log
rm results.current
./run.pie.tourney
```

Note: Lunacy is needed to run the script.  Lunacy is available here:

https://github.com/samboy/lunacy

https://git.sr.ht/~samiam/Lunacy

The output is placed in the file `results.current`, one line per game 
after the game ends.  `log` has a verbose log of each Chess move made.
