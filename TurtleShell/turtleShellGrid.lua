#!/bin/sh
_rem=--[=[
# POSIX shell wrapper to call correct version of Lua or Lunacy

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
  echo Either the version included with this repo -or- the version at
  echo https://github.com/samboy/lunacy
  echo To compile and install the version of Lunacy with the repo:
  echo
  echo     tar xvJf lunacy-2022-12-06.tar.xz
  echo     cd lunacy-2022-12-06/
  echo     make
  echo     sudo cp lunacy /usr/local/bin/
  exit 1
fi

exec $LUNACY $0 "$@"

# ]=]1

-- Donated to the public domain by Sam Trenholme 2021, 2022, 2026

-- Make a "turtle shell" grid with a defined size in SVG format

-- Utility function: table iterator
-- Like pairs() but sorted
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

-- Classes to define a point.  Points are in x (rational) + 
-- x * rad3 (radical 3, i.e. 3^.5 is irrational), y + y*(3^.5) format
-- so we never have floating point rounding errors
-- We call these part of the vector x1,xrad3,y1,yrad3
-- We have a multi-level table with each point, so we can keep track
-- of lines coming out of a given point
points = {}
count = {} -- How many of each shape (square, triangle, etc.)
scale = 100 -- How long each line will be in the pattern
rad3 = .5 * (3 ^ .5)
half = 1/2

-- This doesn’t need to be precise; we just need a general sense of how
-- big the bounding rectangle should be
xmax = 0
ymax = 0

-- Get the size of the grid from the command line
gridX = 7
gridY = 7
if #arg >= 1 then
  if arg[1]:match("h") or arg[1]:match("-") or arg[1]:match("?") then
    print("Usage: lunacy turtleShellGrid.lua {size x} {size y} {fill}")
    print("Fill: 0 no fill; 1 fill top/bottom; 2 left/right; 3 all")
    os.exit(0)
  end
  gridX=tonumber(arg[1])
end
if #arg >= 2 then
  gridY=tonumber(arg[2])
else
  gridY = gridX
end 
if #arg >= 3 then
  doFill = tonumber(arg[3])
else
  doFill = 0
end

-- This will point to a given point if it exists, and add it if it
-- doesn’t exist
function point(x1,xrad3,y1,yrad3)
  if not points[x1] then
    points[x1] = {}
  end
  if not points[x1][xrad3] then
    points[x1][xrad3] = {}
  end
  if not points[x1][xrad3][y1] then
    points[x1][xrad3][y1] = {}
  end
  if not points[x1][xrad3][y1][yrad3] then
    points[x1][xrad3][y1][yrad3] = {}
    local out = points[x1][xrad3][y1][yrad3]
    out.x1 = x1
    out.xrad3 = xrad3
    out.y1 = y1
    out.yrad3 = yrad3
  end
  if x1 + rad3 * xrad3 > xmax then
    xmax = x1 + rad3 * xrad3
  end
  if y1 + rad3 * yrad3 > ymax then
    ymax = y1 + rad3 * yrad3
  end
  return points[x1][xrad3][y1][yrad3]
end

-- Iterate through every single point
-- This is a function factory so it can be used with “for”
function pointIterate()
  local list = {}
  for k1,v1 in sPairs(points) do -- x1
    for k2,v2 in sPairs(v1) do -- xrad3
      for k3,v3 in sPairs(v2) do -- y1
        for k4,v4 in sPairs(v3) do -- yrad3
          table.insert(list, v4)
        end -- yrad3
      end -- y2
    end -- xrad3
  end -- x1
  local index = 0
  return function()
    index = index + 1
    return list[index]
  end
end

-- Add a line between two points if it doesn’t already exist.  
-- Input is two tables, one for each point.  
-- Usage is like this: draw(point(1,1,2,2),point(2,2,3,3))
-- This does not physically draw the line, but indicates our desire
-- to have a line between two points (we draw the lines after every
-- draw() call to avoid duplicate lines)
function draw(point1, point2)
  if not point1.lines then
    point1.lines = {}
  end
  if not point2.lines then
    point2.lines = {}
  end
  if not point1["lines"][point2] then
    point1["lines"][point2] = true
  end
  if not point2["lines"][point1] then
    point2["lines"][point1] = true
  end
end

pathdef = '<path fill="none" stroke="black" stroke-width="5" '
linefeed = "\n"

function svgHeader(scale, xmax, ymax) 
  return '<svg viewBox="0 0 ' .. tostring((xmax + 2) * scale) 
         .. ' ' ..
            tostring((ymax + 2) * scale)
	    .. '" xmlns="http://www.w3.org/2000/svg">'
end
function svgFooter(scale, xmax, ymax)
  return '</svg>'
end

-- If a given line has not been drawn, draw it
function drawLine(scale, point1, point2)
  if not point1.drawn then
    point1.drawn = {}
  end
  if not point2.drawn then
    point2.drawn = {}
  end
  -- We only draw a given line once
  if point1["drawn"][point2] or point2["drawn"][point1] then
    if not point1["drawn"][point2] then
      point1["drawn"][point2] = true
    end
    if not point2["drawn"][point1] then
      point2["drawn"][point1] = true
    end
    return ""
  end
  local xA = point1.x1 * scale + point1.xrad3 * rad3 * scale
  local yA = point1.y1 * scale + point1.yrad3 * rad3 * scale
  local xB = point2.x1 * scale + point2.xrad3 * rad3 * scale
  local yB = point2.y1 * scale + point2.yrad3 * rad3 * scale
  local out = pathdef .. linefeed .. 'd="M ' ..
      tostring(xA)
      .. "," ..
      tostring(yA)
      .. ' l ' .. tostring(xB - xA) .. "," .. tostring(yB - yA)
      .. ' Z" />'
  point1["drawn"][point2] = true
  point2["drawn"][point1] = true
  return out
end
         
-- The shapes used for the Turtle shell
-- Input: point on shape
-- Output: String with SVG of shape

-- Straight square.  Point is top left
function squareStraight(point1) -- top left
  local x1 = point1.x1
  local xrad3 = point1.xrad3
  local y1 = point1.y1
  local yrad3 = point1.yrad3
  local point2 = point(x1 + 1, xrad3, y1, yrad3)
  local point3 = point(x1 + 1, xrad3, y1 + 1, yrad3)
  local point4 = point(x1, xrad3, y1 + 1, yrad3)
  draw(point1, point2)
  draw(point2, point3)
  draw(point3, point4)
  draw(point4, point1)
  if not count.squareStraight then
    count.squareStraight = 1
  else
    count.squareStraight = count.squareStraight + 1
  end
  return true 
end

-- Square, turned to the right.  Point is top left
function squareRight(point1) -- top left
  local x1 = point1.x1
  local xrad3 = point1.xrad3
  local y1 = point1.y1
  local yrad3 = point1.yrad3
  local point2 = point(x1,xrad3+1,y1+half,yrad3)
  local point3 = point(x1-half,xrad3+1,y1+half,yrad3+1)
  local point4 = point(x1-half,xrad3,y1,yrad3+1)
  draw(point1, point2)
  draw(point2, point3)
  draw(point3, point4)
  draw(point4, point1)
  if not count.squareRight then
    count.squareRight = 1
  else
    count.squareRight = count.squareRight + 1
  end
  return true
end

-- Square, turned to the left.  Point is top left
function squareLeft(point1) -- top left
  local x1 = point1.x1
  local xrad3 = point1.xrad3
  local y1 = point1.y1
  local yrad3 = point1.yrad3
  local point2 = point(x1,xrad3+1,y1-half,yrad3)
  local point3 = point(x1+half,xrad3+1,y1-half,yrad3+1)
  local point4 = point(x1+half,xrad3,y1,yrad3+1)
  draw(point1, point2)
  draw(point2, point3)
  draw(point3, point4)
  draw(point4, point1)
  if not count.squareLeft then
    count.squareLeft = 1
  else
    count.squareLeft = count.squareLeft + 1
  end
  return true
end

-- Triangle, pointing right.  Point is top left
function triangleRight(point1) -- top left
  local x1 = point1.x1
  local xrad3 = point1.xrad3
  local y1 = point1.y1
  local yrad3 = point1.yrad3
  local point2 = point(x1,xrad3+1,y1+half,yrad3)
  local point3 = point(x1,xrad3,y1+1,yrad3)
  draw(point1, point2)
  draw(point2, point3)
  draw(point3, point1)
  if not count.triangleRight then
    count.triangleRight = 1
  else
    count.triangleRight = count.triangleRight + 1
  end
  return true
end
-- Triangle, pointing left.  Point is top right
function triangleLeft(point1) -- top right
  local x1 = point1.x1
  local xrad3 = point1.xrad3
  local y1 = point1.y1
  local yrad3 = point1.yrad3
  local point2 = point(x1,xrad3-1,y1+half,yrad3)
  local point3 = point(x1,xrad3,y1+1,yrad3)
  draw(point1, point2)
  draw(point2, point3)
  draw(point3, point1)
  if not count.triangleLeft then
    count.triangleLeft = 1
  else
    count.triangleLeft = count.triangleLeft + 1
  end
  return true
end
-- Triangle, pointing up.  Point is bottom left
function triangleUp(point1) -- bottom left
  local x1 = point1.x1
  local xrad3 = point1.xrad3
  local y1 = point1.y1
  local yrad3 = point1.yrad3
  local point2 = point(x1+half,xrad3,y1,yrad3-1)
  local point3 = point(x1+1,xrad3,y1,yrad3)
  draw(point1, point2)
  draw(point2, point3)
  draw(point3, point1)
  if not count.triangleUp then
    count.triangleUp = 1
  else
    count.triangleUp = count.triangleUp + 1
  end
  return true
end
-- Triangle, pointing down. Point is is top left
function triangleDown(point1) -- top left
  local x1 = point1.x1
  local xrad3 = point1.xrad3
  local y1 = point1.y1
  local yrad3 = point1.yrad3
  local point2 = point(x1+half,xrad3,y1,yrad3+1)
  local point3 = point(x1+1,xrad3,y1,yrad3)
  draw(point1, point2)
  draw(point2, point3)
  draw(point3, point1)
  if not count.triangleDown then
    count.triangleDown = 1
  else
    count.triangleDown = count.triangleDown + 1
  end
  return true
end

-- Draw a set of shapes (can have multiple tiles) on the board
-- Shapes are one of:
-- * A tilted square
-- * Two straight sqares next to each other
-- * Three triangles next to each other
-- point1: Upper left corner of shapes to draw
-- phaseX: What kind of shapes to draw (left to right) 0,1,2,or 3
-- phaseY: Like phaseX, but vertical
-- fill: Whether to, at the edge, round out the edge
-- 0: No
-- 1: Fill on left
-- 2: Fill on top
-- 3: Fill on right
-- 4: Fill on bottom
-- Return location one over right, location one down
function drawShapes(point1, phaseX, phaseY, fill)
  if not fill then fill = 0 end
  phaseX = phaseX % 4
  phaseY = phaseY % 4
  local x1 = point1.x1
  local xrad3 = point1.xrad3
  local y1 = point1.y1
  local yrad3 = point1.yrad3
  if phaseY >= 2 then
    phaseX = phaseX + 2
    phaseX = phaseX % 4
    phaseY = phaseY - 2
  end
  if (phaseX == 0 and phaseY == 0) then
    squareRight(point1)
    if fill == 1 then -- Left fill
      local point2 = point(x1-1,xrad3,y1,yrad3)
      triangleDown(point2)
      local point3 = point(x1-1,xrad3,y1-1,yrad3)
      squareStraight(point3)
      triangleUp(point3)
    end
    if fill == 4 then -- Bottom fill
      local point2 = point(x1-half,xrad3,y1,yrad3+1)
      triangleRight(point2)
      local point3 = point(x1-1-half,xrad3,y1,yrad3+1)
      squareStraight(point3)
      triangleLeft(point3)
    end
    return x1,xrad3+1,y1+half,yrad3, x1-half,xrad3,y1,yrad3+1
  end
  if (phaseX == 1 and phaseY == 0) then
    local point2 = point(x1-half,xrad3,y1,yrad3+1)
    triangleUp(point2)
    triangleDown(point1)
    local point3 = point(x1+half,xrad3,y1,yrad3+1)
    triangleUp(point3)
    return x1+1,xrad3,y1,yrad3
  end
  if (phaseX == 2 and phaseY == 0) then
    squareLeft(point1)
    if fill == 3 then -- Fill on right
      local point2 = point(x1,xrad3+1,y1-half,yrad3)
      triangleDown(point2)
      local point3 = point(x1,xrad3+1,y1-half-1,yrad3)
      squareStraight(point3)
      triangleUp(point3)
    end
    if fill == 2 then -- Fill on top
      local point4 = point(x1,xrad3,y1-1,yrad3)
      triangleRight(point4) 
      local point5 = point(x1-1,xrad3,y1-1,yrad3)
      squareStraight(point5)
      triangleLeft(point5)
    end
    return x1,xrad3+1,y1-half,yrad3, x1+half,xrad3,y1,yrad3+1
  end
  if (phaseX == 3 and phaseY == 0) then
    triangleDown(point1)
    local point2 = point(x1+half,xrad3,y1,yrad3+1)
    triangleUp(point2)
    local point3 = point(x1+1,xrad3,y1,yrad3)
    triangleDown(point3)
    return x1+2,xrad3,y1,yrad3
  end
  if(phaseX == 0 and phaseY == 1) then
    triangleRight(point1)
    local point2 = point(x1,xrad3+1,y1+half,yrad3)
    triangleLeft(point2)
    local point3 = point(x1,xrad3,y1+1,yrad3)
    triangleRight(point3)
    return x1,xrad3+1,y1+half,yrad3, x1,xrad3,y1+2,yrad3
  end
  if(phaseX == 1 and phaseY == 1) then
    squareStraight(point1)
    local point2 = point(x1+1,xrad3,y1,yrad3)
    squareStraight(point2)
    return x1+2,xrad3,y1,yrad3
  end
  if(phaseX == 2 and phaseY == 1) then
    local point2 = point(x1,xrad3+1,y1-half,yrad3)
    triangleLeft(point2)
    triangleRight(point1)
    local point3 = point(x1,xrad3+1,y1+half,yrad3)
    triangleLeft(point3)
    return x1,xrad3+1,y1-half,yrad3, x1,xrad3,y1+1,yrad3
  end
  if(phaseX == 3 and phaseY == 1) then
    squareStraight(point1)
    local point2 = point(x1,xrad3,y1+1,yrad3)
    squareStraight(point2)
    return x1+1,xrad3,y1,yrad3 
  end
end

function svgTally() 
  if not count.squareStraight then count.squareStraight = 0 end
  if not count.squareLeft then count.squareLeft = 0 end
  if not count.squareRight then count.squareRight = 0 end
  count.squares = count.squareStraight + count.squareLeft + count.squareRight
  if not count.triangleUp then count.triangleUp = 0 end
  if not count.triangleDown then count.triangleDown = 0 end
  if not count.triangleLeft then count.triangleLeft = 0 end
  if not count.triangleRight then count.triangleRight = 0 end
  count.triangles = count.triangleUp + count.triangleDown +
                    count.triangleLeft + count.triangleRight
  count.points = 0
  for a in pointIterate() do
    if a.lines then count.points = count.points + 1 end
  end
  out = "<!-- Squares:   " .. count.squares .. linefeed ..
        "     Triangles: " .. count.triangles .. linefeed ..
        "     Shapes:    " .. (count.squares + count.triangles) .. linefeed ..
        "     Points:    " .. count.points .. " -->" .. linefeed
  return out
end
  
-- Put the shapes on the grid 
point1 = point(2,0,2,0)
px = 0
py = 0
for a=1,gridY do
  local x1
  local xrad3
  local y1
  local yrad3
  local x1d
  local xr3d
  local y1d
  local yr3d
  for b=1,gridX do
    if py == 0 and a > 1 and b == 1 and doFill >= 2 then
      x1, xrad3, y1, yrad3, x1d, xr3d, y1d, yr3d = drawShapes(point1,px,py,1)
    elseif(b == 1) then
      x1, xrad3, y1, yrad3, x1d, xr3d, y1d, yr3d = drawShapes(point1, px, py)
    elseif gridY % 4 == 1 and py % 2 == 0 and px % 2 == 0 and a > 2 and
          (a < gridY or px == 2) and
          b == gridX and doFill >= 2 then
      x1, xrad3, y1, yrad3 = drawShapes(point1, px, py, 3)
    elseif gridY % 4 == 3 and py % 2 == 0 and px % 2 == 0 and a > 2 and
          (a < gridY or px == 0) and
          b == gridX and doFill >= 2 then
      x1, xrad3, y1, yrad3 = drawShapes(point1, px, py, 3)
    elseif px == 2 and a == 1 and doFill % 2 == 1 then
      x1, xrad3, y1, yrad3 = drawShapes(point1, px, py, 2)
    elseif px == 2 and a == gridY and doFill % 2 == 1 then
      x1, xrad3, y1, yrad3 = drawShapes(point1, px, py, 4)
    elseif px == 0 and b > 2 and a == gridY and doFill % 2 == 1 then
      x1, xrad3, y1, yrad3 = drawShapes(point1, px, py, 4)
    elseif py % 2 == 0 and px % 2 == 0 and a > 2 and 
           (a < gridY or px == 2) and
	   b == gridX and doFill >= 2 then
      x1, xrad3, y1, yrad3 = drawShapes(point1, px, py, 3)
    else 
      x1, xrad3, y1, yrad3 = drawShapes(point1, px, py)
    end
    px = px + 1
    px = px % 4
    if(b < gridX) then
      point1 = point(x1, xrad3, y1, yrad3) 
    else
      point1 = point(x1d, xr3d, y1d, yr3d) 
    end
  end
  px = 0
  py = py + 1
  py = py % 4
end

-- Now, convert the points in to SVG
print(svgHeader(scale,xmax,ymax))
print(svgTally())
for point1 in pointIterate() do
  if point1.lines then
    for k,v in pairs(point1.lines) do
      print(drawLine(scale,point1,k))
    end
  end
end
print(svgFooter(scale, xmax, ymax))
