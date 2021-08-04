local screen = {}
screen.__index = screen

function screen.new(center, step)
  local self = setmetatable({}, screen)

  self.center = center or {0, 0, 1}
  self.step   = step   or 5

  return self
end

function screen:scale(plus, minus)
  local st = 0.1
  if not (plus or minus) then return end
  if minus then st = -st end

  if self.center[3] < 0.1
     and minus
  then return end

  self.center[3] = self.center[3] + st * self.center[3]
end

function screen:move(l, r, u, d)
  local step   = self.step
  local dx, dy = 0, 0

  if l then dx = -step end
  if r then dx = step  end
  if u then dy = step  end
  if d then dy = -step end

  self:movex(dx, dy)
end

function screen:movex(dx, dy)
  local c = self.center
  local s = c[3]

  if dx then c[1] = c[1] + dx / s end
  if dy then c[2] = c[2] + dy / s end
end

function screen:dimens()
  return
    self.center[1] or 0,
    self.center[2] or 0,
    self.center[3] or 1
end

return screen
