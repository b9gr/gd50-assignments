--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.initX = self.x
    self.initY = self.y

    self.replacementX = 0
    self.replacementY = 0

    -- default empty collision callback
    self.onCollide = function() end

    self.onConsume = function() end
end

function GameObject:update(dt)
    if self.dx ~= nil and self.dy ~= nil then
        if self.dx ~= 0 then
            self.x = self.x + self.dx * dt
        elseif self.dy ~= 0 then
            self.y = self.y + self.dy * dt
        end
    end
end

function GameObject:calculateReplacement(dimension)
    if dimension == 1 then
        return math.abs(self.x - self.initX) 
    else
        return math.abs(self.y - self.initY) 
    end
end

function GameObject:collides(target)
    --local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
    --love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
end