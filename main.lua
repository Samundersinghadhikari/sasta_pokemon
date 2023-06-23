---@diagnostic disable: lowercase-global

--load everything
local showPlayerX = false
projectiles = {}

function love.load()
    Music = {}
    Music.hold = love.audio.newSource("assests/phir.mp3", "stream")
    love.graphics.setDefaultFilter("nearest", "nearest")
    local wf = require "lib/windfield"
    duniya = wf.newWorld(0,0)
    local anim8 = require "lib/anim8"
    sti = require 'lib/sti'
    camera = require 'lib/camera'
    cam = camera()
    WorldHai = sti('assests/SpriteSheet/world_v2.lua')
    love.window.setTitle("sastaPokemon")
    love.graphics.setBackgroundColor(1, 0.5, 1)
    player = {}
    player.x = 380
    player.y = 250
    player.collider = duniya:newBSGRectangleCollider(300,300,20,30,10)
    player.collider:setFixedRotation(true)
    player.speed = 200
    player.spriteSheet = love.graphics.newImage("assests/SpriteSheet/ash.png")
    player.Grid = anim8.newGrid(68, 72, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.animations = {}
    player.animeSpeed = 0.2
    player.animations.down = anim8.newAnimation(player.Grid('1-4', 1), player.animeSpeed)
    player.animations.left = anim8.newAnimation(player.Grid('1-4', 2), player.animeSpeed)
    player.animations.right = anim8.newAnimation(player.Grid('1-4', 3), player.animeSpeed)
    player.animations.up = anim8.newAnimation(player.Grid('1-4', 4), player.animeSpeed)
    player.anime = player.animations.down
    local wall = duniya:newRectangleCollider(2,2,5,900)
    wall:setType('static')

    --fireball
    fireball = {}
    fireball.spriteSheet = love.graphics.newImage("assests/SpriteSheet/fireball.png")
    fireball.Grid = anim8.newGrid(153, 154, fireball.spriteSheet:getWidth(), fireball.spriteSheet:getHeight())
    fireball.animations = {}
    fireball.animeSpeed = 0.2
    fireball.animations.fire = anim8.newAnimation(fireball.Grid('1-6', 1), fireball.animeSpeed)
    fireball.anime = fireball.animations.fire


    --enemy

    enemy = {}
    enemy.x = 500
    enemy.y = 350
    enemy.speed = 3
    enemy.spriteSheet = love.graphics.newImage("assests/SpriteSheet/death.png")
    enemy.Grid = anim8.newGrid(140, 93, enemy.spriteSheet:getWidth(), enemy.spriteSheet:getHeight())
    enemy.animations = {}
    enemy.animeSpeed = 0.1
    enemy.animations.down = anim8.newAnimation(enemy.Grid('1-8', 1), enemy.animeSpeed)
    enemy.animations.left = anim8.newAnimation(enemy.Grid('1-8', 2), enemy.animeSpeed)
    enemy.animations.right = anim8.newAnimation(enemy.Grid('1-8', 3), enemy.animeSpeed)
    enemy.animations.up = anim8.newAnimation(enemy.Grid('1-8', 7), enemy.animeSpeed)
    enemy.anime = enemy.animations.down
end

-- update

function love.update(dt)
    local ismoving = false
    local vx = 0
    local vy = 0


    if love.keyboard.isDown("right") then
        vx = player.speed
        player.anime = player.animations.right
        ismoving = true
    end
    if love.keyboard.isDown("left") then
        vx = player.speed * -1
        player.anime = player.animations.left
        ismoving = true
    end
    if love.keyboard.isDown("up") then
        vy = player.speed * -1
        player.anime = player.animations.up
        ismoving = true
    end
    if love.keyboard.isDown("down") then
        vy = player.speed
        player.anime = player.animations.down
        ismoving = true
    end

    player.collider:setLinearVelocity(vx,vy)

    if ismoving == false then
        player.anime:gotoFrame(1)
    end


    if love.keyboard.isDown("i") then
        showPlayerX = not showPlayerX -- Toggle the visibility state on each press
    end

    duniya:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    player.anime:update(dt)

    Walls = {}

    --if WorldHai.layers["walls"] then
       -- for i,obj in pairs(WorldHai.layers["walls"].objects) do
        --    local divar = duniya:newRectangleCollider(obj.x,obj.y,obj.width,obj.height)
        --    divar:setType("static")
         --   table.insert(Walls,divar)
      --  end

  --  end

    cam:lookAt(player.x,player.y)

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local mapWidth = WorldHai.width * WorldHai.tilewidth
    local mapHeight = WorldHai.height * WorldHai.tileheight

    cam.x = math.max(cam.x, screenWidth / 2)
    cam.x = math.min(cam.x, mapWidth - screenWidth / 2)
    cam.y = math.max(cam.y, screenHeight / 2)
    cam.y = math.min(cam.y, mapHeight - screenHeight / 2)




    enemy.anime:update(dt)

    if player.x == enemy.x then
        enemy.anime = enemy.animations.right
    elseif player.x < enemy.x then
        enemy.anime = enemy.animations.down
    end



    function love.keypressed(key)
        if key == "space" then
            local direction = getDirection(player.anime) -- Get the direction the player is facing
        local projectile = {
            x = player.x,
            y = player.y,
            velocity = 300,
            size = 5,
            direction = direction -- Store the direction in the projectile
        }
        table.insert(projectiles, projectile)
        end
    end

    for i, projectile in ipairs(projectiles) do
        -- Update projectile position based on direction
        if projectile.direction == "right" then
            projectile.x = projectile.x + projectile.velocity * dt
        elseif projectile.direction == "left" then
            projectile.x = projectile.x - projectile.velocity * dt
        elseif projectile.direction == "up" then
            projectile.y = projectile.y - projectile.velocity * dt
        elseif projectile.direction == "down" then
            projectile.y = projectile.y + projectile.velocity * dt
        end
    end

    fireball.anime:update(dt)

    function getDirection(animation)
        if animation == player.animations.right then
            return "right"
        elseif animation == player.animations.left then
            return "left"
        elseif animation == player.animations.up then
            return "up"
        elseif animation == player.animations.down then
            return "down"
        end
    end

end

--draw

function love.draw()
    Music.hold:play()

    cam:attach()
        -- WorldHai:draw()
        WorldHai:drawLayer(WorldHai.layers["ground"])
        WorldHai:drawLayer(WorldHai.layers["home"])
        player.anime:draw(player.spriteSheet, player.x, player.y,nil,0.5,nil,34,36)
        for i, projectile in ipairs(projectiles) do
            love.graphics.setColor(1,1,1)
            -- love.graphics.circle("fill", projectile.x, projectile.y, projectile.size)
            fireball.anime:draw(fireball.spriteSheet, projectile.x, projectile.y,nil,0.2)
        end
        duniya:draw()
    cam:detach()

    --enemy
    -- enemy
    -- enemy
    -- enemy.anime:draw(enemy.spriteSheet, enemy.x, enemy.y, nil, 0.8)

    if showPlayerX then
        love.graphics.print("width=" .. tostring(player.x), 10, 20)
        love.graphics.print("height=" .. tostring(player.y), 10, 40)
    end

    
end
