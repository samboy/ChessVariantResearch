#!/usr/bin/env lua

-- Placed in the public domain 2021 by Sam Trenholme
-- Input is standard input
-- Output is standard output
-- Given a PGN file on standard input, output only the games which
-- start off with the Compromised defense of the Evans Gambit

local linecount = 0
local game = ""
local line = ""
local isDesiredOpening = false

-- Right now this is Evans Gambit, compromised defense
local desiredOpening =
 '1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. b4 Bxb4 5. c3 Ba5 6. d4 exd4 7. O%-O dxc3'

for line in io.lines() do
  if line:match('^%[Event') then
    if isDesiredOpening then 
      print(game)
    end
    isDesiredOpening = false
    game = line .. "\n"
  elseif line:match(desiredOpening) then
    isDesiredOpening = true
    game = game .. line .. "\n"
  else
    game = game .. line .. "\n"
  end
end

