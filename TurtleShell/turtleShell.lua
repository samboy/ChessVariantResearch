#!/usr/bin/env lua

-- Donated to the public domain by Sam Trenholme 2021

-- Make a "turtle shell" tesselation of the plane in SVG format

scale = 10 -- How long each line will be in the pattern
rad3 = scale * .5 * (3 ^ .5)
half = scale / 2
pathdef = '<path fill="none" stroke="black" '
newline = "\n"
svgHeader = '<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">'
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

-- Output some of a Turtle shell on standard output
function try1()
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
  print(triangleDown(scale * 2 + rad3,2 * scale + half))
  print(triangleUp(scale + half + rad3,scale * 2 + half + rad3))
  print(triangleUp(scale * 2 + half + rad3,scale * 2 + half + rad3))
  print(triangleRight(scale * 3 + rad3,half))
  print(triangleRight(scale * 3 + rad3,scale + half))
  print(triangleLeft(scale * 3 + rad3 * 2, scale))
  print(squareLeft(scale * 3 + rad3,scale * 2 + half))
  print(svgFooter)
end

try1()
