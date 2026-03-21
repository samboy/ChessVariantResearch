Finesse chess is a variant I made back in 2008: 

https://archive.ph/20090923161739/https://maradns.blogspot.com/2008/12/capa-opening-setups.html

This setup, RNABCKBQNR (it was RNQBKMBANR in the original 2008 proposal,
but “M” has been replaced by “C”, and the pieces have been flipped 
left-to-right because Capa720 has the king on the f file), according to
Fairy Stockfish, is one of the most balanced Capa720 setups out there
(#3 most balanced) even though I created this variant long before NNUE
evaluation and strong chess variant engines existed.

Since a lot of other variants I proposed at the time were a lot less
balanced, the fact that this proposal is so balanced is blind luck.

To see how balanced it is, open up Fairy Stockfish in this directory then:

```
setoption name MultiPV value 3
setoption name UCI_Variant value capablanca
setoption name EvalFile value capablanca-bb644ef32758.nnue
setoption name Use NNUE value true
ucinewgame
position fen rnabckbqnr/pppppppppp/10/10/10/10/PPPPPPPPPP/RNABCKBQNR w KQkq - 0
1
d
go depth 12
position fen rnabckbqnr/pppppppppp/10/10/10/10/PPPPPPPPPP/RNABCKBQNR w KQkq - 0 1 moves g2g4
d
```

