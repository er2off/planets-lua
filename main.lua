local Point = require 'point'

local planets = {
  Point.new(1000, { 500, 500 }, { 0, 0 }, true),
  Point.new(9,    { 500, 120 }, { math.sqrt(1e3 / 400), 0 }),
  Point.new(2,    { 500, 85  }, { math.sqrt(1e3 / 400) - math.sqrt(11 / 35), 0 }),
}

function love.load()
  love.math.setRandomSeed(love.timer.getTime())
  love.window.setMode(1000, 1000, { resizable = true })
end

local g = love.graphics
function wallCollide(v, d, fn)
  if v[d] - v.radius < 0 or 
  v[d] + v.radius > g[fn]() then
    v['v'..d] = -v['v'..d]
    if     v[d] - v.radius < 0       then v[d] = v.radius
    elseif v[d] + v.radius > g[fn]() then v[d] = g[fn]() - v.radius
    end
  end
end

function love.update(dt)
  for i, p in ipairs(planets) do
    for j, l in ipairs(planets) do
      if i ~= j then
        p:influence(l)
        p:collision(l)
      end
      --l.check = false
    end

    wallCollide(p, 'x', 'getWidth')
    wallCollide(p, 'y', 'getHeight')

    -- TODO: fix * dt bug
    p.x = p.x + p.vx --* dt
    p.y = p.y + p.vy --* dt
  end
end

function love.draw()
  for i = 1, #planets do planets[i]:draw() end
end
