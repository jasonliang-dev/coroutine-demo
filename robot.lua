local Sprite = require "sprite"
local class = require "class"

local Robot = class()

function Robot:new(desc)
    self.x = desc.x
    self.y = desc.y
    self.facing_right = true
    self.dx = 1
    self.dy = 0

    self.TIMER_INIT = 1
    self.timer = self.TIMER_INIT

    self.walk = Sprite(150, {
        "Characters/character_0015.png",
        "Characters/character_0016.png",
    })

    self.spr = self.walk

    self.co = coroutine.create(Robot.co_update)
    self.co_time = 0
end

function Robot:update(dt)
    self.spr:update(dt)

    if true then
        coroutine.resume(self.co, self, dt)
    else
        self.timer = self.timer - dt

        if self.timer <= 0 then
            self.timer = self.timer + self.TIMER_INIT
            self.dx, self.dy = self.dy, -self.dx

            if self.dx > 0 then
                self.facing_right = true
            elseif self.dx < 0 then
                self.facing_right = false
            end
        end

        local speed = 100
        self.x = self.x + self.dx * speed * dt
        self.y = self.y - self.dy * speed * dt
    end
end

function Robot:repeat_for(time, dt)
    self.co_time = self.co_time + dt
    if self.co_time <= time then
        return true
    else
        self.co_time = 0
        return false
    end
end

function Robot:co_update(dt)
    local speed = 100

    while true do
        self.facing_right = true
        while self:repeat_for(1, dt) do
            self.x = self.x + speed * dt
            _, dt = coroutine.yield()
        end

        while self:repeat_for(1, dt) do
            self.y = self.y + speed * dt
            _, dt = coroutine.yield()
        end

        self.facing_right = false
        while self:repeat_for(1, dt) do
            self.x = self.x - speed * dt
            _, dt = coroutine.yield()
        end

        while self:repeat_for(1, dt) do
            self.y = self.y - speed * dt
            _, dt = coroutine.yield()
        end
    end
end

function Robot:draw()
    love.graphics.setColor(1, 1, 1)

    local sx = self.facing_right and -2 or 2
    love.graphics.draw(self.spr:img(), self.x, self.y, 0, sx, 2, self.spr:img():getWidth() / 2, self.spr:img():getHeight() / 2)
end

return Robot
