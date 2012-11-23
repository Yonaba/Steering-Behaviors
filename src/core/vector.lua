--[[
  Copyright (c) 2012 Roland Yonaba

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the
  "Software"), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be included
  in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]

local sqrt = math.sqrt

local Vec = { x = 0, y = 0}
Vec.__index = Vec
Vec.__tostring = function(self) 
  return ('Vec [%.2f,%.2f]'):format(self.x,self.y) 
end

function Vec:new(x,y)
  return setmetatable({x = x or 0, y = y or 0},Vec)
end

function Vec.__add(a,b)
  return Vec(a.x + b.x, a.y + b.y)
end

function Vec.__sub(a,b)
  return Vec(a.x - b.x, a.y - b.y)
end

function Vec.__mul(a,b)
  if type(b) == 'number' then
    return Vec(a.x * b, a.y * b)
  end
  return Vec(a.x * b.x, a.y * b.y)
end

function Vec:clone()
  return Vec(self.x, self.y)
end

function Vec:set(x,y)
  self.x, self.y = x, y
end

function Vec:clear()
  self.x, self.y = 0, 0
end

function Vec:magSq()
  return (self.x * self.x + self.y * self.y) 
end

function Vec:mag()
  return sqrt(self.x * self.x + self.y * self.y) 
end

function Vec:normalize()
  local mag = sqrt(self.x * self.x + self.y * self.y)
  if mag > 0 then
    self.x, self.y = self.x/mag, self.y/mag
  end
  return self
end

function Vec:getNormalized()
  return self:clone():normalize()
end

function Vec:clamp(vMax)
  local magSq = (self.x * self.x + self.y * self.y)
  if magSq > vMax:magSq() then 
    self:normalize() 
    self.x, self.y = self.x * vMax.x, self.y * vMax.y
  end  
  return self
end

function Vec:getPerp()
  return Vec(-self.y,self.x)
end

function Vec:distSqTo(v)
  local dx = v.x - self.x
  local dy = v.y - self.y
  return (dx * dx + dy * dy)
end

function Vec:dot(v)
  return (self.x * v.x + self.y * v.y)
end  

return setmetatable(Vec, 
  {__call = function(self,...) 
    return Vec:new(...) 
end})
