

PlayerCarryPot = Class{__includes = EntityWalkState}

function PlayerCarryPot:enter(params)
    -- render offset for spaced character sprite; negated in render function of state
    self.entity.offsetY = 5
    self.entity.offsetX = 0
    self.pot = params.pot
    
end

function PlayerCarryPot:update(dt)
    self.pot.x = self.entity.x 
    self.pot.y = self.entity.y - ( self.pot.height / 2 )
    self.pot.initX = self.pot.x
    self.pot.initY = self.pot.y

    EntityWalkState.update(self, dt)

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pot-walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pot-walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pot-walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pot-walk-down')
    else
        self.entity:changeState('idle-pot', {
            pot = self.pot
        })
    end

end
