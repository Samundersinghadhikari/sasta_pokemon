    enemy = {}
    enemy.x = 500
    enemy.y = 350
    enemy.speed = 3
    enemy.spriteSheet = love.graphics.newImage("assests/night_two.png")
    enemy.Grid = anim8.newGrid(80,124, enemy.spriteSheet:getWidth(), enemy.spriteSheet:getHeight())

    enemy.normalSheet = love.graphics.newImage("assests/night_one.png")
    enemy.Gridnormal = anim8.newGrid(80,88, enemy.normalSheet:getWidth(), enemy.normalSheet:getHeight())


    enemy.animations = {}
    enemy.animeSpeed = 0.2
    enemy.animations.down = anim8.newAnimation(enemy.Grid('1-12', 1), enemy.animeSpeed)
    enemy.animations.right = anim8.newAnimation(enemy.Gridnormal('1-9', 1), enemy.animeSpeed)

    enemy.anime = enemy.animations.down 

    enemy.anime:update(dt)

    enemy.anime:draw(enemy.spriteSheet, enemy.x, enemy.y,nil,2)