local Ball = require "Ball"

local balls = {}
local win_width, win_height

function love.load()
  love.window.maximize()
  win_width = love.graphics.getWidth()
  win_height = love.graphics.getHeight()
  -- Spawn 5 random balls to start
  for i = 1, 5 do
    table.insert(balls, Ball.new(win_width / 2, win_height / 2))
  end
end

-- Add a new ball wherever you click
function love.mousepressed(x, y, button)
  if button == 1 then   -- Left click
    table.insert(balls, Ball.new(x, y))
  end
  if button == 2 then
    table.insert(balls, Ball.new(x,y))
    table.insert(balls, Ball.new(x,y))
    table.insert(balls, Ball.new(x,y))
    table.insert(balls, Ball.new(x,y))
    table.insert(balls, Ball.new(x,y))
  end
end

function love.resize(w, h)
  win_width = w
  win_height = h
end

function love.update(dt)
  -- 1. Update individual balls
  for _, ball in ipairs(balls) do
    ball:update(dt, win_width, win_height)
  end

  -- 2. Check collisions between ALL pairs
  for i = 1, #balls do
    for j = i + 1, #balls do
      resolveCollision(balls[i], balls[j])
    end
  end
end

function resolveCollision(b1, b2)
  local dx = b2.x - b1.x
  local dy = b2.y - b1.y
  local dist = math.sqrt(dx * dx + dy * dy)
  local minDist = b1.r + b2.r

  if dist < minDist then
    -- Swap velocities (elastic collision approximation)
    local tempvx, tempvy = b1.vx, b1.vy
    b1.vx, b1.vy = b2.vx, b2.vy
    b2.vx, b2.vy = tempvx, tempvy

    -- Anti-stick: push them apart
    local overlap = minDist - dist
    local angle = math.atan2(dy, dx)
    b1.x = b1.x - math.cos(angle) * overlap / 2
    b1.y = b1.y - math.sin(angle) * overlap / 2
    b2.x = b2.x + math.cos(angle) * overlap / 2
    b2.y = b2.y + math.sin(angle) * overlap / 2
  end
end

function love.draw()
  for _, ball in ipairs(balls) do
    ball:draw()
  end

  -- Instructions
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("Left click to add one ball,\nRight click to add 5 balls. Total balls: " .. #balls, 10, 10)
end
