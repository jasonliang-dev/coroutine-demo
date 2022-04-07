local Sprite = require "sprite"
local class = require "class"

local Alien = class()

function Alien:new(desc)
    self.x = desc.x
    self.y = desc.y
    self.facing_right = false

    self.walk = Sprite(120, {
        "Characters/character_0000.png",
        "Characters/character_0001.png",
    })

    self.idle = Sprite(100, {
        "Characters/character_0000.png",
    })

    self.spr = self.idle
end

function Alien:update(dt)
    self.spr:update(dt)

    local dx, dy = 0, 0
    if love.keyboard.isDown "w" then dy = dy - 1 end
    if love.keyboard.isDown "s" then dy = dy + 1 end
    if love.keyboard.isDown "a" then dx = dx - 1 end
    if love.keyboard.isDown "d" then dx = dx + 1 end

    local len = math.sqrt(dx * dx + dy * dy)
    if len == 0 then
        self.spr = self.idle
    else
        self.spr = self.walk
        dx, dy = dx / len, dy / len

        local speed = 300
        self.x = self.x + dx * speed * dt
        self.y = self.y + dy * speed * dt

        if dx > 0 then
            self.facing_right = true
        elseif dx < 0 then
            self.facing_right = false
        end
    end
end

function Alien:draw()
    love.graphics.setColor(1, 1, 1)

    local sx = self.facing_right and -2 or 2
    love.graphics.draw(self.spr:img(), self.x, self.y, 0, sx, 2, self.spr:img():getWidth() / 2, self.spr:img():getHeight() / 2)
end

return Alien
