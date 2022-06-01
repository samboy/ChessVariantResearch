#!/usr/bin/env lua

-- Donated to the public domain by Sam Trenholme 2021, 2022

-- This is a modification of the Turtle Shell tesselation where we have
-- removed some lines: The lines between thee three triangles in a group
-- that share an edge, and the lines between two squares that share an
-- edge.  
-- When we do this, the "Turtle Shell" tesselation becomes an
-- isomorphism (mathamatically equivalent to) of a square tiling; all
-- shapes have four sides and four diagonal neighbors which do not share
-- a side.
-- Indeed, observe that if the rook in Turtle Shell Chess were on this 
-- tiling, it moves just like the rook in standard chess.  Likewise, 
-- the bishop in Turtle Shell Chess moves on this version of the Turtle 
-- Shell tiling just like a bishop in standard chess.

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
function squareStraight(x, y, width, height) 
  if width == nil then width = scale end
  if height == nil then height = scale end
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tonumber(width) .. ',0 l 0,' .. tonumber(height) ..
         ' l -' .. tonumber(width) .. ',0 l 0,-' .. tonumber(height) ..
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

-- 4-sided non-regular polygon, pointing right.  Point is top left
function pointingRight(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tostring(rad3) .. ',' .. tostring(half) ..
	 ' l 0,' .. tostring(scale) .. 
         ' l -' .. tostring(rad3) .. ',' .. tostring(half) ..
         ' l 0,-' .. tostring(scale * 2) .. ' Z" />'
end
-- 4-sided non-regular polygon, pointing left.  Point is top right
function pointingLeft(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l -' .. tostring(rad3) .. ',' .. tostring(half) ..
	 ' l 0,' .. tostring(scale) ..
         ' l ' .. tostring(rad3) .. ',' .. tostring(half) ..
         ' l 0,-' .. tostring(scale * 2) .. ' Z" />'
end
-- 4-sided non-regular polygon, pointing up.  Point is bottom left
function pointingUp(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tostring(half) .. ',-' .. tostring(rad3) ..
	 ' l ' .. tostring(scale) .. ',0 ' ..
         ' l ' .. tostring(half) .. ',' .. tostring(rad3) ..
         ' l -' .. tostring(scale * 2) .. ',0 Z" />'
end
-- 4-sided non-regular polygon, pointing down. Point is is top left
function pointingDown(x, y)
  return pathdef .. newline .. 
         'd="M ' .. tostring(x) .. "," .. tostring(y) .. newline ..
         ' l ' .. tostring(half) .. ',' .. tostring(rad3) ..
	 ' l ' .. tostring(scale) .. ',0 ' ..
         ' l ' .. tostring(half) .. ',-' .. tostring(rad3) ..
         ' l -' .. tostring(scale * 2) .. ',0 Z" />'
end

-- Make the following part of the "turtle shell":
-- 4-sided shape on top 
-- long rectangle in the middle row (next to each other left-right)
-- 4-sided shape on bottom
-- The shape will be 2 * scale wide, 2 * rad3 + scale high
-- Input: x and y of top left of long rectangle
-- Output: String with SVG code
function hTurtleShell(x, y)
  local out = ""
  out = out .. squareStraight(x,y,scale * 2, scale) .. newline
  out = out .. pointingUp(x,y) .. newline
  out = out .. pointingDown(x, y + scale) .. newline
  return out
end

-- Make the following part of the "turtle shell"
-- tall rectangle
-- Two 4-sided non-regular polygon around that square
-- Two squares at angles around the tall rectangle
-- Input: top left corner of top square
function vTurtleShell(x, y)
  local out = ""
  out = out .. squareStraight(x,y,scale,scale * 2) .. newline
  out = out .. pointingLeft(x,y) .. newline
  out = out .. pointingRight(x + scale, y) .. newline
  -- Top angled squares
  out = out .. squareLeft(x - half - rad3, y - rad3 + half) .. newline
  out = out .. squareRight(x + scale + half,y - rad3) .. newline
  return out
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

