Freeling Chess: Based on a couple of Chess Variants Freeling invented,
this implements his idea to:

* Have the Rooks be on the first rank, in the corners
* Have the other pieces be on the second rank
* Pawns on the third rank
* The King cannot castle

For corner rooks and mirror symmetry, we only have 54 setups, but we
can also flip only Black’s pieces left to right to get 108 setups.

The “mirror” setups (where Black’s pieces are flipped) tend to be less 
balanced.

Here is the most balanced “Freeling” setup:

```
r------r
-qbknbn-
pppppppp
--------
--------
PPPPPPPP
-QBKNBN-
R------R
```

Best moves: e4 (+9), d4 (+8), h4 (+8), Rad1 (+8)
Pie rule moves: a4 (0), Rhf1 (0)

