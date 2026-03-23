#!/bin/sh
_rem=--[=[

LUNACY=""
if command -v lunacy64 >/dev/null 2>&1 ; then
  LUNACY=lunacy64
elif command -v lua5.1 >/dev/null 2>&1 ; then
  LUNACY=lua5.1
elif command -v lua-5.1 >/dev/null 2>&1 ; then
  LUNACY=lua-5.1
elif command -v lunacy >/dev/null 2>&1 ; then
  LUNACY=lunacy
elif command -v luajit >/dev/null 2>&1 ; then
  LUNACY=luajit # I assume luajit will remain frozen at Lua 5.1
fi
if [ -z "$LUNACY" ] ; then
  echo Please install Lunacy or Lua 5.1
  echo https://github.com/samboy/lunacy
  exit 1
fi

exec $LUNACY $0 "$@"

# ]=]1
-- This script is written in Lua 5.1

-- This script has been donated to the public domain in 2026 by Sam Trenholme
-- If, for some reason, a public domain declation is not acceptable, it
-- may be licensed under the following terms:

-- Copyright 2026 Sam Trenholme
-- Permission to use, copy, modify, and/or distribute this software for
-- any purpose with or without fee is hereby granted.
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
-- WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
-- OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
-- ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
-- WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
-- ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
-- OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-- Utility functions --
-- Since Lunacy doesn't have split(), we make
-- it ourselves.  Like Perl’s split(), this can
-- split on regular expressions
-- Input is string, regex, output is an array with the string parts
function split(s, splitOn)
  if not splitOn then splitOn = "," end
  local place = true
  local out = {}
  local mark
  local last = 1
  while place do
    place, mark = string.find(s, splitOn, last, false)
    if place then
      table.insert(out,string.sub(s, last, place - 1))
      last = mark + 1
    end
  end
  table.insert(out,string.sub(s, last, -1))
  return out
end

-- We need to go through tables in sorted order sometimes
-- Like pairs() but sorted
-- This assumes all keys are of the same type
function sPairs(inputTable,sFunc)
  if not sFunc then
    sFunc = function(a, b)
      local ta = type(a)
      local tb = type(b)
      if(ta == tb)
        then return a < b
      end
      return ta < tb
    end
  end
  local keyList = {}
  local index = 1
  for k,_ in pairs(inputTable) do
    table.insert(keyList,k)
  end
  table.sort(keyList,sFunc)
  return function()
    rvalue = keyList[index]
    index = index + 1
    return rvalue, inputTable[rvalue]
  end
end

function tableView(t, name, seen)
  -- If we call a function with too few arguments, the extra parameters
  -- have the value nil
  if name == nil then
    name = ""
  end
  if seen == nil then
    seen = {t = true}
  end
  seen[t] = true
  -- View this table and recurse with subtables
  for k,v in pairs(t) do
    if type(v) ~= "table" then -- ~= is != in most other languages
      print(name,k,v)
    else
      if seen[v] then
        print(name, k, "LOOP!")
      else
        tableView(v, name .. " " .. k, seen)
      end
    end
  end
end

-- Create a new “board” (really, row) where we will place pieces
function initBoard(size)
  local out = {}
  for a=1,size do
    out[a] = " "
  end
  return out
end

-- Add a piece to the board, on the #place available empty square
function addPiece(board, piece, place)
  local count = 0
  if type(board) ~= 'table' then return false end
  if type(piece) ~= 'string' then piece = 'b' end 
  if type(place) ~= 'number' then place = 1 end
  for a=1,#board do
    if board[a] == " " then
      place = place - 1
      if place < 1 then
        board[a] = piece
        return true
      end
    end
  end
  return false
end

-- Output a Chess960 setup, given a number from 0 to 959
function Chess960(setup)
  if type(setup) ~= 'number' then setup = 1 end
  local set = setup
  local board = initBoard(8)
  local bishop1 = set % 4
  set = math.floor(set / 4)
  bishop1 = bishop1 + 1
  bishop1 = bishop1 * 2
  board[bishop1] = 'b'
  local bishop2 = set % 4
  set = math.floor(set / 4)     
  bishop2 = bishop2 * 2
  bishop2 = bishop2 + 1
  board[bishop2] = 'b'
  local queen = set % 6
  queen = queen + 1
  set = math.floor(set / 6)
  addPiece(board,'q',queen)
  -- Knights are tricky
  local knights = set % 10
  knights = knights + 1
  -- This could be calculated, but since we only have to do this with
  -- knights, just use a two dimensional array
  local knightArray = {{1,1}, {1,2}, {1,3}, {1,4}, {2,2}, {2,3}, {2,4},
                       {3,3}, {3,4}, {4,4}}
  addPiece(board,'n',knightArray[knights][1])
  addPiece(board,'n',knightArray[knights][2])
  -- Once Bishops, Queen, Knights are placed, king is always between
  -- the two rooks so there is only one possible setup at this point
  addPiece(board,'r')
  addPiece(board,'k')
  addPiece(board,'r')
  return board
end

-- Output a Capa720 setup, given a number from 0 to 719
function Capa720(setup)
  if type(setup) ~= 'number' then setup = 1 end
  local set = setup
  local board = initBoard(10)
  board[1] = 'r'
  board[10] = 'r'
  board[6] = 'k'
  -- In Chess960, we place the light bishop before the dark one
  local bishop1 = set % 3
  set = math.floor(set / 3)
  bishop1 = bishop1 + 1
  bishop1 = bishop1 * 2
  if bishop1 == 6 then bishop1 = 8 end
  board[bishop1] = 'b'
  -- Dark bishop
  local bishop2 = set % 4
  set = math.floor(set / 4)     
  bishop2 = bishop2 * 2
  bishop2 = bishop2 + 3
  board[bishop2] = 'b'
  -- Queen
  local queen = set % 5
  queen = queen + 1
  set = math.floor(set / 5)
  addPiece(board,'q',queen)
  -- Marshal/Chancellor
  local chan = set % 4
  chan = chan + 1
  addPiece(board,'c',chan)
  set = math.floor(set / 4)
  -- Archbishop
  local arch = set % 3
  arch = arch + 1
  addPiece(board,'a',arch)
  -- Knights
  addPiece(board,'n')
  addPiece(board,'n')
  -- Done
  return board
end  

-- Given a board array, output the setup as ASCII 
function board2ASCII(board)
  local out = ""
  for a=1,#board do
    out = out .. tostring(board[a])
  end
  return out
end

-- Given a board array, output the setup as FEN
function board2FEN(board)
  local out = ""
  local line = board2ASCII(board)
  local pawns = ""
  for a=1,#board do
    pawns = pawns .. "p"
  end
  local empty = tostring(#board)
  out = line .. "/" .. pawns .. "/" 
  out = out .. empty .. "/" .. empty .. "/" .. empty .. "/" .. empty .. "/" 
  out = out .. pawns:upper() .. "/" .. line:upper()
  out = out .. "_w_KQkq_-_0_1"
  return out
end

function FENtoDiagram10x8(FEN)
  local line = ""
  local out = '<div class=chessDiagram10x8 translate="no">' -- 10x8 for Capa
  local width = 0
  local number = 0
  local inNumber = false
  for a=1,#FEN do
    if FEN:sub(a,a):match("%d") and inNumber == false then
      number = tonumber(FEN:sub(a,a))
      inNumber = true
    elseif FEN:sub(a,a):match("%d") then
      number = number * 10
      number = number + tonumber(FEN:sub(a,a))
    else
      inNumber = false
      width = width + number
      number = 0
      if FEN:sub(a,a) == "/" then break end
      width = width + 1
    end
  end
  number = 0
  inNumber = false

  -- We now know the width of the board, output the first row in
  -- diagram notation (this is the notation the ChessCancun font uses)
  -- This is the top border of the Chess board
  for a=1,#FEN do
    local thisSquare = FEN:sub(a,a)
    if thisSquare:match("%_") or thisSquare:match("%s") then
      break
    end
    if thisSquare:match("%d") and inNumber == false then
      number = tonumber(FEN:sub(a,a))
      inNumber = true
    elseif thisSquare:match("%d") then
      number = number * 10
      number = number + tonumber(FEN:sub(a,a))
    end
    if thisSquare:match("%D") or a==#FEN then
      for b=1,number do
        out = out .. "<div></div> " -- Empty square
      end
      number = 0
      inNumber = false
    end
    if thisSquare:match("%a") then
      -- Chacellor/Marshal Rook + Knight piece is “M” in our mapping
      if thisSquare == 'C' then
        thisSquare = 'M'
      end
      if thisSquare == 'c' then
        thisSquare = 'm'
      end
      out = out .. "<div>" .. thisSquare .. "</div> "
    end
  end
  out = out .. "</div>"
  return out
end

function pageHeader(title)
  local out = ""
  out = out .. "<html><head><title>" .. title .. "</title>\n"
  out = out .. "<style>\n"
  local handle = io.open("../fonts.css","rb")
  if not handle then
    print("Fatal can not open ../fonts.css")
    os.exit(1)
  end
  out = out .. handle:read("*a") .. "\n"
  out = out .. [[
body { font-family: Kilroy8, Kilroy, Verdana, sans-serif;
       font-size: 14pt; }
@font-palette-values --dark {
 font-family: "ChessCancunColor";
 override-colors: 0 rgb(0 0 0), 1 rgb(205 192 180); }
@media (max-width: 640px) {
pre {max-width: 90vw; overflow-x: scroll;}
.c {max-width: 90vw;}
.blogPre {overflow-x:scroll;}
}
.chessDiagram10x8 { font-family: ChessCancunColor; font-size: 32px; 
display: grid;
    grid-template-columns: repeat(10, 1fr);
    grid-template-rows: repeat(8, 1fr);
    width: 375px;
    height: 300px;
    border: 2px solid #333;
}

.chessDiagram10x8 div {
    text-align: center;
    background-color: #fff; /* Light square */
}

/* Alternating colors using nth-child */
.chessDiagram10x8 div:nth-child(-n+10):nth-child(even),
.chessDiagram10x8 div:nth-child(n+11):nth-child(-n+20):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+21):nth-child(-n+30):nth-child(even),
.chessDiagram10x8 div:nth-child(n+31):nth-child(-n+40):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+41):nth-child(-n+50):nth-child(even),
.chessDiagram10x8 div:nth-child(n+51):nth-child(-n+60):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+61):nth-child(-n+70):nth-child(even),
.chessDiagram10x8 div:nth-child(n+71):nth-child(-n+80):nth-child(odd) {
    background-color: #ccc; /* Dark square */
}
@media (prefers-color-scheme: dark) { 
body { background-color: #131516; color: #d8d4cf; }
a { color: #78dc78; }
.blog a { color: #78dc78; }
.chessDiagram10x8 { border: 2px solid #ddd; font-palette: --dark; }
.chessDiagram10x8 div { background-color: #aaa; }
.chessDiagram10x8 div:nth-child(-n+10):nth-child(even),
.chessDiagram10x8 div:nth-child(n+11):nth-child(-n+20):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+21):nth-child(-n+30):nth-child(even),
.chessDiagram10x8 div:nth-child(n+31):nth-child(-n+40):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+41):nth-child(-n+50):nth-child(even),
.chessDiagram10x8 div:nth-child(n+51):nth-child(-n+60):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+61):nth-child(-n+70):nth-child(even),
.chessDiagram10x8 div:nth-child(n+71):nth-child(-n+80):nth-child(odd) {
    background-color: #888; /* Dark square */
}
} /* End Dark mode theme */
@media print {
.chessDiagram10x8 { border: 2px solid #333; break-inside: avoid;
                    page-break-inside: avoid;}
.chessDiagram10x8 div { background-color: #fff; }
.chessDiagram10x8 div:nth-child(-n+10):nth-child(even),
.chessDiagram10x8 div:nth-child(n+11):nth-child(-n+20):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+21):nth-child(-n+30):nth-child(even),
.chessDiagram10x8 div:nth-child(n+31):nth-child(-n+40):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+41):nth-child(-n+50):nth-child(even),
.chessDiagram10x8 div:nth-child(n+51):nth-child(-n+60):nth-child(odd),
.chessDiagram10x8 div:nth-child(n+61):nth-child(-n+70):nth-child(even),
.chessDiagram10x8 div:nth-child(n+71):nth-child(-n+80):nth-child(odd) {
    background-color: #ddd; /* Dark square */
}
} /* End print colors */
</style>
<script>
maxWidth = screen.width;
maxWidth *= .95;
if(maxWidth < 480) {
  boardSize = maxWidth - 5;
  pieceWidth = (boardSize / 10) * (16/15);
  capaPieceWidth = (boardSize / 12.5) * (16/15);
  capaHeight = boardSize * .8;
}
</script>
<meta name=viewport content=width=device-width,initial-scale=1.0,minimum-scale=0.8 >
</head><body>
<center><table><tr><td width=640>
]]
  return out
end

-- convert in to short algebracic
-- E.g. make "e2e4" "e4" and make "g1f3" "Nf3"
-- This only works from the initial position!
-- Setup is a string like 'RNABQKBCNR'
function moveConvert(move, setup)
  if(move:len() ~= 4) then return move end
  if move:sub(4,4) == '1' then
    if move:sub(1,1) < move:sub(3,3) then -- If castling rook right of king
      return "0-0"
    end
    return "0-0-0"
  end
  if move:sub(1,1) == move:sub(3,3) then -- If pawn move (same file)
    return move:sub(3,4)
  end
  local file = {a=1,b=2,c=3,d=4,e=5,f=6,g=7,h=8,i=9,j=10}
  local place = file[move:sub(1,1)] -- Location of moving knight
  -- In rare cases, the knight move needs four letters
  if setup:match("N.N") and setup:sub(place,place) == 'N' then
    if file[move:sub(1,1)] == file[move:sub(3,3)] + 1 -- If N moves left
       and place > 2 and setup:sub(place-2,place-2) == 'N' then
      return "N" .. move:sub(1,1) .. move:sub(3,4)
    end
    if file[move:sub(1,1)] == file[move:sub(3,3)] - 1 -- If N moves right
       and place < 7 and setup:sub(place+2,place+2) == 'N' then
      return "N" .. move:sub(1,1) .. move:sub(3,4)
    end
  end 
  -- If not a castle, pawn move, or complex night move, it’s a knight/fairy move
  if setup:sub(place,place) == 'C' then
    return 'M' .. move:sub(3,4)
  end
  return setup:sub(place,place) .. move:sub(3,4)
end

function grabEvals(filename)
  local setup = {}
  for a=0,719 do
    local position = board2ASCII(Capa720(a)):upper()
    setup[position] = {}
    setup[position]['FEN'] = board2FEN(Capa720(a))
    setup[position]['number'] = a
  end
  local handle = io.open(filename,"rb")
  if not handle then
    print("Fatal: Cannot open file " .. filename)
    os.exit(1)
  end
  for line in handle:lines() do
    local fields = split(line,':')
    local position = fields[1]
    local evals = split(fields[2],';')
    local bestMoves = {}
    local pieRuleMoves = {}
    local maxeval = -99999
    local mineval = 99999
    local allMoves = {}
    for a=1,#evals-1 do
      local fields = split(evals[a],",")
      eval = tonumber(fields[1])
      move = moveConvert(fields[2],position)
      local moveTable = {eval=eval,move=move}
      table.insert(allMoves,moveTable)
      if eval > maxeval then
        maxeval = eval
        bestMoves = {}
        table.insert(bestMoves,move)
      elseif eval == maxeval then
        table.insert(bestMoves,move)
      end
      if math.abs(eval) < mineval then
        mineval = math.abs(eval)
        pieRuleMoves = {}
        table.insert(pieRuleMoves,move)
      elseif math.abs(eval) == mineval then
        table.insert(pieRuleMoves,move)
      end
    end  
    if not setup[position] then
      -- print("Illegal position " .. position) os.exit(1)
      setup[position] = {}
    end
    setup[position]['maxEval'] = maxeval
    setup[position]['bestMoves'] = bestMoves
    setup[position]['pieRuleEval'] = mineval
    setup[position]['pieRuleMoves'] = pieRuleMoves
    setup[position]['allMoves'] = allMoves
  end
  local rank = 1
  local thisRank = 1
  local thisEval = -999999
  for k,v in sPairs(setup,
      function(a,b) return setup[a]['maxEval'] < setup[b]['maxEval'] end) do
    local eval = v['maxEval']
    if eval > thisEval then
      thisEval = eval
      thisRank = rank
    end
    v['rank'] = thisRank
    rank = rank + 1
  end
  return setup
end

-- It took me three days to calculate the 21-ply evals for all 720
-- Capa720 positions
setups = grabEvals("Capa720.setups.21ply.txt")
print(pageHeader("Fairy-Stockfish14 21-ply LB w/NNUE Capa720"))

for k,v in sPairs(setups,
      function(a,b) return setups[a]['maxEval'] < setups[b]['maxEval'] end) do
  local thisSetup = k:gsub("C","M")
  print('<a name="' .. thisSetup .. '"> </a>')
  print(FENtoDiagram10x8(v['FEN']) .. "<br>")
  print([[<script>
if(maxWidth < 480) {
  capaElements = document.querySelectorAll('.chessDiagram10x8');
  i = capaElements.length - 1;
  capaElements[i].style.width = boardSize + 'px';
  capaElements[i].style.height = capaHeight + 'px';
  capaElements[i].style.fontSize = capaPieceWidth + 'px';
}
</script>
]])
  print("<div class=c>")
  print("Setup: " .. thisSetup .. "<br>")
  print("Eval: " .. v['maxEval'])
  print('(i.e. White has a ' .. v['maxEval'] .. ' centipawn advantage)<br>')
  print("Rank: " .. v['rank'] .. "<br>")
  print("Setup number: " .. v['number'] .. "<br>")
  if #v['bestMoves'] == 1 then
    print("Best opening move: ")
  else
    print("Best opening moves: ")
  end
  for a=1,#v['bestMoves'] do
    print(v.bestMoves[a])
  end
  print(" (Eval: " .. v['maxEval'] .. ")")
  local goodMoveCount = 0
  local goodMoveThreshold = 5
  for a=1,#v['allMoves'] do
    if v['allMoves'][a]['eval'] < v['maxEval'] and
       v['allMoves'][a]['eval'] >= v['maxEval'] - goodMoveThreshold then
      goodMoveCount = goodMoveCount + 1
    end
  end
  if goodMoveCount >= 1 then
    if goodMoveCount == 1 then
      print("<br>Good opening move: ")
    else
      print("<br>Good opening moves: ")
    end
    for a=1,#v['allMoves'] do
      if v['allMoves'][a]['eval'] < v['maxEval'] and
         v['allMoves'][a]['eval'] >= v['maxEval'] - goodMoveThreshold then
        print(v['allMoves'][a]['move'])
        print(" (Eval: " .. v['allMoves'][a]['eval'] .. ")")
      end
    end
  end
  print("<br>")
  if #v['pieRuleMoves'] == 1 then
    print("Pie rule (balanced) opening move: ")
  else
    print("Pie rule (balanced) opening moves: ")
  end
  for a=1,#v['pieRuleMoves'] do
    if a < #v['pieRuleMoves'] then
      print(v.pieRuleMoves[a])
    else
      print(v.pieRuleMoves[a] .. " (Eval: &pm;" .. v['pieRuleEval'] .. ") ")
    end
  end
  print("<br>")
  print("</div>")
  print("<hr>")
end

print("</td></tr></table></center></body></html>")
-- tableView(setups)

