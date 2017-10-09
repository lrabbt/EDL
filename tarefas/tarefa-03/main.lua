function love.load()
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)

	mapwidth = 600
	mapheight = 600

	gamepaused = false
	pausebutton = "p"

	tank1 = Tank:new()
	tank1:setId("Player 1")
	tank1:setBody(love.physics.newBody(world, mapwidth/4, mapheight/4, "dynamic"))
	tank1:getBody():setMass(10)
	tank1:getBody():setAngle(0)
	tank1:setShape(love.physics.newCircleShape(20))
	tank1:setFixture(love.physics.newFixture(tank1:getBody(), tank1:getShape()))
	tank1.color = {}
	tank1.color.r = 238
	tank1.color.g = 238
	tank1.color.b = 238
	tank1:setControllers("up", "down", "left", "right", " ")


	tank2 = Tank:new()
	tank2:setId("Player 2")
	tank2:setBody(love.physics.newBody(world, 3 * mapwidth/4, 3 * mapheight/4, "dynamic"))
	tank2:getBody():setMass(10)
	tank2:getBody():setAngle(0)
	tank2:setShape(love.physics.newCircleShape(20))
	tank2:setFixture(love.physics.newFixture(tank2:getBody(), tank2:getShape()))
	tank2.color = {}
	tank2.color.r = 100
	tank2.color.g = 100
	tank2.color.b = 68
	tank2:setControllers("w", "s", "a", "d", "f")

	bullets = {}

	defaultlinearvelocity = 150
	defaultshootvelocity = 250

	love.graphics.setBackgroundColor(62, 62, 62) 
  	love.window.setMode(mapwidth, mapheight)
end

function love.keypressed( key, scancode, isrepeat )
	if not gameended then
		if key == pausebutton or scancode == pausebutton then
			gamepaused = not gamepaused
		end
	end
end

function love.update(dt)
	if tank1:getPontuacao() <= 0 and tank2:getPontuacao() <= 0 then
		endgamemessage = "Empate"
		tank1.color = {r = 255, g = 0, b = 0}
		tank2.color = {r = 255, g = 0, b = 0}
		gameended = true
	elseif tank1:getPontuacao() <= 0 then
		endgamemessage = tank2:getId() .. " venceu."
		tank1.color = {r = 255, g = 0, b = 0}
		gameended = true
	elseif tank2:getPontuacao() <= 0 then
		endgamemessage = tank1:getId() .. " venceu."
		tank2.color = {r = 255, g = 0, b = 0}
		gameended = true
	end

	if not gamepaused and not gameended then
		world:update(dt)

		tank1:update(dt)
		tank2:update(dt)

		if tank1:isShooting() then
			
			table.insert(bullets, tank1:shoot())
		end

		if tank2:isShooting() then
			
			table.insert(bullets, tank2:shoot())
		end

		for i,v in ipairs(bullets) do
			v.x = v.x + (v.dx * dt)
			v.y = v.y + (v.dy * dt)
		end
	end
end

function love.draw()
	if tank1:getBody():isActive() then
		love.graphics.setColor(tank1.color.r, tank1.color.g, tank1.color.b)
		
		love.graphics.circle("fill", tank1.body:getX(), tank1.body:getY(), tank1.shape:getRadius())

	end

	if tank2:getBody():isActive() then
		love.graphics.setColor(tank2.color.r, tank2.color.g, tank2.color.b)
		
		love.graphics.circle("fill", tank2.body:getX(), tank2.body:getY(), tank2.shape:getRadius())
	end

	love.graphics.setColor(240, 0, 0)
	for i,v in ipairs(bullets) do
		if v.active == true then
			love.graphics.circle("fill", v.x, v.y, 3)
		end
	end

	love.graphics.print(tank1:getId(), 0, 0)
	love.graphics.print(tank1:getPontuacao(), 0, 15)
	love.graphics.print(tank2:getId(), mapwidth - 50, 0)
	love.graphics.print(tank2:getPontuacao(), mapwidth - 50, 15)

	if gamepaused then
		love.graphics.print("Game Paused", mapwidth/2 - 50, mapheight/2 - 15)
	end

	if gameended then
		love.graphics.print(endgamemessage, mapwidth/2 - 50, mapheight/2 - 15)
	end
end

function distance( x1, y1, x2, y2)
	return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

--Classes

Tank = {
	id = nil,
	pontuacao = 100,

	actualdirection = "up",
	shooting = false,
	lastShotTime = 0,

	body = nil,
	shape = nil,
	fixture = nil,

	sprite = nil,

	up = "up",
	down = "down",
	left = "left",
	right = "right",
	space = " "
}

function Tank:new( tank )
	local tank = tank or {}
	setmetatable(tank, self)
	self.__index = self
	return tank
end

function Tank:getId()
	return self.id
end

function Tank:setId( id )
	self.id = id
end

function Tank:getPontuacao()
	return self.pontuacao
end

function Tank:setPontuacao( pontuacao )
	self.pontuacao = pontuacao
end

function Tank:getBody()
	return self.body
end

function Tank:setBody( body )
	self.body = body
end

function Tank:getShape()
	return self.shape
end

function Tank:setShape( shape )
	self.shape = shape
end

function Tank:getFixture()
	return self.fixture
end

function Tank:setFixture( fixture )
	self.fixture = fixture
end

function Tank:setControllers( up, down, left, right, space )
	self.up = up
	self.down = down
	self.left = left
	self.right = right
	self.space = space
end

function Tank:getDirection( actualdirection )
	return self.actualdirection
end

function Tank:setDirection( actualdirection )
	self.actualdirection = actualdirection
end

function Tank:setShooting( shooting )
	self.shooting = shooting
end

function Tank:isShooting()
	return self.shooting
end

function Tank:setSprite( sprite )
	self.sprite = sprite
end

function Tank:addPontuacao( valor )
	self.pontuacao = self.pontuacao + (valor or 1)
end

function Tank:subPontuacao( valor )
	self.pontuacao = self.pontuacao - (valor or 1)
end

function Tank:readMovement( dt )
	if self.up == nil or self.down == nil or self.left == nil or self.right == nil then return end

	uppressed = false
	downpressed = false
	leftpressed = false
	rightpressed = false
	
	prevx = self.body:getX()
	prevy = self.body:getY()

	if love.keyboard.isDown(self.up) then
		uppressed = true
		self.body:setY(self.body:getY() - defaultlinearvelocity*dt)
    elseif love.keyboard.isDown(self.down) then
		downpressed = true
		self.body:setY(self.body:getY() + defaultlinearvelocity*dt)
    end

    if self.body:getY() > mapheight - self.shape:getRadius() or self.body:getY() < 0 + self.shape:getRadius() then
    	self.body:setY(prevy)
    end

	if love.keyboard.isDown(self.right) then
		rightpressed = true
		self.body:setX(self.body:getX() + defaultlinearvelocity*dt)
    elseif love.keyboard.isDown(self.left) then
		leftpressed = true
		self.body:setX(self.body:getX() - defaultlinearvelocity*dt)
    end

    if self.body:getX() > mapwidth - self.shape:getRadius() or self.body:getX() < 0 + self.shape:getRadius() then
    	self.body:setX(prevx)
    end

    if uppressed == true then
    	self.actualdirection = "up"
    	self.body:setAngle(math.rad(0))
    	if leftpressed == true then
    		self.actualdirection = "upleft"
    		self.body:setAngle(math.rad(-45))
    	elseif rightpressed == true then
    		self.actualdirection = "upright"
    		self.body:setAngle(math.rad(45))
    	end
    elseif downpressed == true then
    	self.actualdirection = "down"
    	self.body:setAngle(math.rad(180))
    	if leftpressed == true then
    		self.actualdirection = "downleft"
    		self.body:setAngle(math.rad(-135))
    	elseif rightpressed == true then
    		self.actualdirection = "downright"
    		self.body:setAngle(math.rad(135))
    	end
    elseif rightpressed == true then
    	self.actualdirection = "right"
    	self.body:setAngle(math.rad(90))
    elseif leftpressed == true then
    	self.actualdirection = "left"
    	self.body:setAngle(math.rad(-90))
    end
end

function Tank:shoot()
	local bulletposition = {}
	local tankdirection = self:getDirection()

	if tankdirection == "up" then
		bulletposition.x = 0
		bulletposition.y = - self.shape:getRadius()

		bulletposition.dx = 0
		bulletposition.dy = - defaultshootvelocity
	elseif tankdirection == "down" then
		bulletposition.x = 0
		bulletposition.y = self.shape:getRadius()

		bulletposition.dx = 0
		bulletposition.dy = defaultshootvelocity
	elseif tankdirection == "left" then
		bulletposition.x = - self.shape:getRadius()
		bulletposition.y = 0

		bulletposition.dx = - defaultshootvelocity
		bulletposition.dy = 0
	elseif tankdirection == "right" then
		bulletposition.x = self.shape:getRadius()
		bulletposition.y = 0

		bulletposition.dx = defaultshootvelocity
		bulletposition.dy = 0
	elseif tankdirection == "upleft" then
		bulletposition.x = - self.shape:getRadius()
		bulletposition.y = - self.shape:getRadius()

		bulletposition.dx = - defaultshootvelocity
		bulletposition.dy = - defaultshootvelocity
	elseif tankdirection == "upright" then
		bulletposition.x = self.shape:getRadius()
		bulletposition.y = - self.shape:getRadius()

		bulletposition.dx = defaultshootvelocity
		bulletposition.dy = - defaultshootvelocity
	elseif tankdirection == "downleft" then
		bulletposition.x = - self.shape:getRadius()
		bulletposition.y = self.shape:getRadius()

		bulletposition.dx = - defaultshootvelocity
		bulletposition.dy = defaultshootvelocity
	elseif tankdirection == "downright" then
		bulletposition.x = self.shape:getRadius()
		bulletposition.y = self.shape:getRadius()

		bulletposition.dx = defaultshootvelocity
		bulletposition.dy = defaultshootvelocity
	end

	local startX = self.body:getX() + bulletposition.x
	local startY = self.body:getY() + bulletposition.y

	local bulletDx = bulletposition.dx
	local bulletDy = bulletposition.dy

	self.shooting = false

	return {x = startX, y = startY, dx = bulletDx, dy = bulletDy, active = true}
end

function Tank:readShootingState()
	if love.keyboard.isDown(self.space) and love.timer.getTime() - self.lastShotTime > 0.5 then
		self.shooting = true
		self.lastShotTime = love.timer.getTime()
    end
end

function Tank:checkCollision()
	self:checkBulletCollision()
	self:checkTankCollision()
end

function Tank:checkBulletCollision()
	for i, v in ipairs(bullets) do
		if distance(v.x, v.y, self.body:getX(), self.body:getY()) < self.shape:getRadius() and v.active == true then
			v.active = false
			self:subPontuacao(20)
		end
	end
end

function Tank:checkTankCollision()
	if self == tank1 then
		if distance(self.body:getX(), self.body:getY(), tank2.body:getX(), tank2.body:getY()) < self.shape:getRadius() + tank2.shape:getRadius() then
			self:subPontuacao()
		end
	elseif self == tank2 then
		if distance(self.body:getX(), self.body:getY(), tank1.body:getX(), tank1.body:getY()) < self.shape:getRadius() + tank1.shape:getRadius() then
			self:subPontuacao()
		end
	end
end

function Tank:update( dt )
	self:readMovement(dt)
	self:readShootingState()
	self:checkCollision()
end