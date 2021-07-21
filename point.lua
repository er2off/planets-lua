local Point = {}
Point.__index = Point

function Point.new(mass, pos, vec)
  local self = setmetatable({}, Point)

  self.m = mass
  self.radius = 2 * self.m

  self.x = pos[1]
  self.y = pos[2]

  self.vx = vec[1]
  self.vy = vec[2]

  self.color = {
    love.math.random(),
    love.math.random(),
    love.math.random(),
  }

  return self
end

function Point:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle('fill', self.x, self.y, self.radius)
  love.graphics.setColor(1, 1, 1)
end

return Point