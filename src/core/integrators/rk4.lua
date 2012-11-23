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

local factor = 1/6

-- 4th order Runge-Kutta integration evaluation
-- We compute at t+dt/2 a 4th-order derivative using Forward Euler
local function rk4Eval(state,dt)
    local vel1 = state.vel
    local acc1 = state.acc    
    local vel2 = state.vel + acc1 * (dt*0.5)
    local acc2 = state.acc    
    local vel3 = state.vel + acc2 * (dt*0.5)
    local acc3 = state.acc    
    local vel4 = state.vel + acc3 * (dt)
    local acc4 = state.acc    
    local dpos = (vel1 + vel2 * 2 + vel3 * 2 + vel4) * (factor * dt)
    local dvel = (acc1 + acc2 * 2 + acc3 * 2 + acc4) * (factor * dt)
    return dpos, dvel    
end

-- Integration
-- Uses rk4Eval in a full Forward Euler step 
local function RK4(agent, dt)
  agent.acc = agent.forceAccum * agent.invMass
  local dP, dV = rk4Eval(agent,dt)
  agent.pos = agent.pos + dP
  agent.vel = (agent.vel + dV):clamp(agent.maxVel)
  agent.forceAccum:clear()  
end

return RK4