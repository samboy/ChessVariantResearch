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
-- This client needs "fairy-stockfish" and/or "stockfish" to be
-- installed to run

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

-- Given a board array, output the setup as ASCII 
function board2ASCII(board)
  if type(board) == 'string' then
    return board
  end
  local out = ""
  for a=1,#board do
    out = out .. tostring(board[a])
  end
  return out
end

-- Given a line like “r......r”, convert it to FEN like “r6r”
function dotLine2FEN(line)
  line = board2ASCII(line)
  local out = ""
  local count = 0
  for a=1,#line do
    if line:sub(a,a) == "." or line:sub(a,a) == " " then
      count = count + 1
    else
      if(count > 0) then 
        out = out .. tostring(count)  
        count = 0
      end
      out = out .. line:sub(a,a)
    end
  end
  if(count > 0) then
    out = out .. tostring(count)
  end
  return out
end
 
-- Given a board array, output the setup as FEN
-- Input: board (array of a board, but can also be a string like “RBBQKNNR”)
--        nocastle (false if castling allowed, otherwise no castling)
--        mirror (Make Black pieces a mirror of White’s; point instead of
--                line symmetry, so the setup would be “rnnkqbbr[...]RBBQKNNR”)
--        freeling (Place pawns on 3rd rank, rooks on first rank, other pieces
--                  on second rank, turn off castling.  Based on Rotary
--                  and Grand Chess as invented by Christian Freeling)
function board2FEN(board, nocastle, mirror, freeling)
  local out = ""
  if not board then board="RBBQKNNR" end -- Mongredian Chess, balanced
  if freeling == true then freeling = 'r' end
  local line = board2ASCII(board)
  local pawns = ""
  for a=1,#board do
    pawns = pawns .. "p"
  end
  local empty = tostring(#board)
  local Black = line:lower()
  local White = line:upper()
  if freeling then
    local BlackRooks = ""
    local BlackPieces = ""
    local WhiteRooks = ""
    local WhitePieces = ""
    for a=1,#Black do
      if Black:sub(a,a):match(freeling) then
        BlackRooks = BlackRooks .. Black:sub(a,a)
        BlackPieces = BlackPieces .. "."
      else
        BlackRooks = BlackRooks .. "."
        BlackPieces = BlackPieces .. Black:sub(a,a)
      end
    end
    BlackRooks = dotLine2FEN(BlackRooks)
    BlackPieces = dotLine2FEN(BlackPieces)
    WhiteRooks = BlackRooks:upper()
    WhitePieces = BlackPieces:upper()
    if mirror then BlackPieces = BlackPieces:reverse() end
    out = BlackRooks .. "/" .. BlackPieces .. "/" .. pawns 
    out = out .. "/" .. empty .. "/" .. empty .. "/"
    out = out .. pawns:upper() .. "/" .. WhitePieces .. "/" .. WhiteRooks
  else
    if mirror then Black = Black:reverse() end
    out = Black .. "/" .. pawns .. "/" 
    out = out .. empty .. "/" .. empty .. "/" .. empty .. "/" .. empty .. "/" 
    out = out .. pawns:upper() .. "/" .. White
  end
  if nocastle or freeling then
    out = out .. "_w_-_-_0_1"
  else
    out = out .. "_w_KQkq_-_0_1"
  end
  return out
end

-- There are 18 setups where neither the king nor rooks have moved
function isChess18(board)
  board = board2ASCII(board)
  board = board:upper()
  if board:match("R...K..R") then return true end
  return false
end

-- There are 204 setups where the king is on the E file, between the rooks
-- These setups are nice because they are both Fischer’s Chess960 setups
-- as well as John Kipling Lewis’s “Chess480” setups where the king always
-- moves two squares when castling.  It’s **a lot** easier to explain
-- the castling rules to Lewis’s take on shuffle chess than it is with
-- Fischer’s take on it.
function isChess204(board)
  board = board2ASCII(board)
  board = board:upper()
  if board:match("....K...") then return true end
  return false
end

-- Setups where the rooks are in the corners.  Works with 8x10 and 8x8
function cornerRooks(board)
  board = board2ASCII(board)
  board = board:upper()
  if board:match("^R.*R$") then return true end
  return false
end

-- Setups where the king is to the right of the queen
function kingRightOfQueen(board)
  board = board2ASCII(board)
  board = board:upper()
  if board:match("Q.*K") then return true end
  return false
end

-- Init RNG
gSeed = os.time()
rg32.randomseed(gSeed)

-- END utility functions

action="--help"
if #arg >= 1 then
  action = arg[1]
end
if #arg < 1 or action:match("[Hh%?]") then 
  print(
     "Usage: lunacy EvalOrPlay.lua {action} {setup} {plies} {multiPV}")
  print(
     "Example: EvalOrPlay.lua --eval RBBQKNNR 21 7")
  print('action" is "--help", "--play", or "--eval"')
  print('Setup can be Chess960 to evaluate all 960 Chess960 positions')
  -- Christian Freeling has made a couple of Chess Variants with the idea
  -- that the rooks are in the corners, the pawns are moved up one row, the
  -- other pieces are on the second row, and there is no castling.
  print('Setup can be Freeling to evaluate all 104 "Freeling" positions')
  os.exit(0)
end
actionType = "eval"
if action == "--eval" then
  actionType = "eval"
elseif action == "--play" then
  actionType = "play"
else
  print("EvalOrPlay.lua version 0.1.0")
  print("Type: lunay EvalOrPlay.lua --help for usage guide")
  os.exit(0)
end

vSetup = "RNBQKBNR"
if #arg >= 2 then
  vSetup = arg[2]
end

-- Here be dragons below
--math.randomseed(os.time())

if vSetup:len() == 10 then
  ChessEngine = "fairy-stockfish"
  variantName = "capablanca"
end
if vSetup:len() == 8 then
  ChessEngine = "stockfish"
  variantName = nil
end   
plies = false
if #arg >= 3 then
  plies = tonumber(arg[3])
end
if #arg >= 4 then
  MultiPV = tonumber(arg[4])
end
opening = false

if plies then
  searchPly = plies
end

-- Sanity for numeric vaues
if not MultiPV or MultiPV < 1 then
  print("MultiPV too small/not set, using 3")
  MultiPV = 3
end
if not searchPly or searchPly < 7 then 
  print("searchPly too small/not set, using 21") 
  searchPly = 21
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
  if not s then return nil end
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

if spawner == nil then
  print("I need Steve Donovan's spawner lib to continue!")
  print("Download Lunacy at https://github.com/samboy/lunacy")
  os.exit(1)
end

w,r = spawner.popen2(ChessEngine)
function evalPosition(position, variantFEN, opening) 
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
      if win >= loss and draw > 0 then
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
      lines[tonumber(line)]['sharp'] = string.format("%.4f%%",sharp*100)
    end
    print(lineFromEngine)
    io.flush()
  end
  if opening then
    out = position .. " (" .. opening .. ")"
  else
    out = position
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
  print(position .. " eval: " .. eval)
  print(wdl)
  print(out)
  return wdl, out
end

function runGame(MultiPV, variantFEN) 
  w:write("setoption name MultiPV value " .. tostring(MultiPV) .. "\n")
  -- Load NNUE
  if variantName then
    w:write("setoption name EvalFile value capablanca-bb644ef32758.nnue\n")
    w:write("setoption name Use NNUE value true\n")
    w:write("setoption name UCI_Variant value " .. variantName .. "\n")
  else
    w:write("setoption name UCI_Chess960 value true\n")
  end
  w:write("ucinewgame\n")
  if variantFEN then
    w:write("position fen " .. variantFEN .. "\n")
  else 
    -- Default to Finesse chess
    w:write(
      "position fen rnabckbqnr/pppppppppp/10/10/10/10/PPPPPPPPPP/RNABCKBQNR "
      .. "w KQkq - 0 1")
  end
  local FENseen = {}
  local thisFEN = ""
  function processFENline(hash, line)
    if not hash then hash = {} end
    line = line:gsub('[\r\n]','')
    line = line:gsub('^Fen: ','')
    local outLine = line -- Let engine know move number, 50-move count
    line = line:gsub('%d+%s%d+$','') -- Remove move number, 50-move count
    if not hash[line] then
      hash[line] = 1
    else
      hash[line] = hash[line] + 1
      if hash[line] > 7 then
        print(game .. "{draw by repetition}\n")
	return nil
      end 
    end
    return outLine, hash -- We actually modify hash in place, but still
  end
  function grabFEN(handle)
    local out = ""
    while not string.match(lineFromEngine,'^Key') do
      lineFromEngine = handle:read()
      if IsVerbose then print(lineFromEngine) end
      if lineFromEngine:match('^Fen: ') then
        out = processFENline(FENseen, lineFromEngine)
      end
      --print(lineFromEngine)
    end
    print(out)
    return out
  end

  w:write("d\n")
  w:flush()
  lineFromEngine = ""
  thisFEN = grabFEN(r)
  io.flush()

  w:write("go depth " .. searchPly .. "\n")
  w:flush()
  local game = ""
  local movenumber = 1
  game = game .. "(Seed: " .. gSeed .. ") "

  pWinner = "Black"
  multiMoves = {}
  infoS = false
  while true do
    lineFromEngine = r:read()
    IsVerbose = true -- DEBUG
    if IsVerbose then print(lineFromEngine) end
    local fields = rStrSplit(lineFromEngine,' ')
    -- Note how we evaluate
    if not infoS and fields[2] == "string" then 
      infoS = lineFromEngine 
      infoS = infoS:gsub('[\r\n]','')
      game = game .. "(" .. infoS .. ") 1. "
    end 
    if fields[6] == "multipv" then
      -- One day, we will check that "depth" is as high as possible
      multiMoves[fields[7]] = {}
      for a=1,#fields do
        if fields[a] == 'score' then
          if fields[a+1] == 'cp' then
            multiMoves[fields[7]]['v'] = fields[a+2]
          elseif fields[a+1] == 'mate' then
            if tonumber(fields[a+2]) < 0 then
              multiMoves[fields[7]]['v'] = (fields[a+2] + 100000) * -1
            else
              multiMoves[fields[7]]['v'] = fields[a+2] + 100000
            end
          else
            multiMoves[fields[7]]['v'] = -1000000 -- Shouldn’t get here
          end
        end
      end
      -- Find the move to make
      for a=1,#fields do
        if fields[a] == 'pv' then
          multiMoves[fields[7]]['m'] = fields[a+1]
        end
      end
    end
    if fields[1] == "bestmove" then
      move = fields[2] -- Make sure we make some move
      if(move:match('none')) then
        print(game .. "{" .. pWinner .. " wins}\n")
        io.flush()
        return nil
      end
      -- It’s better to play a random good looking move so each game differs
      local consider = {}
      local showMoves = ""
      local maxV = -100000000
      -- Note that UCI considers move values from the point of view of
      -- the player to play. So, if it’s Black’s move, positive scores
      -- favor Black, and if it’s White’s move, positive scores favor 
      -- White
      for k,v in sPairs(multiMoves) do 
        if type(v) == 'table' and v.v then
          if tonumber(v.v) > maxV then maxV = tonumber(v.v) end
        end
      end
      for k,v in sPairs(multiMoves) do
        if type(v) == 'table' and v.v and v.m then
          showMoves = showMoves .. tostring(v.m) .. " " .. 
                      tostring(v.v) .. " "
          if tonumber(v.v) >= maxV - 15 then
            table.insert(consider,v.m)
          end
        end
      end
      move = consider[rg32.random(#consider)]
      print("(" .. showMoves .. ") " .. move)
      -- Note the move we decided on
      game = game .. move .. ' '
      io.flush()
      -- Now, tell the engine the move we made
      w:write('position fen ' .. thisFEN .. ' moves ' .. move .. "\n")
      -- print('position fen ' .. thisFEN .. ' moves ' .. move .. "\n")
      w:write("d\n")
      w:flush()
      -- And see what the new position looks like
      thisFEN = grabFEN(r)
      if pWinner == "Black" then
        pWinner = "White"
      else
        pWinner = "Black"
        movenumber = movenumber + 1
        game = game .. tostring(movenumber) .. '. '
        if(movenumber > 200) then
          print(game .. "{draw by over 200 moves}\n")
          return nil
        end
      end
      r:flush()
      if MultiPV > 2 then 
        MultiPV = MultiPV - 1
        w:write("setoption name MultiPV value " .. tostring(MultiPV) .. "\n")
      end
      w:write("go depth " .. searchPly .. "\n")
      w:flush()
      multiMoves = {}
    end
  end
end

function doEval(vSetup)
  if vSetup:lower() == "chess960" then
    for a=0,959 do
      local position = board2ASCII(Chess960(a))
      local FEN = board2FEN(position)
      FEN=FEN:gsub("_"," ")
      evalPosition(position:upper(), FEN, opening)
    end
  elseif vSetup:lower() == "freeling" then
    for a=0,959 do
      local position = board2ASCII(Chess960(a))
      if cornerRooks(position) and kingRightOfQueen(position) then
        -- Line symmetry
        local FEN = board2FEN(position, true, false, true)
        FEN=FEN:gsub("_"," ")
        evalPosition(position:upper() .. " (Freeling)", FEN, opening) 
        -- Point symmetry (Black position mirrored relative to White)
        local FEN = board2FEN(position, true, true, true)
        FEN=FEN:gsub("_"," ")
        evalPosition(position:upper() .. " (Freeling mirror)", FEN, opening) 
      end
    end 
  else
    local FEN = board2FEN(vSetup)
    FEN=FEN:gsub("_"," ")
    print(vSetup, FEN)
    evalPosition(vSetup, FEN, opening)
  end
end

function doGame(vSetup)
  local FEN = board2FEN(vSetup)
  FEN=FEN:gsub("_"," ")
  runGame(MultiPV, FEN)
end

if actionType == "eval" then
  doEval(vSetup)
elseif actionType == "play" then
  doGame(vSetup)
else
  print("Unknown action, type EvalOrPlay --help for help")
end

w:write("quit\n") -- Let’s have a clean exit
io.flush()
