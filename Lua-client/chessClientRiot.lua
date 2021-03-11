-- Placed in the public domain 2021 by Sam Trenholme
-- This is a lunacy (Lua + Steve Donovan's spawner lib) implementation of
-- a simple Chess/Chess variants client
--
-- This particular client is tuned to make good games from the Compromised
-- Defense line of the Evans Gambit.  It even has a tweak to make Stockfish
-- follow the opening books more often than Stockfish wants to (see below)
--
-- This client is a “randomized” version of Fairy-Stockfish:  It looks
-- at the top MultiPV number of moves (default: 3), and chooses one within
-- 50 centipawns of what it thinks is the best move at random.
--
-- This client requires the Fairy-Stockfish program to be installed
-- and available with the name fairy-stockfish-largeboard_x86-64
-- (if it has another name, change "ChessEngine" below)

-- Evans Gambit Compromised defense.  Well known RNBQKBNR (standard Chess)
-- line
EvansCompromised = "e2e4 e7e5 g1f3 b8c6 f1c4 f8c5 b2b4 c5b4 c2c3 " ..
                   "b4a5 d2d4 e5d4 e1g1 d4c3"

-- I would play the Munzio with the Black pieces
MunzioRiot1 = "e2e4 e7e5 f2f4 e5f4 g1f3 g7g5 f1c4 g5g4 e1g1 g4f3 d1f3 " ..
             "d8f6 d2d3 f8h6 b1c3 " 
-- Ne7 (g8d7) looks to be Black's best reply, but if Black plays Nc6? we 
-- may get this
MunzioRiot2 = MunzioRiot1 .. "b8c6 c3d5 f6d6 f3h5 g8e7 d5c7 d6e7 c4f7 " ..
             "e8d8 h5h6 " 
             
-- params is a table with the "user tunable" parameters
params = {
  -- See https://github.com/ianfab/Fairy-Stockfish for the Chess engine
  -- This is the name of the chess engine, as it appears in one's $PATH
  ChessEngine = "fairy-stockfish",
  -- This is the number of lines we look at and consider for our next move
  MultiPV = 3,
  -- The name of the variant we will look at.  This needs to be a variant
  -- Fairy-Stockfish supports
  -- variantName = "capablanca",
  variantName = "chess",
  -- The opening setup (or position) we will play from in the game
  -- Note: This currently only works with 8xN games (8x8, 8x10, 8x12, etc.)
  -- variantSetup = "RANBQKBNCR",
  -- It's also possible to set up any arbitrary FEN, not just a mirrored
  -- 8x# backrank opening setup
  -- This is an argument given to the Fairy-Stockfish "setboard" command
  -- variantFEN = "ranbqkbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RANBQKBNCR " ..
  --          "w KQkq - 0 1",
  variantFEN = false, -- Use default opening setup for variant
  -- After this many plies are searched, decide on a move to make
  searchPly = 21,
  -- Opening to play.  Format is like this: "f2f4 f7f5", where each move has
  -- four letters (from, to) or five letters (for pawn promotions: b7b8q)
  -- King move for castling (e.g. e1g1 with normal RNBQKBNR chess).  Spaces
  -- between openings
  -- opening = "f2f4 i8h6",
  -- opening = EvansCompromised,
  opening = MunzioRiot2,
  -- opening = false,
}

-- After 8. Qb3 Qf6 Stockfish prefers 9. Bg5 over the standard 9. e5
-- That in mind, let's force it to play 8. Qb3 Qf6 9. e5 15% of the time
StockfishBug = " d1b3 d8f6 e4e5"
math.randomseed(os.time())
if math.random() > .5 then
  params["opening"] = MunzioRiot1 
end

-- Here be dragons below
ChessEngine = params["ChessEngine"]
MultiPV = tonumber(params["MultiPV"])
variantName = params["variantName"]
if type(params["variantFEN"]) == "string" then
  variantFEN = params["variantFEN"]
else
  variantFEN = false
end

-- If they specify a variantSetup (e.g. RNBQKBNR or RANBQKBNCR), convert
-- that in to the appropriate 8x# FEN string
if type(params["variantSetup"]) == "string" then
  local setup = params["variantSetup"]
  -- Black's pieces
  variantFEN = setup:lower() .. "/"
  -- Black's pawns
  for a = 1,#setup do
    variantFEN = variantFEN .. "p"
  end
  -- The 4-row blank area between setups
  -- This code currently only works with 8x# setups
  for a = 1, 4 do
    variantFEN = variantFEN .. "/" .. tostring(#setup)
  end
  variantFEN = variantFEN .. "/"
  -- White's pawns
  for a = 1,#setup do
    variantFEN = variantFEN .. "P"
  end
  variantFEN = variantFEN .. "/" .. setup:upper() .. " w KQkq - 0 1"
end

-- How many ply do we look ahead per move
searchPly = tonumber(params["searchPly"])

-- Sanity for numeric vaues
if not MultiPV or MultiPV < 2 then
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
if type(params["opening"]) == "string" then
  thismove = 1
  openmove = rStrSplit(params["opening"]," ")
end 

if spawner == nil then
  print("I need Steve Donovan's spawner lib to continue!")
  print("Download Lunacy at https://github.com/samboy/lunacy")
  os.exit(1)
end

w,r = spawner.popen2(ChessEngine)
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

-- If there is an opening, play it
while thismove > 0 and thismove <= #openmove do
  print("OPENING MOVE: ",openmove[thismove])
  w:write(openmove[thismove] .. "\n")
  w:write("d\n")
  w:flush()
  lineFromEngine = ""
  while not string.match(lineFromEngine,'^Key') do
    lineFromEngine = r:read()
    print(lineFromEngine)
  end
  io.flush()
  thismove = thismove + 1
end
   
w:write("analyze\n")
w:flush()
game = ""
-- Note setup, if specified as VariantSetup
if type(params["variantSetup"]) == "string" then
  game = game .. "(Setup: " .. params["variantSetup"] .. ") "
end
-- Note opening, if any
if openmove and type(openmove) == "table" then
  game = game .. "(Opening) "
  for a = 1, #openmove do
    game = game .. openmove[a] .. " "
  end
end

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
      local evals = ""
      for a = 1, #movelist do
        local move = movelist[a]
	evals = evals .. " " .. move .. " "
	if movevalue[move] then
	  evals = evals .. " " .. tostring(movevalue[move]) .. " "
	else
          evals = evals .. " [no value] "
	end
      end
      game = game .. evals .. ") "
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
      print(gamePly, toMove, evals)
      w:write(toMove .. "\n")
      w:write("stop\n")
      w:write("d\n")
      w:flush()
      lineFromEngine = ""
      while not string.match(lineFromEngine,'^Key') do
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
        w:write("stop\n")
        w:flush()
        print(lineFromEngine)
      end
      w:write("analyze\n")
      w:flush()
      io.flush()
      gamePly = gamePly + 1
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


