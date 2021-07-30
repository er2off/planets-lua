local Point = {}
Point.__index = Point -- create class

-- Setters
function Point:__newindex(k, v)
  if k == 'mass' then
    assert(type(v) == 'number')
    rawset(self, 'mass', math.abs(v))
    rawset(self, 'radius', math.sqrt(self.mass / math.pi))
  elseif k == 'radius' then
    assert(type(v) == 'number')
    rawset(self, 'radius', math.abs(v))
    rawset(self, 'mass', self.radius ^ 2)
  else rawset(self, k, v) end
end

-- constructor
function Point.new(mass, pos, vec)
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
  return self
end

-- Hypotenuse
function hypot(...)
  local n, args = 0, {...}

  for i = 1, #args do
    n = n + math.abs(tonumber(args[i])) ^ 2
  end
  return math.sqrt(n)
end

-- Gravity simulation
function Point:influence(b)
  assert(b) -- need b

  local dx = self.x - b.x
  local dy = self.y - b.y

  local r = hypot(dx, dy)
  local acc = self.mass / r ^ 2

  b.vx = b.vx + acc * dx / r
  b.vy = b.vy + acc * dy / r
end

local k = 0.3 -- some number

-- Collision
function Point:collision(b)
  assert(b) -- need b

  -- return if not check
  if not b.check then return end

  -- return if not collide
  if (self.x - b.x) ^ 2 + (self.y - b.y) ^ 2 >= (self.radius + b.radius) ^ 2 then return end

  -- back
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

return Point
