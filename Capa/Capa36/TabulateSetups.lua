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

local low = 20
local high = 29
if #arg >= 1 then
  if arg[1]:match("h") then
    print("Usage: TabulateSetups.lua {low} {high}")
    print("Low default is 20; high default is 29; both are numbers")
    os.exit(0)
  end
  low = tonumber(arg[1])
end
if #arg >= 2 then
  high = tonumber(arg[2])
end

if high < low then
  print("High is lower than low!")
  print("Try this: TabulateSetups.lua 20 25")
  os.exit(0)
end

eval = {}
for ply=low,high do
  local handle = nil
  local filename = ""
  if ply >= 10 then
    filename = tostring(ply) .. "ply.txt"
  else
    filename = "0" .. tostring(ply) .. "ply.txt"
  end
  handle = io.open(filename,"rb")
  if not handle then 
    print("Fatal: Could not open file " .. filename)
    os.exit(0)
  end
  for line in handle:lines() do
    local fields = split(line,"%s+")
    if fields[3] then
      local setup = fields[1]
      local val = fields[3]
      if not eval[setup] then
        eval[setup] = {}
      end
      eval[setup][ply] = tonumber(val)
    end
  end
  handle:close()
end

-- Tabulate that data  
for setup,data in sPairs(eval) do
   local total = 0
   local tab = 0
   for ply,eval in sPairs(data) do
     local mult = ply - low + 1
     total = total + mult
     tab = tab + (mult * eval)
   end
   print(string.format("%.2f",tab/total),setup)
end
