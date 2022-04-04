

PlayerThrowPot = Class{__includes = BaseState}

function PlayerThrowPot:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0
    
    self.player:changeAnimation('throw-' .. self.player.direction)
end

function PlayerThrowPot:enter(params)
    self.pot = params.pot
    

    local destinationX = self.pot.x
    local destinationY = self.pot.y



    if self.player.direction == 'left' then
        destinationX = self.player.x - 4 * TILE_SIZE
    elseif self.player.direction == 'right' then
        destinationX = self.player.x + self.player.width + 4 * TILE_SIZE 
    elseif self.player.direction == 'up' then
        destinationY = self.player.y - 4 * TILE_SIZE
    else
        destinationY = self.player.y + 4 * TILE_SIZE
    end

    if destinationX == self.pot.x then
        self.pot.dx = 0
    elseif destinationX - self.player.x > 0 then
        self.pot.dx = POT_SPEED
    else
        self.pot.dx = -POT_SPEED
    end

    if destinationY == self.pot.y then
        self.pot.dy = 0
    elseif destinationY - self.player.y > 0 then
        self.pot.dy = POT_SPEED
    else
        self.pot.dy = -POT_SPEED
    end

    self.player.currentAnimation:refresh()
end

function PlayerThrowPot:update(dt)
    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerThrowPot:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
            math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end