local class = require 'lib/middleclass'
local resources = require 'class/resources'

local Player = class('Player')
function Player:initialize(name, x, y)
    self.x = x
    self.y = y
    self.id = nil
    self.name = name
    self.state = {1, 1}

    self.winner = false
    self.keys = {"a", "b", "x", "y", "dpup", "dpdown", "dpright", "dpleft"}
    self.modifier = "shoulder"
    self.combination_structure = {4, 7, 5}
    self.combinations = {}

    self:shuffleCombination()
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

    love.graphics.setColor(255, 255, 255, 255)
    for k, v in pairs(self.combinations) do
        local line = ""
        if k <= self.state[1] then
            for kk, vv in pairs(self.combinations[k]) do
                local x = self.x - 40 + kk * 37
                local y = self.y - 15 + k * 37
                love.graphics.draw(resources.BUTTONS[vv], x, y)
            end
        else
            line = "..."
        end
    end

        --[[
    for k, v in ipairs(self.combinations[self.state]) do
        if v == "y" then
            love.graphics.setColor(255, 208, 0)
        elseif v == "b" then
            love.graphics.setColor(235, 5, 5)
        elseif v == "a" then
            love.graphics.setColor(67, 196, 63)
        elseif v == "x" then
            love.graphics.setColor(48, 42, 242)
        end
        love.graphics.circle("fill", self.x + (k - 1) * 23, self.y + 43, 10);
        v = string.upper(v)
        love.graphics.print(v, self.x + ((k - 1) * 23) - 4, self.y + 36)

        if k == self.state then
            love.graphics.circle("fill", self.x + (k - 1) * 23, self.y + 58, 2)
        end
    end
        ]]--
end
function Player:getNextKey()
    return self.combinations[self.state[1]][self.state[2]]
end
function Player:keyreleased(key)
    if key == self.modifier then
        self:shuffleOpponent()
    elseif key == self:getNextKey() then
        self:changeState(1)
    else
        self:changeState("soft")
        self:shuffleCombination("current")
    end
end
function Player:changeState(state)
    if state == "hard" then
        self.state = {1, 1}
    elseif state == "soft" then
        self.state = {self.state[1], 1}
    elseif state == 1 then
        -- If state[2] + 1 is the latest, let's go to next state
        if self.state[2] + 1 > #self.combinations[self.state[1]] then
            -- If state[1] + 1 is the latest, there is winner
            if self.state[1] + 1 > #self.combinations then
                self.winner = true
            else
                self.state = {self.state[1] + 1, 1}
            end
        else
            self.state[2] = self.state[2] + 1
        end
    end
end
function Player:update(dt)
end
function Player:shuffleCombination(kind)
    kind = kind or "all"
    if kind == "all" then
        for k=1,#self.combination_structure do
            self.combinations[k] = {}
            for kk=1,self.combination_structure[k] do
                table.insert(self.combinations[k], self.keys[math.random(1, #self.keys)])
            end
        end
    elseif kind == "current" then
        self.combinations[self.state[1]] = {}
        for kk=1,self.combination_structure[self.state[1]] do
            table.insert(
                self.combinations[self.state[1]],
                self.keys[math.random(1, #self.keys)])
        end
    end
    --[[
    for key=1,self.combination_number do
        local iterations = #self.combinations[key]
        local j
        for i = iterations, 2, -1 do
            j = math.random(i)
            self.combination[i], self.combination[j] = self.combination[j], self.combination[i]
        end
    end
    --]]
end
function Player:shuffleOpponent()
    self.GAME:shuffleOpponent(self.id)
end
return Player
