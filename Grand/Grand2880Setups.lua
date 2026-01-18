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
-- In Capa720: 
-- * The rooks are in the corners
-- * The king is on the f file
-- * The bishops are on opposite colors
-- * The other five pieces are placed anywhere
-- Setup is a number from 0 to 719
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

-- Output a Grand2880 setup
-- In Grand2880
-- * The rooks are in the corners
-- * The other pieces are on the second rank
-- * The bishops are on opposite colors
-- * The Queen, from White’s POV, is left of the King
-- * The pieces are otherwise placed anywhere
-- Setup is a number from 0 to 2879
function Grand2880(setup)
  if type(setup) ~= 'number' then setup = 1 end
  local set = setup
  local board = initBoard(10)
  board[1] = 'r'
  board[10] = 'r'
  -- Light bishop
  local bishop1 = set % 4
  set = math.floor(set / 4)     
  bishop1 = bishop1 * 2
  bishop1 = bishop1 + 3
  board[bishop1] = 'b'
  -- Dark bishop
  local bishop2 = set % 4
  set = math.floor(set / 4)     
  bishop2 = bishop2 * 2
  bishop2 = bishop2 + 2
  board[bishop2] = 'b'
  -- Marshal
  local marshal = set % 6
  set = math.floor(set / 6)
  marshal = marshal + 1
  addPiece(board,'c',marshal) 
  -- Archbishop
  local arch = set % 5
  set = math.floor(set / 5)
  arch = arch + 1
  addPiece(board,'a',arch) 
  -- Queen and king, such that queen is always left of king
  local QueenKing = {{1,1},{1,2},{1,3},{2,1},{2,2},{3,1}}
  local qk = set % 6
  qk = qk + 1
  local queen = QueenKing[qk][1]
  local king = QueenKing[qk][2]
  addPiece(board,'q',queen)
  addPiece(board,'k',king)
  -- The knights
  addPiece(board,'n')
  addPiece(board,'n')
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

-- Given a Grand chess 2880 board array, output the setup as PGN
function board2GrandPGN(board)
  local out = ""
  local topline = board2ASCII(board)
  print(topline) -- DEBUG
  topline = "1" .. string.sub(topline,2,9) .. "1"
  local bottomline = "r8r"
  local pawns = ""
  for a=1,#board do
    pawns = pawns .. "p"
  end
  local empty = tostring(#board)
  out = bottomline .. "/" .. topline .. "/" .. pawns .. "/" 
  out = out .. empty .. "/" .. empty .. "/" .. empty .. "/" .. empty .. "/" 
  out = out .. pawns:upper() .. "/" .. topline:upper() .. "/"
  out = out .. bottomline:upper() .. "_w_KQkq_-_0_1"
  return out
end

-- Given a board array and a list of pieces with their moves, see
-- how many pawns are guarded
function pawnsGuarded(board, pieces)
  local out = {}
  for a=1,#board do
    out[a] = 0
  end
  for a=1,#board do
    local p = pieces[board[a]]
    if type(p) == 'table' then
      for b=1,#p do
        local q = p[b]
        if a + q > 0 and a + q <= #board then -- This check isn’t needed
          out[a + q] = out[a + q] + 1
        end
      end
    end
  end
  return out
end

-- Input: Board, pieces
-- Output: Total of how much the pawns are guarded
function pawnsGuardedCount(board, pieces)
  local out = 0
  local t = pawnsGuarded(board, pieces)
  for a=1,#t do
    out = out + t[a] 
  end
  return out
end

-- Yes or no: Are all pawns guarded
function allPawnsGuarded(board, pieces)
  local look = pawnsGuarded(board, pieces)
  local out = true
  for a=1,#look do
    if look[a] == 0 then
      out = false
    end
  end
  return out
end

-- Yes or no: Are all pawns guarded, and all pawns in front of the king
-- Double guarded
function kingPawns2Guarded(board, pieces, kingFile)
  if not kingFile then kingFile = 6 end
  local look = pawnsGuarded(board, pieces)
  local out = true
  for a=1,#look do
    if look[a] == 0 then
      out = false
    end
  end
  for a=kingFile - 1,kingFile + 1 do
    if look[a] < 2 then
      out = false
    end
  end
  return out
end

-- Return the pieces we have in Capa chess, same pieces used in Grand
function capaPieces() 
  local out = {}
  out['a'] = {-2, -1, 1, 2} -- Archbishop (knight + Bishop)
  out['b'] = {-1, 1}        -- Bishop
  out['c'] = {-2, 0, 2}     -- Rook + Bishop
  out['k'] = {-1, 0, 1}     -- King
  out['m'] = {-2, 0, 2}     -- Rook + Bishop
  out['n'] = {-2, 2}        -- kNight
  out['p'] = {-1, 1}        -- pawn
  out['q'] = {-1, 0, 1}     -- Queen
  out['r'] = {0}            -- Rook
  return out
end

for setup=0,2879 do
  local board = Grand2880(setup)
  if kingPawns2Guarded(board, capaPieces()) or true then
    print(board2GrandPGN(board),
          pawnsGuardedCount(board, capaPieces()),setup)
  end
end
