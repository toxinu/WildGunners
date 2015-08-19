local Game = require 'game'
local Player = require 'player'

function love.load(arg)
    GAME = Game:new()

    P1 = Player:new("Horseface", 100, 600)
    P1:setKeys({"a", "b", "x", "y"}, "lctrl")
    P1:shuffleCombo()
    GAME:addPlayer(P1)

    P2 = Player:new("Cotton Mouth", 330, 600)
    P2:setKeys({"a", "b", "x", "y"}, "lctrl")
    P2:shuffleCombo()
    GAME:addPlayer(P2)
end

function love.update(dt)
    GAME:update(dt)
end

function love.draw(dt)
    GAME:draw(dt)
end

function love.keyreleased(key)
    if key == "escape" then
        love.event.quit()
    end
    GAME:keyreleased(key)
end

function love.joystickreleased(joystick, button)
    GAME:joystickreleased(joystick, button)
end
