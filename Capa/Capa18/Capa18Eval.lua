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

-- It’s the 18 positions where rooks, knights, bishops are all symmetrical,
-- the king is on the sixth file, the rooks are in the corners, and the
-- knights are closer to the king than the bishops
function isCapa18(setup)
  if type(setup) == 'table' then setup = board2ASCII(setup) end
  if type(setup) ~= 'string' then return false end
  if setup:match('R.NB.KBN.R') then return true end
  if setup:match('RN.B.KB.NR') then return true end
  if setup:match('RNB..K.BNR') then return true end
  return false
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
  out = out .. " w KQkq - 0 1"
  return out
end

-- Let's look at win/lose/draw ratio for different capa setups
plies = 17
if #arg >= 1 then
  if arg[1]:match("h") then
    print("Usage: Capa36Eval.lua {plies}")
    os.exit(0)
  end
  plies = tonumber(arg[1])
  if not plies then
    print("Warning: Plies should be a number. Defaulting to 17.")
    plies = 17
  end
end

-- params is a table with the "user tunable" parameters
params = {
  -- See https://github.com/ianfab/Fairy-Stockfish for the Chess engine
  -- This is the name of the chess engine, as it appears in one's $PATH
  ChessEngine = "fairy-stockfish",
  -- This is the number of lines we look at and consider for our next move
  MultiPV = 3,
  -- The name of the variant we will look at.  This needs to be a variant
  -- Fairy-Stockfish supports
  variantName = "capablanca",
  -- variantName = "chess",
  -- The opening setup (or position) we will play from in the game
  -- Note: This currently only works with 8xN games (8x8, 8x10, 8x12, etc.)
  variantSetup = vSetup,
  -- It's also possible to set up any arbitrary FEN, not just a mirrored
  -- 8x# backrank opening setup
  -- This is an argument given to the Fairy-Stockfish "setboard" command
  -- variantFEN = "ranbqkbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RANBQKBNCR " ..
  --          "w KQkq - 0 1",
  -- variantFEN = false, -- Use default opening setup for variant
  -- After this many plies are searched, decide on a move to make
  searchPly = 21,
  -- Opening to play.  Format is like this: "f2f4 f7f5", where each move has
  -- four letters (from, to) or five letters (for pawn promotions: b7b8q)
  -- King move for castling (e.g. e1g1 with normal RNBQKBNR chess).  Spaces
  -- between openings
  opening = false,
}

-- Here be dragons below
ChessEngine = params["ChessEngine"]
MultiPV = 1
variantName = params["variantName"]
if type(params["variantFEN"]) == "string" then
  variantFEN = params["variantFEN"]
else
  variantFEN = false
end

if plies then
  searchPly = plies
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

openmove = {}
thismove = 0
if type(params["opening"]) == "string" then
  thismove = 1
  openmove = rStrSplit(params["opening"]," ")
end 

if spawner == nil then
  print("I need Steve Donovan's spawner lib to continue!")
  print("Download Lunacy at https://github.com/samboy/lunacy")
  os.exit(1)
end

w,r = spawner.popen2(ChessEngine)
-- Load NNUE
w:write("setoption name UCI_Variant value capablanca\n")
w:write("setoption name EvalFile value capablanca-bb644ef32758.nnue\n")
w:write("setoption name Use NNUE value true\n")

function evalSetup(w,r,Setup,FEN,plies,verbose)
  w:write("ucinewgame\n")
  w:write("position fen " .. FEN .. "\n")
  w:write("d\n")
  w:write("go depth " .. tostring(plies) .. "\n")
  w:flush()
  lineFromEngine = ""
  local eval = -1
  while not string.match(lineFromEngine,'^bestmove') do
    local x = nil
    lineFromEngine = r:read()
    x = lineFromEngine:match("score cp (%d+)")
    if x then
      eval = x
    end
    if verbose then
      print(lineFromEngine)
    end
    io.flush()
  end
  io.flush()
  return(Setup .. " eval: " .. eval)
end

for a=0,719 do
  local Board = Capa720(a)
  local Setup = board2ASCII(Board)
  local FEN =   board2FEN(Board)
  if isCapa18(Setup:upper()) then
    print(evalSetup(w,r,Setup:upper(),FEN,plies,false))
    io.flush()
  end
end

w:write("quit\n") -- Let’s have a clean exit
io.flush()

