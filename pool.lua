local class = require "class"

local Pool = class()

function Pool:new()
    self.next_id = 1
    self.objects = {}
end

function Pool:add(obj)
    obj.dead = false
    obj.pool = self

    self.objects[self.next_id] = obj
    self.next_id = self.next_id + 1

    return obj
end

function Pool:update(dt)
    for id, obj in pairs(self.objects) do
        if obj.dead then
            self.objects[id] = nil
        end
    end

    for _, obj in pairs(self.objects) do
        obj:update(dt)
    end
end

function Pool:draw()
    for _, obj in pairs(self.objects) do
        obj:draw()
    end
end

return Pool
