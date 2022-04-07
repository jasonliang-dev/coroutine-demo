local Alien = require "alien"
local Robot = require "robot"
local Block = require "block"
local Pool = require "pool"

local entity_pool = Pool()

function love.load()
    love.graphics.setDefaultFilter "nearest"
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

    entity_pool:add(Alien {x = 100, y = 100})
    entity_pool:add(Robot {x = 200, y = 100})
    entity_pool:add(Block {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2})
end

function love.update(dt)
    if love.keyboard.isDown "escape" then
        love.event.push "quit"
    end

    entity_pool:update(dt)
end

function love.draw()
    entity_pool:draw()
end
