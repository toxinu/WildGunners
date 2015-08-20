local Game = require 'class/game'
local Player = require 'class/player'

function love.load(arg)
    GAME = Game:new()

    P1 = Player:new("Horseface", 100, 450)
    GAME:addPlayer(P1)

    P2 = Player:new("Cotton Mouth", 500, 450)
    GAME:addPlayer(P2)
end

function love.update(dt)
    GAME:update(dt)
end

function love.draw()
    GAME:draw()
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
    GAME:keyreleased(key)
end

function love.gamepadreleased(joystick, button)
    GAME:gamepadreleased(joystick, button)
end
