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

vSetup = "RQNBAKCNBR"
if #arg >= 1 then
  vSetup = arg[1]
end
if vSetup:len() <= 6 then
  print("Usage: lunacy StockfishEval.lua {setup} {plies} {multiPV}")
  print("Example: lunacy StockfishEval.lua RNBQKBNR 21 20")
  os.exit(0)
end

-- params is a table with the "user tunable" parameters
-- They are also tuned with arguments, which overrides these
-- params.
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
  searchPly = 21,
  -- Opening to play.  Format is like this: "f2f4 f7f5", where each move has
  -- four letters (from, to) or five letters (for pawn promotions: b7b8q)
  -- King move for castling (e.g. e1g1 with normal RNBQKBNR chess).  Spaces
  -- between openings
  opening = false,
}
ChessEngine = params["ChessEngine"]
MultiPV = tonumber(params["MultiPV"])
variantName = params["variantName"]
if type(params["variantFEN"]) == "string" then
  variantFEN = params["variantFEN"]
else
  variantFEN = false
end

-- Here be dragons below
math.randomseed(os.time())

if vSetup:len() == 10 then
  ChessEngine = "fairy-stockfish"
  variantName = "capablanca"
end
if vSetup:len() == 8 then
  ChessEngine = "stockfish"
  variantName = nil
end   
plies = false
if #arg >= 2 then
  plies = tonumber(arg[2])
end
if #arg >= 3 then
  MultiPV = tonumber(arg[3])
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

if plies then
  searchPly = plies
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
-- Load NNUE
if variantName then
  w:write("setoption name UCI_Variant value " .. variantName .. "\n")
end
if variantName == "capablanca" then
  w:write("setoption name EvalFile value capablanca-bb644ef32758.nnue\n")
end
w:write("setoption name Use NNUE value true\n")
w:write("setoption name MultiPV value " .. tostring(MultiPV) .. "\n")
w:write("ucinewgame\n")
w:write("position fen " .. variantFEN .. "\n")
w:write("d\n")
w:write("go depth " .. tostring(searchPly) .. "\n")
w:flush()
lineFromEngine = ""
eval = -1
lines = {}
while not string.match(lineFromEngine,'^bestmove') do
  local x = nil
  local line = nil
  lineFromEngine = r:read()
  line, x = lineFromEngine:match("multipv (%d+) score cp ([%d%-]+)")
  if x and tonumber(line) == 1 then
    eval = x
  end
  local move = lineFromEngine:match(" pv (%S+) ")
  if line then
    lines[tonumber(line)] = {}
    lines[tonumber(line)]['eval'] = tonumber(x) 
    lines[tonumber(line)]['move'] = move
  end
  print(lineFromEngine)
  io.flush()
end
out = vSetup .. ":" 
for a=1,#lines do
  out = out .. lines[a]['eval'] .. ',' .. lines[a]['move'] .. ';'
end
io.flush()
print(vSetup .. " eval: " .. eval)
print(out)
