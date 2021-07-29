local Point = require 'point'

local planets = {
  Point.new(1000, { 375, 375 }, { 0, 0 }, true),
  Point.new(4,    { 375, 100 }, { math.sqrt(1e3 / 275), 0 }),
  Point.new(1,    { 375, 85  }, { math.sqrt(1e3 / 275) - math.sqrt(5 / 15), 0 }),
}

local scCen = {0, 0, 1}

function love.load()
  love.math.setRandomSeed(love.timer.getTime())
  love.window.setMode(1000, 1000, { resizable = true })
end

local step = 5

function love.update(dt)
  for i, p in ipairs(planets) do
    for j, l in ipairs(planets) do
      if i ~= j then
        p:influence(l)
        p:collision(l)
      end
      --l.check = false
    end

    -- TODO: fix * dt bug
    p.x = p.x + p.vx --* dt
    p.y = p.y + p.vy --* dt
  end

  local pr = love.keyboard.isDown

  -- Moving
      if pr 'left'  then scCen[1] = scCen[1] - step
  elseif pr 'right' then scCen[1] = scCen[1] + step
  elseif pr 'up'    then scCen[2] = scCen[2] + step
  elseif pr 'down'  then scCen[2] = scCen[2] - step
  -- Scale
  elseif pr 'home' then scCen[3] = scCen[3] - dt
  elseif pr 'end'  then scCen[3] = scCen[3] + dt
  end
end

function love.draw()
  for i = 1, #planets do planets[i]:draw(scCen) end
end
