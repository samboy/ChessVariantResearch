#!/bin/sh
_rem=--[=[

LUNACY=""
if command -v lunacy64 >/dev/null 2>&1 ; then
  LUNACY=lunacy64
#elif command -v lua5.1 >/dev/null 2>&1 ; then
#  LUNACY=lua5.1
#elif command -v lua-5.1 >/dev/null 2>&1 ; then
#  LUNACY=lua-5.1
elif command -v lunacy >/dev/null 2>&1 ; then
  LUNACY=lunacy
#elif command -v luajit >/dev/null 2>&1 ; then
#  LUNACY=luajit # I assume luajit will remain frozen at Lua 5.1
fi
if [ -z "$LUNACY" ] ; then
  echo Please install Lunacy
  echo https://github.com/samboy/lunacy
  exit 1
fi

exec $LUNACY $0 "$@"

# ]=]1
-- Placed in the public domain 2021,2026 by Sam Trenholme
-- This is a lunacy (Lua + Steve Donovan's spawner lib) implementation of
-- a simple Chess/Chess variants client
--
-- This client looks for balanced Double CapaRandom Chess setups.
--
-- This client requires the Fairy Stockfish program to be installed

if #arg >= 1 then
  a1 = arg[1]
else
  a1 = ""
end
if a1:match("%?") or a1:match("%-") or a1:match("[Hh]") then 
  print(
     "Usage: lunacy FindBalancedSetup.lua {iterations} {seed} {depth}")
  print(
     "Example: lunacy FindBalancedSetup.lua 100 SomeRandomText 17")
  os.exit(0)
end

iterations = 10
if #arg >= 1 then
  iterations = tonumber(a1)
else 
  iterations = 10
end
if not iterations or iterations < 1 then
  iterations = 10
end

local thisseed = os.time()
if #arg >= 2 then
  thisseed = arg[2]
end

local searchDepth = 17
if #arg >= 3 then
  searchDepth = tonumber(arg[3])
end
if not searchDepth or searchDepth < 1 then
  searchDepth = 17
end

local tolerance = nil
if #arg >= 4 then
  tolerance = tonumber(arg[4])
end

-- Here be dragons below
if rg32 == nil then
  print("I need the rg32 lib to continue!")
  print("Download Lunacy at https://github.com/samboy/lunacy")
  os.exit(1)
end
rg32.randomseed(thisseed)

------------------------------------------------------------------
-- Functions to make a Capa double random board
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

-- Output a Capa84000 setup, given a number from 0 to 83999
function Capa84000(setup)
  if type(setup) ~= 'number' then setup = 1 end
  local set = setup
  local board = initBoard(10)
  local bishop1 = set % 5
  set = math.floor(set / 5)
  bishop1 = bishop1 + 1
  bishop1 = bishop1 * 2
  board[bishop1] = 'b'
  local bishop2 = set % 5
  set = math.floor(set / 5)     
  bishop2 = bishop2 * 2
  bishop2 = bishop2 + 1
  board[bishop2] = 'b'
  local queen = set % 8
  queen = queen + 1
  set = math.floor(set / 8)
  addPiece(board,'q',queen)
  local archbishop = set % 7
  archbishop = archbishop + 1
  addPiece(board,'a',archbishop)
  set = math.floor(set / 7)
  local marshal = set % 6
  marshal = marshal + 1
  addPiece(board,'c',marshal)
  set = math.floor(set / 6)
  -- Knights are tricky
  local knights = set % 10
  knights = knights + 1
  -- This could be calculated, but since we only have to do this with
  -- knights, just use a two dimensional array
  local knightArray = {{1,1}, {1,2}, {1,3}, {1,4}, {2,2}, {2,3}, {2,4},
                       {3,3}, {3,4}, {4,4}}
  addPiece(board,'n',knightArray[knights][1])
  addPiece(board,'n',knightArray[knights][2])
  -- Once Bishops, Queen, Fairy pieces, and Knights are placed, king is 
  -- always between the two rooks so there is only one possible setup at 
  -- this point
  addPiece(board,'r')
  addPiece(board,'k')
  addPiece(board,'r')
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

-- Given 2 board arrays, output the setup as PGN
function boards2PGN(board1, board2)
  local out = ""
  local topline = board2ASCII(board1):lower()
  local bottomline = board2ASCII(board2):upper()
  local pawns = ""
  for a=1,#board1 do
    pawns = pawns .. "p"
  end
  local empty = tostring(#board1)
  out = topline .. "/" .. pawns .. "/" 
  out = out .. empty .. "/" .. empty .. "/" .. empty .. "/" .. empty .. "/" 
  out = out .. pawns:upper() .. "/" .. bottomline
  out = out .. " w KQkq - 0 1"
  return out
end

-- Get a random number from 0 to 83999
function randomSetupNumber() 
  local number = 4294920000
  local stop = 1
  while number >= 4294920000 do
    number = rg32.rand32()
    stop = stop + 1
    if stop > 1000 then
      print("Infinite loop panic\n") os.exit(1)
    end
  end
  number = number % 84000
  return number
end

function MakeFEN()
  local White = Capa84000(randomSetupNumber())
  local Black = Capa84000(randomSetupNumber())
  local FEN = boards2PGN(Black, White)
  if not FEN then return nil end
  return FEN
end

----------------------- rStrSplit() -----------------------
-- This does a simple split for a given string, useful for simple CSV
-- Input: string (single CSV line), split character
-- Output: An array with each field in the CSV line
function rStrSplit(s, splitOn)
  if not splitOn then splitOn = "," end
  local place = 1
  local out = {}
  local last = 1
  while place do
    place = string.find(s, splitOn, place, true)
    if place then
      out[#out + 1] = string.sub(s, last, place - 1)
      place = place + 1
      last = place
    end
  end
  out[#out + 1] = string.sub(s, last, -1)
  return out
end

if spawner == nil then
  print("I need Steve Donovan's spawner lib to continue!")
  print("Download Lunacy at https://github.com/samboy/lunacy")
  os.exit(1)
end

thisIteration = 1
ChessEngine = "fairy-stockfish"
w,r = spawner.popen2(ChessEngine)
w:write("setoption name Use NNUE value true\n")
w:write("setoption name EvalFile value capablanca-bb644ef32758.nnue\n")
w:write("setoption name UCI_Variant value caparandom\n")
-- w:write("setoption name UCI_Chess960 value true\n")
-- CODE HERE
w:write("setoption name MultiPV value 1\n")
w:write("ucinewgame\n")
minEval = 1000000
for z=1,iterations do
  thisFEN = MakeFEN()
  w:write("position fen " .. thisFEN .. "\n")
  w:write("d\n")
  w:write("go depth " .. tostring(searchDepth) .. "\n")
  w:flush()
  lineFromEngine = ""
  eval = -1
  lines = {}
  while not string.match(lineFromEngine,'^bestmove') do
    local x = nil
    local line = nil
    lineFromEngine = r:read()
    line, x = lineFromEngine:match("multipv (%d+) score cp ([%d%-]+)")
    if x and tonumber(line) == 1 then
      eval = x
    end
    local move = lineFromEngine:match(" pv (%S+) ")
    if line then
      lines[tonumber(line)] = {}
      lines[tonumber(line)]['eval'] = tonumber(x) 
      lines[tonumber(line)]['move'] = move
    end
    -- print(lineFromEngine) -- Do this if verbose
    io.flush()
  end
  thisEval = math.abs(tonumber(lines[1]['eval']))
  if thisEval < minEval then
    if not tolerance or thisEval > tolerance then
      minEval=thisEval
    end
    out = tostring(thisseed) .. "," .. thisIteration .. "," .. thisFEN .. ":" 
    for a=1,#lines do
      if lines[a]['move'] then
        out = out .. lines[a]['eval'] .. ',' .. lines[a]['move'] .. ';'
      end
    end
    print(out)
  end
  thisIteration = thisIteration + 1
  io.flush()
  if thisEval == 0 and not tolerance then
    print("Eval 0 found, job done\n")
    os.exit(0)
  end
end

