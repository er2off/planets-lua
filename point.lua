local Point = {}
Point.__index = Point

function Point.new(mass, pos, vec, center)
  local self = setmetatable({}, Point)

  self.mass = mass
  self.radius = 5 * math.sqrt(math.abs(self.mass) / math.pi)

  self.x = pos[1]
  self.y = pos[2]

  self.vx = vec[1]
  self.vy = vec[2]

  self.color = {
    love.math.random(),
    love.math.random(),
    love.math.random(),
  }

  self.check = true
  self.center = center

  return self
end

function hypot(...)
  local n, args = 0, {...}

  for i = 1, #args do
    n = n + math.abs(tonumber(args[i])) ^ 2
  end
  return math.sqrt(n)
end

function Point:influence(b)
  assert(b)

  local dx = self.x - b.x
  local dy = self.y - b.y

  local r = hypot(dx, dy)
  local acc = self.mass / r ^ 2

  b.vx = b.vx + acc * dx / r
  b.vy = b.vy + acc * dy / r

end

local k = 0.3

function Point:collision(b)
  assert(b)

  if not b.check then return end

  if (self.x - b.x) ^ 2 + (self.y - b.y) ^ 2 >= (self.radius + b.radius) ^ 2 then return end

  b.x = b.x - b.vx
  b.y = b.y - b.vy

  self.x = self.x - self.vx
  self.y = self.y - self.vy

  self.vx, self.vy, b.vx, b.vy =
    self.vx - (1 + k) * b.mass / (self.mass + b.mass) * (self.vx - b.vx),
    self.vy - (1 + k) * b.mass / (self.mass + b.mass) * (self.vy - b.vy),
    b.vx + (1 + k) * self.mass / (self.mass + b.mass) * (self.vx - b.vx),
    b.vy + (1 + k) * self.mass / (self.mass + b.mass) * (self.vy - b.vy)
end

function Point:draw(scCen)
  if not scCen then scCen = {} end
  local x, y, s =
    scCen[1] or 0,
    scCen[2] or 0,
    scCen[3] or 1

  love.graphics.setColor(self.color)
  love.graphics.circle('fill', x + self.x / s, y + self.y / s, self.radius / s)
  love.graphics.setColor(1, 1, 1)
end

return Point
