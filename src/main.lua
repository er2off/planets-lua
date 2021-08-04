local Point = require 'src.point'
local scr   = require 'src.screen'
local config= require 'config'

local planets = {
  Point.new(1000, { 375, 375 }, { 0, 0 }),
  Point.new(4,    { 375, 100 }, { math.sqrt(1e3 / 275), 0 }),
  Point.new(1,    { 375, 85  }, { math.sqrt(1e3 / 275) - math.sqrt(5 / 15), 0 }),
}

screen = scr.new(config.scCen, config.step)
local contr = config.controls

function love.load()                                    -- when love loade
  love.window.setFullscreen(true)                       -- set fullscreen mode
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

    p.x = p.x + p.vx --* dt * 55                        -- move x
    p.y = p.y + p.vy --* dt * 55                        -- move y
  end
                                                        -- Keyboard
  local kpr = love.keyboard.isDown

  screen:move(                                          -- Moving camera
    kpr(contr.l),                                       --<
    kpr(contr.r),                                       -->
    kpr(contr.u),                                       --^
    kpr(contr.d)                                        --v
  )

  screen:scale(                                         -- Scale camera
    kpr(contr.sp),                                      --+
    kpr(contr.sm)                                       ---
  )
end

function love.mousemoved(_, _, dx, dy)                  -- Mouse and touch
  if not love.mouse.isDown(1) then return end
  screen:movex(dx, dy)
end

function love.wheelmoved(_, y)                          -- Mouse wheel
  screen:scale(y > 0, y < 0)
end

function love.draw()                                    -- drawing
  local x, y, s = screen:dimens()
  local ww, wh = love.window.getMode()

  if debug then
     love.graphics.print(('%g %g %g'):format(-x, -y, s), 0, 0)
     love.graphics.print(('%g %g'):format(ww, wh), 0, 10)
  end

  if s == 0 then return end
  for i = 1, #planets do
    local self = planets[i]
    local fx, fy, fr =
      x + self.x  * s,
      y + self.y  * s,
      self.radius * s

    love.graphics.setColor(self.color)                 -- set planet color
    love.graphics.circle('fill', fx, fy, fr)           -- draw circle
    love.graphics.setColor(1, 1, 1)                    -- reset color
  end
end
