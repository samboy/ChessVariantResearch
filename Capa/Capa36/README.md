# Capa36

Capa36 is a variant of Capablanca Chess where:

* We place the rooks in the corners
* We place the King on the “f” file
* The knights and bishops are symmetrical

I listed [some Capa setups back in
2008](https://archive.ph/20090923161739/https://maradns.blogspot.com/2008/12/capa-opening-setups.html)
and I observed back then that all of the setups had the three above
characteristics. [1]

[1] Some of the setups have the rooks on the b and i files instead of
in the corners, but the rooks are usually in the corners.

## Ranking the setups

Back in 2008, computers able to play Capablanca setups were not strong
enough to effectively analyze opening setups, so we used a bunch of
heuristics such as “All pawns guarded in the opening” to try and find 
the best opening setup.

Here in 2026, we have had, since 2022, a NNUE file for Capablanca Chess
which allows very high quality analysis of Capablanca Chess positions.
I have used this to analyze all 36 Capa36 setups, at a depth up to
30 ply.  

I have analyzed all 36 setups at a depth of 18 plies, 19 plies, and so on
up until 30 plies, then I weighted the setups, giving more plies more
weight that fewer plies.  In addition, I look at the mean and median for
every evaluation between 18 and 30 plies.

Here are the results:

```
Weighted avg    Mean    Median  Setup
17.32           17.54   16      RNABCKBQNR      (Finesse)
21.32           18.23   12      RCBNQKNBAR
21.63           23.46   27      RQBNCKNBAR
23.46           24.77   23      RABNQKNBCR
23.67           24.15   24      RNBAQKCBNR      (Capa1)
24.93           24.46   25      RBNAQKCNBR
25.11           23.54   20      RBANCKNQBR      (Grotesque)
27.15           26.69   27      RNBQCKABNR      (Trice)
27.37           29.85   30      RNQBCKBANR      (Blackbook)
27.63           30.15   31      RBNQAKCNBR
29.55           28.69   28      RQBNAKNBCR
29.96           32.08   32      RNCBAKBQNR
30.88           34.15   31      RBCNQKNABR
31.64           30.77   29      RNCBQKBANR      (Nalls)
32.87           32.31   31      RCBNAKNBQR
33.15           35.00   31      RBCNAKNQBR      (Landorian)
34.97           37.54   36      RBNACKQNBR
35.14           33.85   33      RABNCKNBQR
35.27           31.54   32      RBANQKNCBR
37.40           38.38   37      RBQNAKNCBR
37.92           36.62   34      RBNQCKANBR
38.04           34.62   36      RNABQKBCNR      (Capa2)
40.36           41.77   42      RCNBQKBNAR      (MurrayCarrera)
40.92           41.69   42      RNQBAKBCNR
41.21           43.38   45      RANBCKBNQR      (Narcotic)
42.02           39.85   39      RBQNCKNABR
42.85           40.77   36      RCNBAKBNQR      (Notebook)
43.53           42.00   40      RBNCQKANBR      (Univers)
43.65           44.77   43      RNBCQKABNR      (Bird)
43.68           42.15   41      RQNBAKBNCR      (Schoolbook)
45.07           44.23   46      RBNCAKQNBR
46.91           48.08   45      RNBQAKCBNR      (Teutonic)
48.09           46.62   43      RNBACKQBNR      (Embassy)
51.90           48.46   47      RANBQKBNCR      (Carrera)
62.36           59.23   60      RNBCAKQBNR      (Consulate)
89.14           91.23   94      RQNBCKBNAR
```

Individual files: [18 ply](18ply.txt) - [19 ply](19ply.txt) - [20](20ply.txt) -
[21](21ply.txt) - [22](22ply.txt) - [23](23ply.txt) - [24](24ply.txt) -
[25](25ply.txt) - [26](26ply.txt) - [27](27ply.txt) - [28](28ply.txt) -
[29](29ply.txt) - [30](30ply.txt)

