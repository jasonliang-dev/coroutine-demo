local Sprite = require "sprite"
local Bullet = require "bullet"
local class = require "class"
local lume = require "lume"

local Block = class()

function Block:new(desc)
    self.x = desc.x
    self.y = desc.y

    self.neutral = Sprite(150, {
        "Characters/character_0013.png",
    })

    self.aggressive = Sprite(150, {
        "Characters/character_0014.png",
    })

    self.spr = self.neutral

    -- one of move, shoot1, or shoot2
    self.stat = "move"

    self.target_x = math.random() * love.graphics.getWidth()
    self.target_y = math.random() * love.graphics.getHeight()

    self.shoot_angle = 0
    self.shoot_timer = 0

    self.co = coroutine.create(Block.co_update)
    self.co_time = 0
end

function Block:update(dt)
    if true then
        coroutine.resume(self.co, self, dt)
    else
        if self.stat == "move" then
            local rx, ry = self.target_x, self.target_y

            if lume.distance(self.x, self.y, rx, ry) > 1 then
                self.x = lume.lerp(self.x, rx, 4 * dt)
                self.y = lume.lerp(self.y, ry, 4 * dt)
            else
                self.stat = "shoot1"
                self.shoot_angle = 0
                self.shoot_timer = 0
            end
        elseif self.stat == "shoot1" then
            self.shoot_timer = self.shoot_timer + dt
            if self.shoot_timer > 0.1 then
                self.shoot_timer = self.shoot_timer - 0.1
                local dx, dy = lume.vector(self.shoot_angle, 1)
                self.pool:add(Bullet {x = self.x, y = self.y, dx = dx, dy = dy})
                self.shoot_angle = self.shoot_angle + math.pi / 8
            end

            if self.shoot_angle > math.pi * 2 then
                self.stat = "shoot2"
            end
        elseif self.stat == "shoot2" then
            local angle = 0
            while angle < math.pi * 2 do
                local dx, dy = lume.vector(angle, 1)
                self.pool:add(Bullet {x = self.x, y = self.y, dx = dx, dy = dy})
                angle = angle + math.pi / 8
            end

            self.target_x = math.random() * love.graphics.getWidth()
            self.target_y = math.random() * love.graphics.getHeight()
            self.stat = "move"
        end
    end
end

function Block:repeat_for(time, dt)
    self.co_time = self.co_time + dt
    if self.co_time <= time then
        return true
    else
        self.co_time = 0
        return false
    end
end

function Block:co_update(dt)
    while true do
        local rx = math.random() * love.graphics.getWidth()
        local ry = math.random() * love.graphics.getHeight()

        while lume.distance(self.x, self.y, rx, ry) > 1 do
            self.x = lume.lerp(self.x, rx, 4 * dt)
            self.y = lume.lerp(self.y, ry, 4 * dt)
            _, dt = coroutine.yield()
        end

        local angle = 0
        while angle < math.pi * 2 do
            while self:repeat_for(0.1, dt) do _, dt = coroutine.yield() end
            local dx, dy = lume.vector(angle, 1)
            self.pool:add(Bullet {x = self.x, y = self.y, dx = dx, dy = dy})
            angle = angle + math.pi / 8
            _, dt = coroutine.yield()
        end

        angle = 0
        while angle < math.pi * 2 do
            local dx, dy = lume.vector(angle, 1)
            self.pool:add(Bullet {x = self.x, y = self.y, dx = dx, dy = dy})
            angle = angle + math.pi / 8
        end

        _, dt = coroutine.yield()
    end
end

function Block:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.spr:img(), self.x, self.y, 0, 2, 2, self.spr:img():getWidth() / 2, self.spr:img():getHeight() / 2)
end

return Block
