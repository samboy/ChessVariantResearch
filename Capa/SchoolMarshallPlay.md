In fairy-stockfish

```
setoption name MultiPV value 3
setoption name UCI_Variant value capablanca
setoption name EvalFile value capablanca-bb644ef32758.nnue
setoption name Use NNUE value true
ucinewgame
position fen rqnbakcnbr/pppppppppp/10/10/10/10/PPPPPPPPPP/RQNBAKCNBR w KQkq - 0 1
d
go depth 7
position fen rqnbakcnbr/pppppppppp/10/10/10/10/PPPPPPPPPP/RQNBAKCNBR w KQkq - 0 1 moves g2g4
```

The output of go will have lines like this:

```
info depth 7 seldepth 7 multipv 1 score cp 55 nodes 14047 nps 144814 tbhits 0 time 97 pv g2g4 h8i6 e2e4 c7c6 d2d4
info depth 7 seldepth 7 multipv 2 score cp 55 nodes 14047 nps 144814 tbhits 0 time 97 pv e2e4 c7c6 d2d4 h8i6 g2g4
info depth 7 seldepth 7 multipv 3 score cp 30 nodes 14047 nps 144814 tbhits 0 time 97 pv e2e3 h8i6 g2g4 c7c6 c1e2 c8d6
```

Using xboard protocol:

```
xboard
variant capablanca
setboard rqnbakcnbr/pppppppppp/10/10/10/10/PPPPPPPPPP/RQNBAKCNBR w KQkq - 0 1
analyze
```

