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

-- Given a board array, output the setup as ASCII 
function board2ASCII(board)
  local out = ""
  for a=1,#board do
    out = out .. tostring(board[a])
  end
  return out
end

-- Given a board array, output the setup as PGN
function board2PGN(board)
  local out = ""
  local line = ""
  if type(board) == 'table' then
    line = board2ASCII(board)
  elseif type(board) == 'string' then
    line = board
  end 
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

function regexSplit(subject, splitOn)
  if not splitOn then splitOn = "," end
  local place = true
  local out = {}
  local mark
  local last = 1
  while place do
    place, mark = string.find(subject, splitOn, last, false)
    if place then
      table.insert(out,string.sub(subject, last, place - 1))
      last = mark + 1
    end
  end
  table.insert(out,string.sub(subject, last, -1))
  return out
end

-- Like pairs() but sorted
function sPairs(inTable, sFunc)
  if not sFunc then
    sFunc = function(a, b)
      local ta = type(a)
      local tb = type(b)
      if(ta == tb)
        then return a < b 
      end
      return tostring(ta) <
             tostring(tb)
    end
  end
  local keyList = {}
  local index = 1
  for k,_ in pairs(inTable) do
    table.insert(keyList,k)
  end
  table.sort(keyList, sFunc)
  return function()
    key = keyList[index]
    index = index + 1
    return key, inTable[key]
  end
end

-- Output a table on standard output
function showTable(inTable) 
  if type(inTable) ~= 'table' then 
    print("Type of inTable is " .. type(inTable))
    return nil
  end
  for k,v in sPairs(inTable) do print(k,v) end
end

-- Open up a file and grab the evals
function grabEvals(fname) 
  local handle = io.open(fname,"rb")
  if not handle then return nil end
  local out = {}
  local line = ""
  for line in handle:lines() do
    line = line:gsub("[\r\n]","")
    local fields = regexSplit(line, "%s+")
    if fields and #fields >= 3 then
      local key = fields[1]
      local value = fields[3]
      out[key] = value
    end
  end
  return out
end

-- Return a list with the 720 Capa720 setups in order
function Capa720keys()
  local out = {}
  for a=0,719 do
    local board = Capa720(a)
    local key = board2ASCII(board)
    key = string.upper(key)
    table.insert(out,key)
  end
  return out
end

-- Iterator which allows us to have a for loop where the string is the 
-- Capa720 setup
function CapaIterator()
  local a = 0
  return function()
    local last = a
    if(a >= 720 or a < 0) then return nil end
    a = a + 1
    return string.upper(board2ASCII(Capa720(last)))
  end
end

evals = {}
evals[18] = grabEvals("Capa720evalNNUE18ply.txt")
evals[19] = grabEvals("Capa720evalNNUE19ply.txt")
evals[20] = grabEvals("Capa720evalNNUE20ply.txt")
evals[21] = grabEvals("Capa720evalNNUE21ply.txt")
evals[22] = grabEvals("Capa720evalNNUE22ply.txt")
evals[23] = grabEvals("Capa720evalNNUE23ply.txt")
evals[24] = grabEvals("Capa720evalNNUE24ply.txt")

eval = {}

for a in CapaIterator() do
  eval[a] = {}
  eval[a]['values'] = {}
  local total = 0
  for b=18,24 do
    local value = evals[b][a]
    eval[a]['values'][b] = value
    total = total + value
  end
  local mean = total / 7
  local sd = 0 -- Standard deviation
  eval[a]['mean'] = mean
  for b=18,24 do
    local value = eval[a]['values'][b]
    local dev = value - mean
    dev = dev * dev
    sd = sd + dev
  end
  sd = sd / 7
  sd = sd ^ 0.5
  eval[a]['sd'] = sd
end

function evalSorter(a, b)
  if not a or not b then return false end
  if not eval[a] or not eval[b] then return true end
  local va = eval[a]['mean'] + eval[a]['sd']
  local vb = eval[b]['mean'] + eval[b]['sd']
  return va < vb
end

for k,v in sPairs(eval, evalSorter) do
  print(k,v['mean'],v['sd'])
end
