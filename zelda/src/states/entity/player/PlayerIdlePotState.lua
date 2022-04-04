

PlayerIdlePotState = Class{__includes = EntityIdleState}


function PlayerIdlePotState:enter(params)

    self.pot = params.pot
     -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0
 
    self.entity:changeAnimation('idle-pot-' .. self.entity.direction)

end

function PlayerIdlePotState:update(dt)
    self.pot.x = self.entity.x 
    self.pot.y = self.entity.y - ( self.pot.height / 2 )

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('carry-pot', {
            pot = self.pot
        })
    elseif love.keyboard.wasPressed('space') then
        self.entity:changeState('throw-pot', {
            pot = self.pot
        })
    end
end
