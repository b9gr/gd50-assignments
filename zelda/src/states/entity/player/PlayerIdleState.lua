--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:enter(params)
    
    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    -- 2 pixel enlarging for collision detection
    local direction = self.entity.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.entity.x - hitboxWidth
        hitboxY = self.entity.y + 2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.entity.x + self.entity.width
        hitboxY = self.entity.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.entity.x
        hitboxY = self.entity.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.entity.x
        hitboxY = self.entity.y + self.entity.height
    end

    self.hiddenBox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('walk')
    end

    local pot, index
    for o, object in pairs(self.dungeon.currentRoom.objects) do
        if object:collides(self.hiddenBox) and love.keyboard.wasPressed('space') and object.solid then
            --table.remove(self.dungeon.currentRoom.objects, o)
            pot = object
            index = o
            break
        end
    end

    if pot then 
        self.entity:changeState('idle-pot', {
            pot = pot
        })
    elseif love.keyboard.wasPressed('space') then
        self.entity:changeState('swing-sword')
    end
        


end


function PlayerIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX), math.floor(self.entity.y - self.entity.offsetY))

    --love.graphics.setColor(255, 0, 255, 255)
    --love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    --love.graphics.rectangle('fill', self.hiddenBox.x, self.hiddenBox.y,
    --self.hiddenBox.width, self.hiddenBox.height)
    --love.graphics.setColor(255, 255, 255, 255)
end
