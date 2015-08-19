local class = require 'lib/middleclass'

local Player = class('Player')
function Player:initialize(name, x, y, state)
    self.x = x
    self.y = y
    self.id = nil
    self.name = name
    self.state = state or 1

    self.winner = false
    self.keys = {}
    self.modifier = nil
    self.combo = {}
end
function Player:setKeys(keys, modifier)
    self.keys = keys
    self.modifier = modifier
    self.combination = self.keys
end
function Player:draw(dt)
    if self.winner then
        love.graphics.setColor(0, 255, 0)
    else
        love.graphics.setColor(0, 255, 255)
    end

    local delta_x = -50
    local delta_y = 50
    love.graphics.polygon(
        'fill',
        self.x, self.y,
        self.x - delta_x, self.y,
        self.x, self.y - delta_y)

    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.name, self.x, self.y + 3)
    love.graphics.print("state: " .. self.state, self.x, self.y + 18)
    local combination = ""
    for k, v in ipairs(self.combination) do
        combination = combination .. v .. " "
    end
    love.graphics.print(combination, self.x, self.y + 33)
end
function Player:isPlayerKey(key)
    if key == self.modifier then
        return true
    end
    for k in pairs(self.keys) do
        if self.keys[k] == key then
            return true
        end
    end
    return false
end
function Player:getNextKey()
    return self.keys[self.state + 1]
end
function Player:keyreleased(key)
    if self:isPlayerKey(key) then
        if key == self.modifier then
            self:shuffleOpponent()
            return
        end
        if key == self:getNextKey() then
            self:changeState(self.state + 1)
        else
            self:changeState(1)
            self:shuffleCombo()
        end
    end
end
function Player:changeState(state)
    if state < 1 then
        state = 1
    end
    self.state = state
    if self.state == #self.combination then
        self.winner = true
    end
end
function Player:update(dt)
end
function Player:shuffleCombo()
    math.randomseed(os.time())
    local iterations = #self.combination
    local j
    for i = iterations, 2, -1 do
        j = math.random(i)
        self.combination[i], self.combination[j] = self.combination[j], self.combination[i]
    end
end
function Player:shuffleOpponent()
    self.GAME:shuffleOpponent(self)
    self:changeState(self.state - 1)
end
return Player
