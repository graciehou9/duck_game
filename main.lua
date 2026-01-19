-- alias love="/Users/graciehou/Downloads/love.app/Contents/MacOS/love" ABSOLUTE_PATH_TO_PROJECT_FOLDER

Object = require 'classic'
player = Object:extend()

function player:new(image, x, y, size)
    self.image = image
    self.x = x
    self.y = y
    self.size = size
    self.speed = 275
    self.width = self.image:getWidth() * 1.7
    self.height = self.image:getHeight() * 1.7
    self.lives = 3
    self.score = 0
end

function player:move(x,y)
    self.x = self.x + x
    self.y = self.y + y
end


grape = Object:extend()

function grape:new(image, x, y, size)
    self.image = image
    self.x = x
    self.y = y
    self.size = size
    self.speed = 150
    self.width = self.image:getWidth() * 1.7
    self.height = self.image:getHeight() * 1.7
end

function grape:move(dt) 
    -- self.x = self.x + x --x shouldn't change
    self.y = self.y + self.speed*dt
end


function checkCollision(a, b)
    return a.x < b.x + 5*b.width/10 and
           b.x < a.x + 8*a.width/10 and
           a.y < b.y + 8*b.height/10 and
           b.y < a.y + 8*a.height/10
end

bullet = Object:extend()

function bullet:new(image, x, y)
    self.image = image
    self.x = x
    self.y = y
    self.speed = 500
    self.width = self.image:getWidth() * 1.7
    self.height = self.image:getHeight() * 1.7
end

function bullet:move(dt)
    self.y = self.y - self.speed * dt
end

function shoot()
    if love.keyboard.isDown("space") then
        bullet1 = bullet(bulletImage, player1.x + player1.width/2 - bulletImage:getWidth()/2, player1.y) -- is y center of player1?

        table.insert(bullets, bullet1)
        pop:stop()
        pop:play()
    end
end

function love.keypressed(key)
    if key == "space" then
        shoot()
    end
end

function love.load()
    background = love.graphics.newImage("sky.png")
    victory = love.graphics.newImage("Light.png")
    gameover = love.graphics.newImage("Stars.png")
    
    playerImage = love.graphics.newImage("player.png")
    player1 = player(playerImage, 350, 450, 100)

    grapeImage = love.graphics.newImage("grape.png")
    grape1 = grape(grapeImage, 150, 0, 100)
    grape2 = grape(grapeImage, 375, 0, 100)
    grape3 = grape(grapeImage, 600, 0, 100)

    hitImage = love.graphics.newImage("hit.png")
    hitTimer = 0

    bullets = {}

    backgroundMusic = love.audio.newSource("sound.mp3", "stream")
    startMusic = love.audio.newSource("mission_start.wav", "stream")
    gameoverMusic = love.audio.newSource("game_over.wav", "stream")
    victoryMusic = love.audio.newSource("mission_complete.wav", "stream")

    pop = love.audio.newSource("pop.wav", "static")
    chew = love.audio.newSource("chew.wav", "static")
    chirp = love.audio.newSource("Squawk.wav", "static")
    
    backgroundMusic:play()
    startMusic:play()

    gameState = "playing"

end


function love.update(dt)
    if gameState == "playing" then

        if player1.lives <= 0 then
            gameState = "lose"
            
            gameoverMusic:play()
        end

        if player1.score >= 3 then
            gameState = "win"
            
            victoryMusic:play()
        end

        if hitTimer > 0 then
            hitTimer = hitTimer - dt
        end

        if love.keyboard.isDown("left") then
            player1.x = player1.x - player1.speed * dt
        end
        if love.keyboard.isDown("right") then
            player1.x = player1.x + player1.speed * dt
        end
        if love.keyboard.isDown("up") then
            player1.y = player1.y - player1.speed * dt
        end
        if love.keyboard.isDown("down") then
            player1.y = player1.y + player1.speed * dt
        end

        for i, b in ipairs(bullets) do
            b:move(dt)
           
            if checkCollision(b, grape1) then
                grape1.y = -125
                table.remove(bullets, i)
                player1.score = player1.score + 1
                
                chew:play()
            elseif checkCollision(b, grape2) then
                grape2.y = -125
                table.remove(bullets, i)
                player1.score = player1.score + 1

                chew:play()
            elseif checkCollision(b, grape3) then
                grape3.y = -125
                table.remove(bullets, i)
                player1.score = player1.score + 1

                chew:play()
            elseif b.y < -100 then
                table.remove(bullets, i)
            end
        end


        if checkCollision(player1, grape1) then
            grape1.y = -125
            player1.lives = player1.lives - 1

            hitTimer = 0.5
            chirp:play()
        end
        if checkCollision(player1, grape2) then
            grape2.y = -125
            player1.lives = player1.lives - 1

            hitTimer = 0.5
            chirp:play()
        end
        if checkCollision(player1, grape3) then
            grape3.y = -125
            player1.lives = player1.lives - 1

            hitTimer = 0.5
            chirp:play()
        end

        grape1:move(dt)
        grape2:move(dt)
        grape3:move(dt)

        if grape1.y > 600 then
            grape1.y = -125
        end
        if grape2.y > 600 then
            grape2.y = -125 
        end
        if grape3.y > 600 then
            grape3.y = -125
        end
    end
end

function love.draw()
    if gameState == "playing" then 
        love.graphics.draw(background, 0, 0, 0, 1.67, 1.67)
        love.graphics.draw(player1.image, player1.x, player1.y, 0, 1.7, 1.7)

        love.graphics.draw(grape1.image, grape1.x, grape1.y, 0, 1.7, 1.7)
        love.graphics.draw(grape2.image, grape2.x, grape2.y, 0, 1.7, 1.7)
        love.graphics.draw(grape3.image, grape3.x, grape3.y, 0, 1.7, 1.7)

        bulletImage = love.graphics.newImage("orange.png")

        if hitTimer > 0 then
            love.graphics.draw(hitImage, 0, 0, 0, 1.67, 1.67)
        end

        for _, b in ipairs(bullets) do
            love.graphics.draw(b.image, b.x, b.y, 0, 1.7, 1.7)
        end

    elseif gameState == "win" then
        love.graphics.draw(victory, 0, 0, 0, 1.67, 1.67)
    elseif gameState == "lose" then
        love.graphics.draw(gameover, 0, 0, 0, 0.9, 0.9)
    end

end