#!/usr/bin/env lua

-- Donated to the public domain by Sam Trenholme 2021, 2022

-- Make a "turtle shell" tesselation of the plane in SVG format


gridCount =  7 -- The number of groups of cells we place, both horizontally
               -- and vertically (cells is a multiple of the square of this 
	       -- number)
if arg and tonumber(arg[1]) and tonumber(arg[1]) >= 3 then
  gridCount = tonumber(arg[1])
end
scale = 100 -- How long each line will be in the pattern
rad3 = scale * .5 * (3 ^ .5)
half = scale / 2
pathdef = '<path fill="none" stroke="black" stroke-width="5" '
newline = "\n"
svgHeader = '<svg viewBox="0 0 ' .. tostring(scale * gridCount * 2.2) 
            .. ' ' ..
            tostring(scale * gridCount * 2.2)
	    .. '" xmlns="http://www.w3.org/2000/svg">'
svgFooter = '</svg>'

-- The shapes used for the Turtle shell
-- Input: X, Y of point on shape
-- Output: String with SVG of shape

-- Straight square.  Point is top left
function squareStraight(x, y) 
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tonumber(scale) .. ',0 l 0,' .. tonumber(scale) ..
         ' l -' .. tonumber(scale) .. ',0 l 0,-' .. tonumber(scale) ..
         ' Z" />'
end
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

