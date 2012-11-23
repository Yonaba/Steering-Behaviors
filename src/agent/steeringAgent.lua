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

local Vec = require 'src.core.vector'
local Agent = require 'src.agent.agent'
local SteeringBehaviour = require 'src.behavior.steering'

local SteeringAgent = Agent()
SteeringAgent.steering = SteeringBehaviour()
SteeringAgent.minVelMagSq = 1e-4
SteeringAgent.velHeading = Vec()
SteeringAgent.velPerp = Vec()

SteeringAgent.__index = SteeringAgent

function SteeringAgent:new()
  local newSteeringAgent = {}
  return setmetatable(newSteeringAgent,SteeringAgent)
end

function SteeringAgent:updateLocalReference()
  if self.vel:magSq() > self.minVelMagSq then
    self.velHeading = self.vel:getNormalized()
    self.velPerp = self.velHeading:getPerp()
  end
end

function SteeringAgent:update(target,dt)
  self.forceAccum = self.steering.seek(self,target)
  self:integrate(dt)
  self:updateLocalReference()
end

getmetatable(SteeringAgent)
  .__call = function(self,...) 
    return SteeringAgent:new(...) 
end
return SteeringAgent
