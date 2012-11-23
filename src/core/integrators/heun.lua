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


-- Heun integration evaluation, similar to 2nd-order Runge-Kutta
-- We compute at t+dt/2 a 2nd-order derivative using Forward Euler
local function heunEval(state,dt)
    local vel1 = state.vel
    local acc1 = state.acc    
    local vel2 = state.vel + acc1 * (dt*0.5)
    local acc2 = state.acc    
    local dpos = (vel1 + vel2) * (0.5 * dt)
    local dvel = (acc1 + acc2) * (0.5 * dt)
    return dpos, dvel    
end


-- Integration
-- Uses heunEval in a full Forward Euler step
local function Heun(agent, dt)
  agent.acc = agent.forceAccum * agent.invMass
  local dP, dV = heunEval(agent,dt)
  agent.pos = agent.pos + dP
  agent.vel = (agent.vel + dV):clamp(agent.maxVel)
  agent.forceAccum:clear()
end

return Heun