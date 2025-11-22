local Ball = {}
Ball.__index = Ball

function Ball.new(x, y)
  local instance = setmetatable({}, Ball)
  instance.x = x
  instance.y = y
  instance.r = math.random(10, 18)
  instance.vx = math.random(-400,400)
  instance.vy = math.random(-400,400)
  instance.color = {math.random(), math.random(), math.random()}
  return instance
end

function Ball:update(dt, width, height)
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
  -- Check for wall collisions
  if self.x - self.r < 0 then
    self.x = self.r
    self.vx = -self.vx
  elseif self.x + self.r > width then
    self.x = width - self.r
    self.vx = -self.vx
  end
  if self.y - self.r < 0 then
    self.y = self.r
    self.vy = -self.vy
  elseif self.y + self.r > height then
    self.y = height - self.r
    self.vy = -self.vy
  end
end

function Ball:draw()
  love.graphics.setColor(self.color)
  love.graphics.circle("fill", self.x, self.y, self.r)
end

return Ball
