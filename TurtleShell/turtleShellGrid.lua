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

-- Classes to define a point.  Points are in x (rational) + 
-- x * rad3 (radical 3, i.e. 3^.5 is irrational), y + y*(3^.5) format
-- so we never have floating point rounding errors
-- We call these part of the vector x1,xrad3,y1,yrad3
-- We have a multi-level table with each point, so we can keep track
-- of lines coming out of a given point
points = {}
scale = 100 -- How long each line will be in the pattern
rad3 = .5 * (3 ^ .5)
half = 1/2
-- This doesn’t need to be precise; we just need a general sense of how
-- big the bounding rectangle should be
xmax = 0
ymax = 0
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
  if y1 + rad3 * yrad3 > xmax then
    ymax = y1 + rad3 * yrad3
  end
  return points[x1][xrad3][y1][yrad3]
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
  return '<svg viewBox="0 0 ' .. tostring(xmax * scale + 1) 
         .. ' ' ..
            tostring(ymax * scale + 1)
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
      tostring(Xa)
      .. "," ..
      tostring(Ya)
      .. ' l ' .. tostring(xB - Xa) .. "," .. tostring(yB - yA)
      .. ' Z" />'
  point1["drawn"][point2] = true
  point2["drawn"][point1] = true
  return out
end
         
-- The shapes used for the Turtle shell
-- Input: point on shape
-- Output: String with SVG of shape

-- Straight square.  Point is top left
function squareStraight(point1) 
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
  return true 
end
-- CODE HERE (Below still needs to be rewritten)
-- Square, turned to the right.  Point is top left
function squareRight(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tostring(rad3) .. "," .. tostring(half) .. 
         ' l -' .. tostring(half) .. ',' .. tostring(rad3) .. 
         ' l -' .. tostring(rad3) .. ',-' .. tostring(half) .. 
         ' l ' .. tostring(half) .. ',-' ..  tostring(rad3) .. ' Z" />'
end
-- Square, turned to the left.  Point is top left
function squareLeft(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tostring(rad3) .. ",-" .. tostring(half) .. 
         ' l ' .. tostring(half) .. ',' .. tostring(rad3) .. 
         ' l -' .. tostring(rad3) .. ',' .. tostring(half) .. 
         ' l -' .. tostring(half) .. ',-' .. tostring(rad3) .. ' Z" />'
end

-- Triangle, pointing right.  Point is top left
function triangleRight(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tostring(rad3) .. ',' .. tostring(half) ..
         ' l -' .. tostring(rad3) .. ',' .. tostring(half) ..
         ' l 0,-' .. tostring(scale) .. ' Z" />'
end
-- Triangle, pointing left.  Point is top right
function triangleLeft(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l -' .. tostring(rad3) .. ',' .. tostring(half) ..
         ' l ' .. tostring(rad3) .. ',' .. tostring(half) ..
         ' l 0,-' .. tostring(scale) .. ' Z" />'
end
-- Triangle, pointing up.  Point is bottom left
function triangleUp(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tostring(half) .. ',-' .. tostring(rad3) ..
         ' l ' .. tostring(half) .. ',' .. tostring(rad3) ..
         ' l -' .. tostring(scale) .. ',0 Z" />'
end
-- Triangle, pointing down. Point is is top left
function triangleDown(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tostring(half) .. ',' .. tostring(rad3) ..
         ' l ' .. tostring(half) .. ',-' .. tostring(rad3) ..
         ' l -' .. tostring(scale) .. ',0 Z" />'
end

-- Make the following part of the "turtle shell":
-- Three triangles on top (two pointed up, one pointed down)
-- Two squares in the middle row (next to each other left-right)
-- Three triangles on bottom (two pointed down, one pointed up)
-- The shape will be 2 * scale wide, 2 * rad3 + scale high
-- Input: x and y of top left of left square
-- Output: String with SVG code
function hTurtleShell(x, y)
  local out = ""
  out = out .. squareStraight(x,y) .. newline
  out = out .. squareStraight(x + scale, y) .. newline
  out = out .. triangleUp(x,y) .. newline
  out = out .. triangleDown(x + half, y - rad3) .. newline
  out = out .. triangleUp(x + scale, y) .. newline
  out = out .. triangleDown(x, y + scale) .. newline
  out = out .. triangleUp(x + half, y + scale + rad3) .. newline
  out = out .. triangleDown(x + scale, y + scale) .. newline
  return out
end

-- Make the following part of the "turtle shell"
-- Two squares, one above the other one
-- Six triangles around those two squares
-- Two squares at angles around the upper two squares
-- Input: top left corner of top square
function vTurtleShell(x, y)
  local out = ""
  out = out .. squareStraight(x,y) .. newline
  out = out .. squareStraight(x,y + scale) .. newline
  out = out .. triangleLeft(x,y) .. newline
  out = out .. triangleRight(x - rad3,y + half) .. newline
  out = out .. triangleLeft(x,y + scale) .. newline
  out = out .. triangleRight(x + scale, y) .. newline
  out = out .. triangleLeft(x + scale + rad3, y + half) .. newline
  out = out .. triangleRight(x + scale, y + scale) .. newline
  -- Top angled squares
  out = out .. squareLeft(x - half - rad3, y - rad3 + half) .. newline
  out = out .. squareRight(x + scale + half,y - rad3) .. newline
  return out
end
-- Output some of a Turtle shell on standard output
function try1()
  -- In SVG, x goes right, y goes down.
  print(svgHeader)
  print(squareStraight(scale,scale))
  print(triangleRight(scale * 2,scale))
  print(triangleLeft(scale * 2 + rad3, scale - half))
  print(triangleUp(scale,scale))
  print(triangleDown(scale,scale * 2))
  print(squareRight(scale * 2, scale * 2))
  print(triangleLeft(scale * 2 + rad3, scale + half))
  print(squareStraight(scale * 2 + rad3,half))
  print(squareStraight(scale * 2 + rad3,scale + half))
  print(hTurtleShell(scale + half + rad3,scale * 2 + half + rad3))
  print(triangleRight(scale * 3 + rad3,half))
  print(triangleRight(scale * 3 + rad3,scale + half))
  print(triangleLeft(scale * 3 + rad3 * 2, scale))
  print(vTurtleShell(scale * 2 + rad3,scale * 3 + half + 2 * rad3))
  print(hTurtleShell(scale * 3 + rad3 * 2, scale))
  -- This is how these meta tiles look vertically stacked, going down
  print(vTurtleShell(scale * 3 + rad3 * 2 + half, scale * 2 + rad3)) 
  print(hTurtleShell(scale * 3 + rad3 * 2, scale * 4 + rad3 * 2))
  -- Here is a vTurtleShell to the right of the above hTurtleShell
  print(vTurtleShell(scale * 5 + rad3 * 3, scale * 3 + half + rad3 * 2))
  -- And a hTurtleShell above that one
  print(hTurtleShell(scale * 4 + half + rad3 * 3, scale * 2 + half + rad3 * 1))
  -- And move up to another vTurtleShell
  print(vTurtleShell(scale * 5 + rad3 * 3, half))
  -- OK, move over and down some
  print(vTurtleShell(scale * 3 + rad3 * 2 + half, scale * 5 + rad3 * 3))
  print(svgFooter)
end

-- This converts the "turtle shell" in to a grid of tile groups, so
-- we can tile the plane the same way we would tile the plane with
-- squares
function turtleShellGridPoint(x, y)
  type = ((x % 2) + (y % 2)) % 2
  if type == 0 then
    return vTurtleShell(scale * x + rad3 * x + half * x,
                        scale * y + rad3 * y + half * y)
  else 
    return hTurtleShell(scale * x + rad3 * x + half * (x - 1),
                        scale * y + rad3 * y + half * (y + 1))
  end
end

print(svgHeader)
for a = 0,gridCount do
  for b = 0,gridCount do
    print(turtleShellGridPoint(a,b))
  end
end
print(svgFooter)
--try1()

