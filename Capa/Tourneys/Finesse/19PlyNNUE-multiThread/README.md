The file `scores.txt` has the results of running a large number of Finesse
chess games.  Process this file to get information about how well various
openings work in Finesse.

Other files here:

* `1line-tally.sh` Run this script against scores.txt to get White/Draw/Black
  win counts
* `Play.lua` This is a Lunacy (not stock Lua 5.1 becuase it uses the
  spawner library to run Fairy Stockfish) script which has Stockfish play
  itself Finesse Chess
* `runTourney.sh` This is the script to run the tournament
* `tally.sh` This gives a longer summary of `scores.txt`

To generate `scores.txt`:

* Make sure one has a POSIX compliant environment (Linux, Windows with
  Cygwin/WSL/etc., MacOS, etc.)
* Make sure one has the Lunacy Lua 5.1 variant, which is available at
  [https://github.com/samboy/lunacy](https://github.com/samboy/lunacy)
* Make sure one has the file `capablanca-bb644ef32758.nnue` in this
  folder.
* `./runTourney.sh 123` where `123` is a three digit number (if running 
  multiple at the same time, make sure each number is different)
* Wait a few hours or days (the more games, the better)
* There will be files with names like `RNABCKBQNR-XXX-YYY-19ply.txt` where
  XXX is a number that increases, and YYY is the three digit number given
  to `runTourney.sh`
* `cat RNABCKBQNR*txt | tr -d '\015' > scores.txt`

To tally `scores.txt`:

* ./tally.sh scores.txt

The file `capablanca-bb644ef32758.nnue` has the following cryptographic
sums:

```
53e10b9a18d5a0e1892f6d13a95d03b10ceb4721f3e05be174a9d3d6b157c81a RadioGatún[32]
bb644ef32758eb8e1e6d795226290ec2c816beee479c8cd82939aa5f53517732 SHA-256
```

