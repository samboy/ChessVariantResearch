-- Placed in the public domain 2021 by Sam Trenholme
-- This is a lunacy (Lua + Steve Donovan's popen lib) implementation of
-- a simple Chess/Chess variants client
-- This client requires the Fairy-Stockfish program to be installed
-- and available with the name fairy-stockfish-largeboard_x86-64
-- (if it has another name, change "ChessEngine" below)
-- See https://github.com/ianfab/Fairy-Stockfish for the Chess engine
ChessEngine = "fairy-stockfish-largeboard_x86-64"
-- This is the number of lines we look at and consider for our next move
MultiPV = 3
-- The name of the variant we will look at.  This needs to be a variant
-- Fairy-Stockfish supports
variantName = "capablanca"
-- The opening setup (or position) we will play from in the game
-- This is an argument given to the Fairy-Stockfish "setboard" command
variantFEN = "ranbqkbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RANBQKBNCR " ..
             "w KQkq - 0 1"
-- After this many plies are searched, decide on a move to make
searchPly = 7
-- Here be dragons below

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

if popen == nil then
  print("I need Steve Donovan's popen lib to continue!")
  os.exit(1)
end

w,r = popen.popen2(ChessEngine)
w:write("setoption name MultiPV value " .. tostring(MultiPV) .. "\n")
w:write("xboard\n")
w:write("variant " .. variantName .. "\n")
w:write("setboard " .. variantFEN .. "\n")
w:write("d\n")
w:flush()
lineFromEngine = ""
while not string.match(lineFromEngine,'^Key') do
  lineFromEngine = r:read()
  print(lineFromEngine)
end
w:write("analyze\n")
w:flush()
math.randomseed(os.time())
game = ""
gamePly = 1
movelist = {}
movevalue = {}
maxvalue = -100000
while true do
  lineFromEngine = r:read()
  print(lineFromEngine) -- DEBUG
  local fields = rStrSplit(lineFromEngine,' ')
  if #fields > 0 and string.match(fields[1],'0%-1') then 
    game = game .. lineFromEngine
    print(game)
    os.exit(0)
  end
  if #fields > 0 and string.match(fields[1],'1%-0') then 
    game = game .. lineFromEngine
    print(game)
    os.exit(0)
  end
  if #fields > 0 and string.match(fields[1],'1%/2%-1%/2') then 
    game = game .. lineFromEngine
    print(game)
    os.exit(0)
  end
  if #fields > 0 and string.match(fields[1],'Error') then 
    game = game .. lineFromEngine
    print(game)
    os.exit(1) -- Ended with Error
  end
  if #fields > 7 then
    local ply = tonumber(fields[1])
    local value = tonumber(fields[2])
    local time = tonumber(fields[3])
    local move = fields[8]
    if ply == searchPly and movevalue[move] == nil then
      movelist[#movelist + 1] = move
    end
    if ply == searchPly then
      movevalue[move] = value
      if value > maxvalue then maxvalue = value end
    end
    if ply > searchPly and #movelist > 0 then
      local thisValue = -100000
      local toMove = ""
      while thisValue < maxvalue - 50 do
        toMove = movelist[math.random(#movelist)]
	if movevalue[toMove] ~= nil then
	  thisValue = movevalue[toMove]
	end
      end
      game = game .. toMove .. " "
      print(gamePly, toMove)
      gamePly = gamePly + 1
      w:write(toMove .. "\n")
      w:flush()
      lineFromEngine = r:read()
      lineFromEngine = r:read()
      movelist = {}
      movevalue = {}
      maxvalue = -100000
    end
  end
end


