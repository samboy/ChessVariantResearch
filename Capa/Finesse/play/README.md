# Files here

These are data files to play Finesse Chess with three different Chess
Variant/abstract game engines, as well as a link to play it online.

## FinesseChess.mgl

Ai Ai is a “free beer” abstract game engine written in Java which
can play a wide variety of abstract games, including a number of Chess
variants.  It’s possible to play on other grids, and it plays a lot
of non-Chess games well, but it’s not as flexible as Zillions is with
defining new games.

In terms of strength, Ai Ai plays about as well as a 1500 or so Chess
player with its default settings of using 1-2 seconds to come up with
a move.  Unlike other generalized game engines, Ai Ai can also evaluate
any game it supports, and it has the ability to generate puzzles for
any abstract game it supports (this process took 3-4 hours or so
to generate 12 puzzles with Finesse Chess, and the progress bar isn’t
very good about showing progress).

[FinesseChess.mgl](FinesseChess.mgl) is a file to be used by Ai Ai.  As I 
type this, the latest version of Ai Ai is available here:

>[http://mrraow.com/index.php/aiai-home/](http://mrraow.com/index.php/aiai-home/)

To install, put this `.mgl` file in the `mgl/ChessFamily/Chess/Modern/`
folder below the root of Ai Ai.

The license is probably the same license that AiAi uses.

## FinesseChessZ.7z

[FinesseChessZ.7z](FinesseChessZ.7z) is a Zillions of Games implementation of 
Finesse Chess, as well as 23 other variants, including Classic 
Chess, four other Capablanca setups, etc.

Zillions of Games is a formerly commerical abstract game engine which 
is optimized to play Chess-like games well.  It is still closed source,
but the game is now donationware.  It runs well in Windows 11 and 
reasonably well in Wine on x86 computers (or computers with a reasonable
32-bit x86 emulator).

Zillions of Games is a remarkably strong Chess engine, playing about
as strongly as a National Master (2000 or so) at full strength,
and it’s the most flexible Abstract Games engine I know of.
It uses its own Lisp-like language to define game rules, and
allows arbitrary pieces to be added, and can work on arbitrary
grids; e.g. I have a Zillions file which works with [Turtle Shell
Chess](https://www.chessvariants.com/invention/turtleshellchess).

The supplied file will open without issue in Windows 11.

If using Windows 10 or another OS which does not understand `.7z` 
files, 7-zip is available at https://7-zip.org/

To use the .zrf file, do this:

* Use Windows (it *might* work in Wine, your mileage will vary)
* Install Zillions of Games available over at 
  [https://zillions-of-games.com/](https://zillions-of-games.com/)
* Get a license (donationware, pay what you can)
* Extract the [FinesseChessZ.7z](FinesseChessZ.7z) file
* In the extracted `FinesseChessZ` folder, open up `FinesseChess.zrf`
* A Classic Chess board will open.  
* To play Finesse instead, go to Variant → Finesse.

## Finesse.sgf

[Finesse.sgf](Finesse.sgf) is a data file for ChessV 0.94 (probably 0.95).

ChessV is an open source (GPL licensed) Chess variant engine for 
Windows.  It is restricted to playing a limited number of Chess 
variants on various square grids, but its playing strength is 
stronger than Zillions or AiAi, playing about as strong as
a FIDE Master (somewhere in the 2200 to 2400 ballpark) at full 
strength.

To use the [Finesse.sgf](Finesse.sgf) file, download [ChessV 
0.94](https://samiam.org/chessv/) and place
`Finesse.sgf` in the `include/` directory, then choose
“Load game” after starting up ChessV 0.94.

## Playing online over at PyChess

To play Finesse Chess online:

* Go to [the page to edit Capablanca 
  Chess](https://www.pychess.org/editor/capablanca)
* Type in the box at the bottom the FEN for Finesse Chess

```
rnabckbqnr/pppppppppp/10/10/10/10/PPPPPPPPPP/RNABCKBQNR w KQkq - 0 1
```

* To analyze the position, click on “Analysis Board” (the microscope)
* To play the machine, click on “Play with Machine” (the gears)
* To play a human, click on “Continue from here” (the swords)
* To play at correspondence speeds, one will need to sign in to Pychess
  first.  Lichess accounts work at Pychess.

