local class = require "class"
local lume = require "lume"

local Sprite = class()
Sprite.cache = {}

function Sprite:new(msframe, images)
    self.elapsed = 0
    self.msframe = msframe
    self.frames = lume.map(images, function(i)
        if Sprite.cache[i] then
            return Sprite.cache[i]
        else
            local new = love.graphics.newImage(i)
            Sprite.cache[i] = new
            return new
        end
    end)
end

function Sprite:update(dt)
    self.elapsed = math.fmod(self.elapsed + dt * 1000, self.msframe * #self.frames)
end

function Sprite:img()
    local frame = math.floor(self.elapsed / self.msframe) + 1
    return self.frames[frame]
end

return Sprite
