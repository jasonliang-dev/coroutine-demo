local class = require "class"

local Bullet = class()

function Bullet:new(desc)
    self.x = desc.x
    self.y = desc.y
    self.dx = desc.dx
    self.dy = desc.dy
end

function Bullet:update(dt)
    local speed = 600
    self.x = self.x + self.dx * speed * dt
    self.y = self.y + self.dy * speed * dt

    if self.x < 0 or self.x > love.graphics.getWidth()
        or self.y < 0 or self.y > love.graphics.getHeight() then
        self.dead = true
    end
end

function Bullet:draw()
    love.graphics.setColor(1, 1, 0)
    love.graphics.circle("fill", self.x, self.y, 10)
end

return Bullet
