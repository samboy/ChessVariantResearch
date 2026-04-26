#!/bin/sh
_rem=--[=[
# This converts a Capa720 setup in to a snippet to put in a
# Zillions rule file.  The base Zillions files this snippet will
# work with are in the file d20Capa/d20Capa.7z

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

function piece(setup, piece, name, rank)
  rank = tostring(rank)
  if type(setup) ~= 'string' then setup = "RNABMKBQNR" end
  setup = setup:upper()
  if not setup:match("^R....K...R$") then setup = "RNABMKBQNR" end
  if type(piece) ~= 'string' then piece = "M" end
  if type(name) ~= 'string' then name = "Marshal" end
  local file="abcdefghij"
  local out = ""
  local index=setup:find(piece)
  if not index then return "" end
  while index do
    if not out or out:len() < 1 then
      out = out .. "(" .. name 
    end
    out = out .. " " .. file:sub(index,index) .. rank
    index = setup:find(piece,index + 1)
  end
  out = out .. ")\n"
  return out
end    

function Variant(setup)
  if type(setup) ~= 'string' then setup = "RNABMKBQNR" end
  setup = setup:upper()
  if not setup:match("^R....K...R$") then setup = "RNABMKBQNR" end
  setup = setup:gsub("C","M")
  out = [[(variant
   (title "]] .. setup .. [[")
   (description "This is a Chess variant played on a 10 x 8 board.
Each player has the usual Chess set plus two more Pawns, an Archbishop, and a
Marshal. The Archbishop moves like a Knight or Bishop, and the Marshal
moves like a Knight or Rook.\\Castling is
different: when a King castles, he may move 3 spaces toward the Rook.
Pawns may promote to one of the new pieces as well as the standard Chess
pieces.  The rules are otherwise as in FIDE Chess.")
   (history "8x10 chess variants with these two extra pieces have
existed since the 17th century.  In the 20th century, world Chess
champion Jose Raul Capablanca developed an interest 8x10 chess using these pieces.
Capablanca wanted to 'introduce in the game
new forces which would necessarily throw the players on to their own
resources, and give much greater scope to the imagination and to the
creative power of the individual player.'\\ 
   ")
   (strategy "There is no clear consensus on the value of the pieces in this
Chess variant.  However, it appears that a bishop is a half-pawn more valuable
than a knight, two knights are more valuable than a rook, an archbishop is
worth more than two knights, a marshall is worth more than an archbishop,
a queen is worth more than a marshall, two rooks are worth more than a queen,
a marshall is worth more than a rook and knight, a rook and knight are worth
more than an archbishop, and, finally, a marshall is worth more than two
bishops.\\
This game is more tactical than FIDE chess;
for people who love the chess of Morphy and other great players of the
romantic era, this variant will be very enjoyable.");
   (option "prevent flipping" 3)
   (win-sound "Audio\Orchestra_CF.wav")
   (loss-sound "Audio\Orchestra_FC.wav")
   (click-sound "Audio\Pickup.wav")
   (release-sound "Audio\WoodThunk.wav")
   (players White Black)
   (turn-order White Black)
   (board (Board10x8-Definitions) )

   (board-setup 
     (White
         (Pawn a2 b2 c2 d2 e2 f2 g2 h2 i2 j2)
         (Rook a1 j1)
         (King f1)  ]]
   out = out .. piece(setup, "A", "Archbishop", 1)
   out = out .. piece(setup, "B", "Bishop", 1)
   out = out .. piece(setup, "M", "Marshal", 1)
   out = out .. piece(setup, "N", "Knight", 1)
   out = out .. piece(setup, "Q", "Queen", 1)
   out = out .. [[) 
     (Black
         (Pawn a7 b7 c7 d7 e7 f7 g7 h7 i7 j7)
         (Rook a8 j8)
         (King f8)  ]]
   out = out .. piece(setup, "A", "Archbishop", 8)
   out = out .. piece(setup, "B", "Bishop", 8)
   out = out .. piece(setup, "M", "Marshal", 8)
   out = out .. piece(setup, "N", "Knight", 8)
   out = out .. piece(setup, "Q", "Queen", 8)
   out = out .. [[ 
      )
   )

   (loss-condition (White Black) (checkmated King) )
)]]
  return out
end

if #arg < 1 then setup = "RNABMKBQNR" else setup = arg[1] end
if setup:len() ~= 10 then setup = "RNABMKBQNR" end
print(Variant(setup))
