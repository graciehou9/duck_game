-- alias love="/Users/graciehou/Downloads/love.app/Contents/MacOS/love" ABSOLUTE_PATH_TO_PROJECT_FOLDER

Object = require 'classic'
player = Object:extend()

function player:new(image, x, y, size)
    self.image = image
    self.x = x
    self.y = y
    self.size = size
    self.speed = 275
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
end

function grape:move(dt) 
    -- self.x = self.x + x --x shouldn't change
    self.y = self.y + self.speed*dt
end


function love.load()
    background = love.graphics.newImage("sky.png")
    backgroundMusic = love.audio.newSource("sound.mp3", "stream")
    backgroundMusic:play()
    
    playerImage = love.graphics.newImage("player.png")
    player1 = player(playerImage, 350, 450, 100)

    grapeImage = love.graphics.newImage("grape.png")
    grape1 = grape(grapeImage, 150, 0, 100)
    grape2 = grape(grapeImage, 375, 0, 100)
    grape3 = grape(grapeImage, 600, 0, 100)

end


function love.update(dt)
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

    grape1:move(dt)
    grape2:move(dt)
    grape3:move(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0, 0, 1.67, 1.67)

    love.graphics.draw(player1.image, player1.x, player1.y, 0, 1.7, 1.7)

    love.graphics.draw(grape1.image, grape1.x, grape1.y, 0, 1.7, 1.7)
    love.graphics.draw(grape2.image, grape2.x, grape2.y, 0, 1.7, 1.7)
    love.graphics.draw(grape3.image, grape3.x, grape3.y, 0, 1.7, 1.7)

    -- love.graphics.draw(player1.image, player1.x, player1.y, 0, player1.size / player1.image:getWidth(), player1.size / player1.image:getHeight())

    -- love.graphics.draw(grape1.image, grape1.x, grape1.y, 0, grape1.size / grape1.image:getWidth(), grape1.size / grape1.image:getHeight())
    -- love.graphics.draw(grape2.image, grape2.x, grape2.y, 0, grape2.size / grape2.image:getWidth(), grape2.size / grape2.image:getHeight())
    -- love.graphics.draw(grape3.image, grape3.x, grape3.y, 0, grape3.size / grape3.image:getWidth(), grape3.size / grape3.image:getHeight())

end
