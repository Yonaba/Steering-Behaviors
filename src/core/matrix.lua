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

if (...) then
  local _PATH = (...):gsub('[^%.]+$','')
  local Vec = require (_PATH .. 'vector')
  
  local M = {
    _m = {
      {0,0,0},
      {0,0,0},
      {0,0,0}
    }
  }
  
  M.__index = M

  function M:new()
    return setmetatable({_m = M:identity()},M)
  end

  function M:identity()
    return {{1,0,0},{0,1,0},{0,0,1}}
  end

  function M:zero()
    return {{0,0,0},{0,0,0},{0,0,0}}
  end  

  function M:multiply(mat)
    local m = M:identity()
    
    m[1][1] = self._m[1][1] * mat[1][1] + self._m[1][2] * mat[2][1] + self._m[1][3] * mat[3][1]
    m[1][2] = self._m[1][1] * mat[1][2] + self._m[1][2] * mat[2][2] + self._m[1][3] * mat[3][2]
    m[1][3] = self._m[1][1] * mat[1][3] + self._m[1][2] * mat[2][3] + self._m[1][3] * mat[3][3]

    m[2][1] = self._m[2][1] * mat[1][1] + self._m[2][2] * mat[2][1] + self._m[2][3] * mat[3][1]
    m[2][2] = self._m[2][1] * mat[1][2] + self._m[2][2] * mat[2][2] + self._m[2][3] * mat[3][2]
    m[2][3] = self._m[2][1] * mat[1][3] + self._m[2][2] * mat[2][3] + self._m[2][3] * mat[3][3]  
    
    m[3][1] = self._m[3][1] * mat[1][1] + self._m[3][2] * mat[2][1] + self._m[3][3] * mat[3][1]
    m[3][2] = self._m[3][1] * mat[1][2] + self._m[3][2] * mat[2][2] + self._m[3][3] * mat[3][2]
    m[3][3] = self._m[3][1] * mat[1][3] + self._m[3][2] * mat[2][3] + self._m[3][3] * mat[3][3]  
    
    self._m = m
    return self
  end

  function M:rotateFrom(fwd, side)
    local m = M:identity()
    m[1][1] = fwd.x; m[1][2] = fwd.y
    m[2][1] = side.x; m[2][2] = side.y
    return self:multiply(m)
  end

  function M:translate(x, y)
    local m = M:identity()
    m[3][1] = x; m[3][2] = y
    return self:multiply(m)
  end

  function M:transformVec(tPoint)
    local x = (self._m[1][1] * tPoint.x) + self._m[2][1] * tPoint.y + self._m[3][1]
    local y = (self._m[1][2] * tPoint.x) + self._m[2][2] * tPoint.y + self._m[3][2]
    return Vec(x,y)
  end

  return setmetatable(M, 
    {__call = function(self,...) 
      return M:new(...) 
  end})
end