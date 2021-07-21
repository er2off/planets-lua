local Point = require 'point'
require 'funcs'

local planets = {
  Point.new(15, { 500, 450 }, { 0, 0 }),
  Point.new(10, { 500, 550 }, { 18, 0 }),
  Point.new(2, { 500, 50 }, { 15, 0 }),
}

function love.load()
  love.math.setRandomSeed(love.timer.getTime())
  love.window.setMode(1000, 1000, { resizable = true })
end

function love.update(dt)
  for i = 1, #planets do
    local p = planets[i]
    p.x = p.x + p.vx * dt
    p.y = p.y + p.vy * dt

    wallCollide(p, 'x', 'getWidth')
    wallCollide(p, 'y', 'getHeight')

    influence(planets[2], planets[1])

    for j = 1, #planets do
      if i ~= j then
        collision(p, planets[j])
        --influence(p, planets[j])
      end
    end
  end
end

function love.draw()
  for i = 1, #planets do planets[i]:draw() end
end