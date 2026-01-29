-- Placed in the public domain 2021,2026 by Sam Trenholme
-- This is a lunacy (Lua + Steve Donovan's spawner lib) implementation of
-- a simple Chess/Chess variants client
--
-- This client is a “randomized” version of Stockfish:  It looks
-- at the top MultiPV number of moves (default: 3), and chooses one within
-- 30 centipawns of what it thinks is the best move at random.
--
-- This client requires the Stockfish program to be installed
-- and available with the name stockfish
-- (if it has another name, change "ChessEngine" below)

IsVerbose = false

-- Utility function: Sorted pairs()
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

gSeed = os.time()

plies = 18
if #arg >= 1 then
  plies = arg[1]
  if plies == "--help" or plies == "-help" or plies == "help" then
    print("Usage: Play12plyUCIClassicChess.lua {plies} {seed}")
    print("Example: Play12plyUCIClassicChess.lua 18")
    os.exit(0)
  end
end
if #arg >= 2 then
  gSeed = arg[2] -- Yes, seeds can be strings (with Lunacy)
end
rg32.randomseed(gSeed)

-- params is a table with the "user tunable" parameters
params = {
  -- See https://github.com/ianfab/Fairy-Stockfish for the Chess engine
  -- This is the name of the chess engine, as it appears in one's $PATH
  ChessEngine = "stockfish",
  -- This is the number of lines we look at and consider for our next move
  MultiPV = 3,
  -- The name of the variant we will look at.  This needs to be a variant
  -- Fairy-Stockfish supports
  -- variantName = "capablanca",
  variantName = "chess",
  -- The opening setup (or position) we will play from in the game
  -- Note: This currently only works with 8xN games (8x8, 8x10, 8x12, etc.)
  variantSetup = vSetup,
  -- It's also possible to set up any arbitrary FEN, not just a mirrored
  -- 8x# backrank opening setup
  -- This is an argument given to the Fairy-Stockfish "setboard" command
  -- variantFEN = "ranbqkbncr/pppppppppp/10/10/10/10/PPPPPPPPPP/RANBQKBNCR " ..
  --          "w KQkq - 0 1",
  -- variantFEN = false, -- Use default opening setup for variant
  -- After this many plies are searched, decide on a move to make
  searchPly = plies,
  -- Opening to play.  Format is like this: "f2f4 f7f5", where each move has
  -- four letters (from, to) or five letters (for pawn promotions: b7b8q)
  -- King move for castling (e.g. e1g1 with normal RNBQKBNR chess).  Spaces
  -- between openings
  -- NOTE: This is disabled for now
  opening = false,
}

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
  print("searchPly too small/not set, using 18") 
  searchPly = 18
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
-- Openings disabled for now
--if type(params["opening"]) == "string" then
--  thismove = 1
--  openmove = rStrSplit(params["opening"]," ")
--end 

if spawner == nil then
  print("I need Steve Donovan's spawner lib to continue!")
  print("Download Lunacy at https://github.com/samboy/lunacy")
  os.exit(1)
end

w,r = spawner.popen2(ChessEngine)
w:write("setoption name MultiPV value " .. tostring(MultiPV) .. "\n")
-- Load NNUE
w:write("ucinewgame\n")
w:write("position startpos\n")
FENseen = {}
thisFEN = ""
function processFENline(hash, line)
  if not hash then hash = {} end
  line = line:gsub('[\r\n]','')
  line = line:gsub('^Fen: ','')
  local outLine = line -- Let engine know move number, 50-move count
  line = line:gsub('%d+%s%d+$','') -- Remove move number, 50-move count
  if not hash[line] then
    hash[line] = 1
  else
    hash[line] = hash[line] + 1
    if hash[line] > 7 then
      print(game .. "{draw by repetition}\n")
      os.exit(0)
    end 
  end
  return outLine, hash -- We actually modify hash in place, but still
end
function grabFEN(handle)
  local out = ""
  while not string.match(lineFromEngine,'^Key') do
    lineFromEngine = handle:read()
    if IsVerbose then print(lineFromEngine) end
    if lineFromEngine:match('^Fen: ') then
      out = processFENline(FENseen, lineFromEngine)
    end
    --print(lineFromEngine)
  end
  print(out)
  return out
end

w:write("d\n")
w:flush()
lineFromEngine = ""
thisFEN = grabFEN(r)
io.flush()

-- If there is an opening, play it
-- This code is disabled for now
-- while thismove > 0 and thismove <= #openmove do
--   w:write(openmove[thismove] .. "\n")
--  w:write("d\n")
--  w:flush()
--  lineFromEngine = ""
--  while not string.match(lineFromEngine,'^Key') do
--    lineFromEngine = r:read()
--    print(lineFromEngine)
--  end
--  io.flush()
--  thismove = thismove + 1
--end
   
w:write("go depth " .. searchPly .. "\n")
w:flush()
game = ""
movenumber = 1
-- Note setup, if specified as VariantSetup
if type(params["variantSetup"]) == "string" then
  game = game .. "(Setup: " .. params["variantSetup"] .. ") "
end
game = game .. "(Seed: " .. gSeed .. ") "
-- Note opening, if any
--if openmove and type(openmove) == "table" then
--  game = game .. "(Opening) "
--  for a = 1, #openmove do
--    game = game .. openmove[a] .. " "
--  end
--end

pWinner = "Black"
multiMoves = {}
infoS = false
while true do
  lineFromEngine = r:read()
  if IsVerbose then print(lineFromEngine) end
  local fields = rStrSplit(lineFromEngine,' ')
  -- Note how we evaluate
  if not infoS and fields[2] == "string" then 
    infoS = lineFromEngine 
    infoS = infoS:gsub('[\r\n]','')
    game = game .. "(" .. infoS .. ") 1. "
  end 
  if fields[6] == "multipv" then
    -- One day, we will check that "depth" is as high as possible
    multiMoves[fields[7]] = {}
    -- Find the score for this move
    for a=1,#fields do
      if fields[a] == 'score' then
        if fields[a+1] == 'cp' then
          multiMoves[fields[7]]['v'] = fields[a+2]
        elseif fields[a+1] == 'mate' then
          if tonumber(fields[a+2]) < 0 then
            multiMoves[fields[7]]['v'] = (fields[a+2] + 100000) * -1
          else
            multiMoves[fields[7]]['v'] = fields[a+2] + 100000
          end 
        else
          multiMoves[fields[7]]['v'] = -1000000 -- Shouldn’t get here
        end
      end
    end
    -- Find the move to make
    for a=1,#fields do
      if fields[a] == 'pv' then
        multiMoves[fields[7]]['m'] = fields[a+1]
      end
    end
  end
  if fields[1] == "bestmove" then
    move = fields[2] -- Make sure we make some move
    if(move:match('none')) then
      print(game .. "{" .. pWinner .. " wins}\n")
      os.exit(0)
    end
    -- It’s better to play a random good looking move so each game differs
    local consider = {}
    local showMoves = ""
    local maxV = -100000000
    -- Note that UCI considers move values from the point of view of
    -- the player to play. So, if it’s Black’s move, positive scores
    -- favor Black, and if it’s White’s move, positive scores favor 
    -- White
    for k,v in sPairs(multiMoves) do 
      if type(v) == 'table' and v.v then
        if tonumber(v.v) > maxV then maxV = tonumber(v.v) end
      end
    end
    for k,v in sPairs(multiMoves) do
      if type(v) == 'table' and v.v and v.m then
        showMoves = showMoves .. tostring(v.m) .. " " .. tostring(v.v) .. " "
        if tonumber(v.v) >= maxV - 30 then
          table.insert(consider,v.m)
        end
      end
    end
    move = consider[rg32.random(#consider)]
    print("(" .. showMoves .. ") " .. move)
    -- Note the move we decided on
    game = game .. move .. ' '
    io.flush()
    -- Now, tell the engine the move we made
    w:write('position fen ' .. thisFEN .. ' moves ' .. move .. "\n")
    -- print('position fen ' .. thisFEN .. ' moves ' .. move .. "\n")
    w:write("d\n")
    w:flush()
    -- And see what the new position looks like
    thisFEN = grabFEN(r)
    if pWinner == "Black" then
      pWinner = "White"
    else
      pWinner = "Black"
      movenumber = movenumber + 1
      game = game .. tostring(movenumber) .. '. '
      if(movenumber > 200) then
        print(game .. "{draw by over 200 moves}\n")
        os.exit(0)
      end
    end
    r:flush()
    w:write("go depth " .. searchPly .. "\n")
    w:flush()
    multiMoves = {}
  end
end

