--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local keySpawned = false
    local lockSpawned = false

    while not keySpawned and not lockSpawned do
        local keyX = math.random(width)
        local keyY = math.random(height/2-1)
        local lockX = math.random(width)
        local lockY = math.random(height/2-1)
        local color = math.random(4)

        if tiles[keyY][keyX].id == TILE_ID_EMPTY and tiles[lockY][lockX].id == TILE_ID_EMPTY then
            local keyCollected = false

            -- game object - lock block
            local lock = GameObject {
                texture = 'keys-and-locks',
                x = (lockX - 1) * TILE_SIZE,
                y = (lockY - 1) * TILE_SIZE,
                width = 16,
                height = 16,
                frame = color + 4,
                collidable = true,
                hit = true,
                solid = true,

                onCollide = function(lock)   
                    if keyCollected then
                        for o, obj in pairs(objects) do
                            if obj.texture == 'keys-and-locks' then
                                table.remove(objects, o)
                            end
                        end
                        gSounds['powerup-reveal']:play()

                        -- Generating flag
                        local flagSkin = math.random(4)
                        local locations = findFlagPlace(width,height,tiles,objects)
                        
                        -- flag pole
                        table.insert(objects, GameObject {

                            texture = 'flags',
                            x = (locations[2] - 1) * TILE_SIZE,
                            y = (locations[1] - 1) * TILE_SIZE,
                            width = 16,
                            height = 48,
                            frame = flagSkin,
                            consumable = true,

                            onConsume = function(player)
                                gSounds['powerup-reveal']:play()
                                player.winCon = true
                            end

                        })

                        -- flag itself
                        table.insert(objects, GameObject {

                            texture = 'flags',
                            x = (locations[2] - 2 - 1) * TILE_SIZE,
                            y = (locations[1] - 1) * TILE_SIZE,
                            width = 48,
                            height = 16,
                            frame = flagSkin + 4,
                            
                        })
                    else
                        gSounds['empty-block']:play()
                    end
                end
            }
            
            local key = GameObject {
                texture = 'keys-and-locks',
                x = (keyX - 1) * TILE_SIZE,
                y = (keyY - 1) * TILE_SIZE,
                width = 16,
                height = 16,
                frame = color,
                collidable = true,
                consumable = true,
                solid = false,

                onConsume = function(player, key)
                    keyCollected = true
                    player.score = player.score + 550
                    gSounds['powerup-reveal']:play()
                    key = nil
                end
            }
            table.insert(objects, lock)
            table.insert(objects, key)

            lockSpawned = true
            keySpawned = true
            
        end
    end





    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end

function findFlagPlace(width,height,tiles,objects)
    local locations = {}
    local locationFound = false

    for x = width - 2, 1, -1 do
        
        for y=1, height do
            -- Checking whether there is a space for flag pole or not

            if tiles[y][x].id == TILE_ID_GROUND then
                local verticalIndex = y 
                local horizontalIndex = x 
                local val = 0
                local val2 = 0

                for k = 1, 3 do
                    verticalIndex = verticalIndex - 1
                    if tiles[verticalIndex][x].id == TILE_ID_EMPTY and not isOccupiedByObj(objects,x,verticalIndex) then
                        val = val + 1
                    end
                end
                
                for k2 = 1, 3 do
                    horizontalIndex = horizontalIndex - 1
                    if tiles[verticalIndex][horizontalIndex].id == TILE_ID_EMPTY and not isOccupiedByObj(objects,horizontalIndex,verticalIndex) then
                        val2 = val2 + 1
                    end
                end

                if val == 3 and val2 == 3 then
                    locationFound = true
                    locations[#locations+1] = verticalIndex 
                    locations[#locations+1] = x
                    break
                end

            end
        end

        if locationFound then
            break
        end

    end

    return locations
end

function isOccupiedByObj(objects, x,  y)
    for o , obj in pairs(objects) do
        if obj.x == (x - 1) * TILE_SIZE and obj.y == (y - 1) * TILE_SIZE then
            return true
        end
    end
    return false
end