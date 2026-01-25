-- Placed in the public domain 2021,2026 by Sam Trenholme
-- This is a lunacy (Lua + Steve Donovan's spawner lib) implementation of
-- a simple Chess/Chess variants client
--
-- This client is a “randomized” version of Fairy-Stockfish:  It looks
-- at the top MultiPV number of moves (default: 3), and chooses one within
-- 50 centipawns of what it thinks is the best move at random.
--
-- This client requires the Fairy-Stockfish program to be installed
-- and available with the name fairy-stockfish-largeboard_x86-64
-- (if it has another name, change "ChessEngine" below)

math.randomseed(os.time())

-- Let's look at win/lose/draw ratio for different capa setups
vSetup = "RNABCKBQNR" -- Finesse Chess, most balanced 2008 setup
if #arg >= 1 then
  vSetup = arg[1]
end

-- params is a table with the "user tunable" parameters
params = {
  -- See https://github.com/ianfab/Fairy-Stockfish for the Chess engine
  -- This is the name of the chess engine, as it appears in one's $PATH
  ChessEngine = "fairy-stockfish",
  -- This is the number of lines we look at and consider for our next move
  MultiPV = 3,
  -- The name of the variant we will look at.  This needs to be a variant
  -- Fairy-Stockfish supports
  variantName = "capablanca",
  -- variantName = "chess",
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
  searchPly = 12,
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
  print("searchPly too small/not set, using 12") 
  searchPly = 12
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
w:write("setoption name EvalFile value capablanca-bb644ef32758.nnue\n")
w:write("setoption name Use NNUE value true\n")
w:write("setoption name UCI_Variant value " .. variantName .. "\n")
w:write("ucinewgame\n")
if variantFEN then
  w:write("position fen " .. variantFEN .. "\n")
else 
  -- Default to Finesse chess
  w:write(
"position fen rnabckbqnr/pppppppppp/10/10/10/10/PPPPPPPPPP/RNABCKBQNR "
.. "w KQkq - 0 1")
end
FENseen = {}
thisFEN = ""
function processFENline(hash, line)
  if not hash then hash = {} end
  line = line:gsub('[\r\n]','')
  line = line:gsub('^Fen: ','')
  if not hash[line] then
    hash[line] = 1
  else
    hash[line] = hash[line] + 1
    if hash[line] >= 3 then
      print(game .. "{draw by repetition}\n")
      os.exit(0)
    end 
  end
  return line, hash -- We actually modify hash in place, but still
end
function grabFEN(handle)
  local out = ""
  while not string.match(lineFromEngine,'^Key') do
    lineFromEngine = handle:read()
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
-- Note opening, if any
--if openmove and type(openmove) == "table" then
--  game = game .. "(Opening) "
--  for a = 1, #openmove do
--    game = game .. openmove[a] .. " "
--  end
--end

pWinner = "Black"
while true do
  lineFromEngine = r:read()
  -- print(lineFromEngine)
  local fields = rStrSplit(lineFromEngine,' ')
  if fields[1] == "bestmove" then
    move = fields[2]
    game = game .. move .. ' '
    if(move:match('none')) then
      print(game .. "{" .. pWinner .. " wins}\n")
      os.exit(0)
    end
    io.flush()
    w:write('position fen ' .. thisFEN .. ' moves ' .. move .. "\n")
    w:write("d\n")
    w:flush()
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
  end
end

