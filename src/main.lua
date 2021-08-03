local Point = require 'src.point'
local config= require 'config'

local planets = {
  Point.new(1000, { 375, 375 }, { 0, 0 }),
  Point.new(4,    { 375, 100 }, { math.sqrt(1e3 / 275), 0 }),
  Point.new(1,    { 375, 85  }, { math.sqrt(1e3 / 275) - math.sqrt(5 / 15), 0 }),
}

local debug, scCen, step, contr =
  config.debug,
  config.scCen,
  config.step,
  config.controls

function love.load()                                    -- when love loade
  love.window.setFullscreen(true)                       -- set fullscreen mode
  love.keyboard.setKeyRepeat(true)                      -- allow key repeat
end

function love.update(dt)                                -- when update
  for i, p in ipairs(planets) do                        -- looping all planets
    for j, l in ipairs(planets) do                      -- also
      if i ~= j then                                    -- if its not equals
        p:influence(l)                                  -- simulate gravity
        p:collision(l)                                  -- and collision
      end
      --l.check = false
    end

    p.x = p.x + p.vx * dt * 55                          -- move x
    p.y = p.y + p.vy * dt * 55                          -- move y
  end
end

function love.keypressed(k)                             -- Keyboard
  local function kpr(y) return k == y end

  local x, y, s = scCen[1], scCen[2], scCen[3]
                                                        -- Moving camera
  if kpr(contr.l)  then scCen[1] = x - step * s end     --<
  if kpr(contr.r)  then scCen[1] = x + step * s end     -->
  if kpr(contr.u)  then scCen[2] = y + step * s end     --^
  if kpr(contr.d)  then scCen[2] = y - step * s end     --v
                                                        -- Scaling camera
  if kpr(contr.sp) then scCen[3] = s + 0.1 end            --+
  if kpr(contr.sm) then scCen[3] = s - 0.1 end            ---
end

function love.mousemoved(_, _, dx, dy)                  -- Mouse and touch
  if not love.mouse.isDown(1) then return end
  scCen[1] = scCen[1] + dx * scCen[3]
  scCen[2] = scCen[2] + dy * scCen[3]
end

function love.wheelmoved(_, y)                          -- Mouse wheel
  scCen[3] = scCen[3] + y
end

function love.draw()                                    -- drawing
  local x, y, s =
     scCen[1] or 0,
     scCen[2] or 0,
     scCen[3] or 1

  for i = 1, #planets do
    local self = planets[i]
    love.graphics.setColor(self.color)                 -- set planet color
    love.graphics.circle('fill',                       -- fill circle
      x + self.x / s,                                  -- x
      y + self.y / s,                                  -- y
      self.radius / s                                  -- radius
    )
    love.graphics.setColor(1, 1, 1)                    -- reset color
  end

  if debug then love.graphics.print(('%g %g %g'):format(-x, -y, s)) end
end
