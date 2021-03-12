-- Lunacy (Lua 5.1) script to mirror a Congo Zillions saved game
-- This is here so games always have the first non-center file move
-- be on (from White’s viewpoint) the right hand side.
--
-- Placed in the public domain 2021 by Sam Trenholme

----------------------- pStrSplit() -----------------------
-- This splits a string on a given Lua regular expression
-- Input: string, split regex
-- Output: An array split on the regex (e.g. "%s+" or "%,")
-- Example usage:
-- a="Hello, there, I am glad to meet you.  How are you?  I am fine.  Thanks."
-- for _,v in ipairs(pStrSplit(a,"%s+")) do print(v) end
function pStrSplit(s, splitOn)
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

l = io.read()
while l do
  f = pStrSplit(l,"%s+") -- AWK-style splitting
  l = l:gsub("E(%d)","H%1")
  l = l:gsub("F(%d)","I%1")
  l = l:gsub("G(%d)","J%1")
  l = l:gsub("A(%d)","G%1")
  l = l:gsub("B(%d)","F%1")
  l = l:gsub("C(%d)","E%1")
  l = l:gsub("H(%d)","C%1")
  l = l:gsub("I(%d)","B%1")
  l = l:gsub("J(%d)","A%1")
  print(l)
  l = io.read()
end

