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

-- This script has been donated to the public domain in 2021,2026 by 
-- Sam Trenholme If, for some reason, a public domain declation is not 
-- acceptable, it may be licensed under the following terms:

-- Copyright 2021,2026 Sam Trenholme
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
-- This client is a “randomized” version of Fairy-Stockfish:  It looks
-- at the top MultiPV number of moves (default: 3), and chooses one within
-- 50 centipawns of what it thinks is the best move at random.
--
-- This client requires the Fairy-Stockfish program to be installed
-- and available with the name fairy-stockfish-largeboard_x86-64
-- (if it has another name, change "ChessEngine" below)

vSetup = "RNBQKBNR"
if #arg >= 1 then
  vSetup = arg[1]
end
if vSetup:len() < 8 then 
  print(
     "Usage: lunacy Stockfish960Eval.lua {setup} {plies} {multiPV} {opening}")
  print(
     "Example: Stockfish960Eval.lua RBBQKNNR 21 7 'c2c4 c7c5'")
  os.exit(0)
end

-- params is a table with the "user tunable" parameters
-- They are also tuned with arguments, which overrides these
-- params.
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
ChessEngine = params["ChessEngine"]
MultiPV = tonumber(params["MultiPV"])
variantName = params["variantName"]
if type(params["variantFEN"]) == "string" then
  variantFEN = params["variantFEN"]
else
  variantFEN = false
end

-- Here be dragons below
math.randomseed(os.time())

if vSetup:len() == 10 then
  ChessEngine = "fairy-stockfish"
  variantName = "capablanca"
end
if vSetup:len() == 8 then
  ChessEngine = "stockfish"
  variantName = nil
end   
plies = false
if #arg >= 2 then
  plies = tonumber(arg[2])
end
if #arg >= 3 then
  MultiPV = tonumber(arg[3])
end
opening = false
if #arg >= 4 then
  opening = arg[4]
end

-- If they specify a variantSetup (e.g. RNBQKBNR or RANBQKBNCR), convert
-- that in to the appropriate 8x# FEN string
if type(params["variantSetup"]) == "string" then
  local setup = params["variantSetup"]
  -- Black's pieces
  variantFEN = setup:lower() .. "/"
  -- Black's pawns
  for a = 1,#setup do
    variantFEN = variantFEN .. "p"
  end
  -- The 4-row blank area between setups
  -- This code currently only works with 8x# setups
  for a = 1, 4 do
    variantFEN = variantFEN .. "/" .. tostring(#setup)
  end
  variantFEN = variantFEN .. "/"
  -- White's pawns
  for a = 1,#setup do
    variantFEN = variantFEN .. "P"
  end
  variantFEN = variantFEN .. "/" .. setup:upper() .. " w KQkq - 0 1"
end

-- How many ply do we look ahead per move
searchPly = tonumber(params["searchPly"])

-- Sanity for numeric vaues
if not MultiPV or MultiPV < 1 then
  print("MultiPV too small/not set, using 3")
  MultiPV = 3
end
if not searchPly or searchPly < 7 then 
  print("searchPly too small/not set, using 21") 
  searchPly = 21
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
function evalPosition(variantFEN, opening) 
  local out = ""
  local wdl = ""
  -- Load NNUE
  if variantName then
    w:write("setoption name UCI_Variant value " .. variantName .. "\n")
  end
  if variantName == "capablanca" or variantName == "caparandom" then
    w:write("setoption name EvalFile value capablanca-bb644ef32758.nnue\n")
  end
  w:write("setoption name Use NNUE value true\n")
  if variantName ~= "capablanca" and variantName ~= "caparandom" then
    w:write("setoption name UCI_Chess960 value true\n")
  end
  w:write("setoption name UCI_ShowWDL value true\n")
  w:write("setoption name MultiPV value " .. tostring(MultiPV) .. "\n")
  w:write("ucinewgame\n")
  if not opening then
    w:write("position fen " .. variantFEN .. "\n")
  else
    w:write("position fen " .. variantFEN .. " moves " .. opening .. "\n")
  end
  w:write("d\n")
  w:write("go depth " .. tostring(searchPly) .. "\n")
  w:flush()
  local lineFromEngine = ""
  local eval = -1
  local lines = {}
  while not string.match(lineFromEngine,'^bestmove') do
    local x = nil
    local line = nil
    lineFromEngine = r:read()
    line, x = lineFromEngine:match("multipv (%d+) score cp ([%d%-]+)")
    if x and tonumber(line) == 1 then
      eval = x
    end
    local win, draw, loss = 
       lineFromEngine:match(" wdl ([%d%-]+) ([%d%-]+) ([%d%-]+)")
    local move = lineFromEngine:match(" pv (%S+) ")
    local sharp = 0
    if win then
      win = tonumber(win)
      draw = tonumber(draw)
      loss = tonumber(loss)
      -- Sharp:
      -- https://archive.ph/20260402040734/
      -- https://www.chess-journal.com/evaluatingSharpness1.html
      if win > loss and draw > 0 then
        sharp = (loss / 50) * (333/draw) * (1/(1+math.exp(-((win+loss)/1000))))
      elseif loss > win and draw > 0 then
        sharp = (win / 50) * (333/draw) * (1/(1+math.exp(-((win+loss)/1000))))
      elseif draw <= 0 then
        sharp = 100000000 -- Infinity
      else
        sharp = -1 -- Error
      end
    end
    if line then
      lines[tonumber(line)] = {}
      lines[tonumber(line)]['eval'] = tonumber(x) 
      lines[tonumber(line)]['move'] = move
      lines[tonumber(line)]['win'] = tonumber(win)
      lines[tonumber(line)]['draw'] = tonumber(draw)
      lines[tonumber(line)]['loss'] = tonumber(loss)
      lines[tonumber(line)]['sharp'] = tonumber(sharp)
    end
    print(lineFromEngine)
    io.flush()
  end
  if opening then
    out = vSetup .. " (" .. opening .. ")"
  else
    out = vSetup  
  end
  wdl = out .. '@'
  out = out .. ':'
  for a=1,#lines do
    if lines[a]['move'] then
      out = out .. lines[a]['eval'] .. ',' .. lines[a]['move'] .. ';'
      wdl = wdl .. lines[a]['eval'] .. ',' .. lines[a]['move'] .. ',' ..
          lines[a]['win'] .. '/' .. lines[a]['draw'] .. '/' ..
          lines[a]['loss'] .. ',' .. lines[a]['sharp'] .. ';'
    end
  end
  io.flush()
  print(vSetup .. " eval: " .. eval)
  print(wdl)
  print(out)
end
evalPosition(variantFEN, opening)
w:write("quit\n") -- Let’s have a clean exit
io.flush()
