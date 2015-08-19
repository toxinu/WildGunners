local class = require 'lib/middleclass'

local Game = class('Game')
function Game:initialize()
	-- States
	--  1: Menu
	--  2: Playing
	--  3: Score
	self.players = {}
	self.state = 1
	self.ground = 600
end
function Game:addPlayer(player)
	player.id = #self.players
	player.GAME = self
	table.insert(self.players, player)
end
function Game:resetPlayers()
	for _, player in ipairs(self.players) do
		player.winner = false
		player.state = 1
		player:shuffleCombo()
	end
end
function Game:update(dt)
	if self.state == 2 then
		for _, player in ipairs(self.players) do
			player:update(dt)
			if player.winner and self.state == 2 then
				self.state = 3
			end
		end
	end
end
function Game:draw(dt)
	if self.state == 1 then
		Game:drawMenu()
	elseif self.state == 2 then
		love.graphics.setColor(0, 100, 100)
    	love.graphics.rectangle('fill', 0, 100, 480, 600)
	    love.graphics.setColor(0, 255, 255)
	    love.graphics.setLineStyle('rough')
	    love.graphics.line(0, self.ground, 480, self.ground)

		for _, player in ipairs(self.players) do
			player:draw(dt)
		end
	elseif self.state == 3 then
		self:showWinner()
	end
end
function Game:drawMenu()
	love.graphics.print("Press start...")
end
function Game:joystickreleased(joystick, button)
	if self.state == 1 then
		if button == 8 then
			self.state = 2
		end
	elseif self.state == 2 then
		if button == 1 then
			self.players[joystick:getID()]:keyreleased("a")
		elseif button == 2 then
			self.players[joystick:getID()]:keyreleased("b")
		elseif button == 3 then
			self.players[joystick:getID()]:keyreleased("x")
		elseif button == 4 then
			self.players[joystick:getID()]:keyreleased("y")
		elseif button == 5 or button == 6 then
			self.players[joystick:getID()]:shuffleOpponent()
		end
	elseif self.state == 3 then
		if button == 8 then
			self:resetPlayers()
			self.state = 2
		end
	end
end
function Game:keyreleased(key)
	if self.state == 1 then
		for _, player in ipairs(self.players) do
			player:keyreleased(key)
		end
	end
end
function Game:showWinner()
	for _, player in ipairs(self.players) do
		if player.winner then
			love.graphics.setColor(255, 255, 255)
			love.graphics.print(player.name .. " (" .. player.id .. ") is the winner!")
			return
		end
	end
end
function Game:shuffleOpponent(player)
	for _, p in ipairs(self.players) do
		if p ~= player then
			p:shuffleCombo()
		end
	end
end

return Game