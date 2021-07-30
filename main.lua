local Point = require 'point'

local planets = {
  Point.new(1000, { 375, 375 }, { 0, 0 }),
  Point.new(4,    { 375, 100 }, { math.sqrt(1e3 / 275), 0 }),
  Point.new(1,    { 375, 85  }, { math.sqrt(1e3 / 275) - math.sqrt(5 / 15), 0 }),
}

local scCen = {0, 0, 1}
local step  = 5

function love.load()                                    -- when love loaded
  love.math.setRandomSeed(love.timer.getTime())         -- random seed
  love.window.setMode(1000, 1000, { resizable = true }) -- 1000x1000 with resizing
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

    p.x = p.x + p.vx --* dt                             -- move x
    p.y = p.y + p.vy --* dt                             -- move y
  end


  local pr = love.keyboard.isDown                       -- is button pressed
  local x, y, s = scCen[1], scCen[2], scCen[3]

                                                        -- Moving camera
      if pr 'left'  then scCen[1] = x - step * s        --<
  elseif pr 'right' then scCen[1] = x + step * s        -->
  elseif pr 'up'    then scCen[2] = y + step * s        --^
  elseif pr 'down'  then scCen[2] = y - step * s        --v
                                                        -- Scaling camera
  elseif pr 'home' then scCen[3] = s - dt * s           --+
  elseif pr 'end'  then scCen[3] = s + dt * s           ---
  end
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
  love.graphics.print(('%g %g %g'):format(-x, -y, s))
end
