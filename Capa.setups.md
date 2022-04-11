This is a table showing the porportion of White wins, Black wins, and
draws for various possible Capablanca Chess opening setups.  In this
table, the line shows the back row opening setup: RNBQK are the same 
as in English language Chess algebraic notation.  C is Rook + Knight, 
and A is Bishop + Knight.

Around a dozen games with Fairy Stockfish playing at a very high 
level (21 ply search per move) were played for each variant; some 
randomization of moves was done via 3-way “MultiPV” evaluation 
and randomly choosing a move within half a pawn in value compared to
the best move.

The results:

|Opening setup|White Wins|Black Wins|Draws|
|:-|:-|:-|:-|
|RBNCAKQNBR|0.4|0.6|0|
|RNBCAKQBNR|0.4|0.6|0|
|RNBACKQBNR (Embassy)|0.3|0.5|0.2|
|RNBCQKABNR (Bird)|0.2|0.5|0.3|
|RQNBAKBNCR (Schoolbook)|0.545455|0.454545|0|
|RANBCKBNQR|0.181818|0.454545|0.363636|
|RNBQCKABNR (Gothic)|0.5|0.4|0.1|
|RBNAQKCNBR|0.4|0.4|0.2|
|RNBQAKCBNR|0.2|0.4|0.4|
|RNBAQKCBNR|0.7|0.3|0|
|RBNQAKCNBR|0.5|0.3|0.2|
|RCNBAKBNQR|0.545455|0.272727|0.181818|
|RQNBCKBNAR|0.454545|0.272727|0.272727|
|RBNQCKANBR|0.555556|0.222222|0.222222|
|RBNCQKANBR (Univers)|0.6|0.2|0.2|
|RBNACKQNBR|0.4|0.2|0.4|
|RANBQKBNCR (Carrera)|0.636364|0.181818|0.181818|
|RCNBQKBNAR (Murray-Carrera)|0.636364|0.0909091|0.272727|

The raw score for all played games is available in the file
`Capa-tourney-results` in the directory `Lua-client/results`.
