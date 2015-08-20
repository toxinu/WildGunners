local class = require 'lib/middleclass'

local Game = class('Game')
function Game:initialize()
	-- States
	--  1: Menu
	--  2: Playing
	--  3: Score
	self.players = {}
	self.state = 2
	self.ground = 450
end
function Game:addPlayer(player)
	player.id = #self.players
	player.GAME = self
	table.insert(self.players, player)
end
function Game:resetPlayers()
	for _, player in ipairs(self.players) do
		player.winner = false
		player.state = {1, 1}
		player:shuffleCombination()
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
function Game:draw()
	if self.state == 1 then
		Game:drawMenu()
	elseif self.state == 2 then
		love.graphics.setColor(0, 100, 100)
    	love.graphics.rectangle(
    		'fill', 0, 100,
    		love.graphics.getWidth(), love.graphics.getHeight())
	    love.graphics.setColor(0, 255, 255)
	    love.graphics.setLineStyle('rough')
	    love.graphics.line(0, self.ground, love.graphics.getWidth(), self.ground)

		for _, player in ipairs(self.players) do
			player:draw()
		end
	elseif self.state == 3 then
		self:showWinner()
	end
end
function Game:drawMenu()
	love.graphics.print("Press start...")
end
function Game:gamepadreleased(joystick, button)
	-- print(button)
	if self.state == 1 then
		if button == "start" then
			self.state = 2
		end
	elseif self.state == 2 then
		if button == "rightshoulder" or button == "leftshoulder" then
			self.players[joystick:getID()]:keyreleased("shoulder")
		else
			self.players[joystick:getID()]:keyreleased(button)
		end
	elseif self.state == 3 then
		if button == "start" then
			self:resetPlayers()
			self.state = 2
		end
	end
end
function Game:keyreleased(key)
	if self.state == 1 then
		if button == "start" then
			self.state = 2
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
function Game:shuffleOpponent(playerID)
	for _, p in ipairs(self.players) do
		if p.id ~= playerID then
			p:shuffleCombination("current")
		end
	end
end

return Game