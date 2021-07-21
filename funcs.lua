function hypot(...)
  local n = 0
  local args = {...}

  for i = 1, #args do
    n = n + math.abs(tonumber(args[i])) ^ 2
  end
  return math.sqrt(n)
end

function influence(a, b)
  assert(a, 'gde a')
  assert(b, 'gde b')

  local x = b.x - a.x
  local y = b.y - a.y

  local r = hypot(x, y)

  local a1 = b.m / r ^ 2 / a.m

  a.vx = a.vx + (a1 * x / r) * 100
  a.vy = a.vy + (a1 * y / r) * 100
  print(a.vx, a.vy)
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

function collision(a, b)
  if (a.x - b.x) ^ 2 + (a.y - b.y) ^ 2 <= (a.radius + b.radius) ^ 2 then
    local x = a.vx - b.vx
    local y = a.vy - b.vy
    a.vx = (a.vx * (a.m - b.m) + (2 * b.m * b.vx)) / (a.m + b.m)
    a.vy = (a.vy * (a.m - b.m) + (2 * b.m * b.vy)) / (a.m + b.m)

    b.vx = x + a.vx
    b.vy = y + a.vy
  end
end