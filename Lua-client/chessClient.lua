-- Placed in the public domain 2021 by Sam Trenholme
-- This is a lunacy (Lua + Steve Donovan's popen lib) implementation of
-- a simple Chess/Chess variants client
--
-- This client is a “randomized” version of Fairy-Stockfish:  It looks
-- at the top MultiPV number of moves (default: 3), and chooses one within
-- 50 centipawns of what it thinks is the best move at random.
--
-- This client requires the Fairy-Stockfish program to be installed
-- and available with the name fairy-stockfish-largeboard_x86-64
-- (if it has another name, change "ChessEngine" below)
--
-- See https://github.com/ianfab/Fairy-Stockfish for the Chess engine
ChessEngine = "fairy-stockfish-largeboard_x86-64"
-- This is the number of lines we look at and consider for our next move
MultiPV = 3
-- The name of the variant we will look at.  This needs to be a variant
-- Fairy-Stockfish supports
variantName = "capablanca"
-- variantName = "chess"
-- The opening setup (or position) we will play from in the game
-- This is an argument given to the Fairy-Stockfish "setboard" command
variantFEN = "ranbqkbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RANBQKBNCR " ..
             "w KQkq - 0 1"
-- variantFEN = false -- Use default opening setup for variant
-- After this many plies are searched, decide on a move to make
searchPly = 11
-- Here be dragons below

if searchPly < 7 then print("searchPly too small") os.exit(1) end

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
if variantFEN then
  w:write("setboard " .. variantFEN .. "\n")
end
w:write("d\n")
w:flush()
lineFromEngine = ""
while not string.match(lineFromEngine,'^Key') do
  lineFromEngine = r:read()
  print(lineFromEngine)
end
io.flush()
w:write("analyze\n")
w:flush()
math.randomseed(os.time())
game = ""
gamePly = 1
movelist = {}
movevalue = {}
maxvalue = -10000000
acceptMove = false
bestMove = ""
while true do
  lineFromEngine = r:read()
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
    w:write("d\n")
    w:flush()
    lineFromEngine = ""
    while not string.match(lineFromEngine,'^Key') do
      lineFromEngine = r:read()
      print(lineFromEngine)
    end
    print(game)
    print("\nERROR")
    os.exit(1) -- Ended with Error
  end
  if #fields > 7 then
    local ply = tonumber(fields[1])
    local value = tonumber(fields[2])
    local time = tonumber(fields[3])
    local move = fields[8]
    if ply == searchPly - 5 then acceptMove = true end
    if ply == searchPly and movevalue[move] == nil and acceptMove then
      movelist[#movelist + 1] = move
    end
    if ply == searchPly then
      movevalue[move] = value
      if value > maxvalue then 
        maxvalue = value 
        bestMove = move
      end
    end
    if ply > searchPly and #movelist > 0 then
      local thisValue = -10000000
      local toMove = ""
      local limit = 20
      game = game .. "("
      for a = 1, #movelist do
        local move = movelist[a]
	game = game .. " " .. move .. " "
	if movevalue[move] then
	  game = game .. " " .. tostring(movevalue[move]) .. " "
	else
          game = game .. " [no value] "
	end
      end
      game = game .. ") "
      while thisValue < maxvalue - 50 and limit > 0 do
        toMove = movelist[math.random(#movelist)]
	if movevalue[toMove] ~= nil then
	  thisValue = movevalue[toMove]
	end
	limit = limit - 1
      end
      if limit < 2 then
        toMove = bestMove
      end
      if #toMove < 1 then
        game = game .. lineFromEngine
        w:write("d\n")
        w:flush()
        lineFromEngine = ""
        while not string.match(lineFromEngine,'^Key') do
          lineFromEngine = r:read()
          print(lineFromEngine)
        end
        print(game)
        print("\nERROR")
        os.exit(1)
      end
      game = game .. toMove .. " "
      print(gamePly, toMove)
      io.flush()
      gamePly = gamePly + 1
      w:write(toMove .. "\n")
      w:flush()
      lineFromEngine = r:read()
      lineFromEngine = r:read()
      movelist = {}
      movevalue = {}
      maxvalue = -10000000
      acceptMove = false
    end
  end
end


