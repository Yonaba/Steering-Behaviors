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
  local _PATH = (...):match('%w+%.')
  local Vec = require (_PATH .. 'core.vector')
  local Zero = Vec()
  
  local min = math.min  
  local SteeringBehaviour = {}

  function SteeringBehaviour.seek(agent,target)
    local requiredVel = (target.pos - agent.pos):normalize() * agent.maxVel
    return requiredVel - agent.vel  
  end

  function SteeringBehaviour.flee(agent,target, panicDistance)
    if panicDistance then
      if agent.pos:distSqTo(target.pos) < panicDistance * panicDistance then
        local requiredVel = (agent.pos - target.pos):normalize() * agent.maxVel
        return requiredVel - agent.vel     
      end
    end
    return Zero   
  end
  
  local DecelerationType = {slow = 3, normal = 2, fast = 1}  
  function SteeringBehaviour.arrive(agent, target, typeDec)
    local vTarget = target.pos - agent.pos
    local distToTarget = vTarget:mag()
    if distToTarget > 0 then
      typeDec = typeDec or 'normal'
      local vel = distToTarget/DecelerationType[typeDec]
      vel = min(vel, agent.maxVel:mag())
      local requiredVel = vTarget * (vel/distToTarget)
      return requiredVel - agent.vel
    end
    return Zero
  end
  
  return SteeringBehaviour
end  