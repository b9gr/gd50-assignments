

PowerUp = Class{}

function PowerUp:init(x,y)

    self.width = 16
    self.height = 16
    self.dy = math.random(20,45)
    self.dx = 0

    self.x = x
    self.y = y

    self.inPlay = true

end

function PowerUp:update(dt)
    self.y = self.y + self.dy * dt
    self.x = self.x + self.dx * dt

end

function PowerUp:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

function PowerUp:hit()
    self.inPlay = false
end

function PowerUp:render()
    if self.inPlay then
        if self.type == 1 then
            love.graphics.draw(gTextures['main'], 
            gFrames['powerups'][1],
            self.x, self.y)
        else
            love.graphics.draw(gTextures['main'], 
            gFrames['powerups'][2],
            self.x, self.y)
        end
    end
end