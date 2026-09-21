#!/bin/sh
_rem=--[=[
# This script converts a saved game from Zillions' weird format
# (Assuming a .zrf file which is close the the .zrf used for Chess)
# in to a verbose PGN file

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

seen = {}
out = ""
for line in io.stdin:lines() do
  if(line:match("^%d")) then
    fields = split(line,"%s+")
    if #fields >= 5 then
      moveNumber = fields[1]
      show = moveNumber
      if seen[moveNumber] then show = "" end
      seen[moveNumber] = true
      piece = fields[2]
      from = fields[3]
      to = fields[5]
      pieceName = ""
      if piece == "Rook" then pieceName="R" 
      elseif piece == "King" then pieceName = "K"
      elseif piece == "Queen" then pieceName = "Q"
      elseif piece == "Knight" then pieceName = "N"
      elseif piece == "Bishop" then pieceName = "B"
      elseif piece == "Archbishop" then pieceName = "A"
      elseif piece == "Marshal" then pieceName = "C"
      end
      if line:match("King") and line:match("Rook") then
        if to:match("g") then
          out = out .. show .. " O-O "
        else
          out = out .. show .. " O-O-O "
        end
      else
        out = out .. show .. " " .. pieceName .. from .. to .. " "
      end
    end
  end
end
print(out)
