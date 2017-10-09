function love.load()
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)

	tank1 = Tank:new()
	tank1:setId("Player 1")
	tank1:setBody(love.physics.newBody(world, 600/4, 600/4, "dynamic"))
	tank1:getBody():setMass(10)
	tank1:getBody():setAngle(0)
	tank1:setShape(love.physics.newCircleShape(20))
	tank1:setFixture(love.physics.newFixture(tank1:getBody(), tank1.shape))
	tank1:setSprite(love.graphics.newImage("sprites/tank.png"));
	tank1.color = {}
	tank1.color.r = 238
	tank1.color.g = 238
	tank1.color.b = 238
	tank1:setControllers("up", "down", "left", "right", " ")


	tank2 = Tank:new()
	tank2:setId("Player 2")
	tank2:setBody(love.physics.newBody(world, 3 * 600/4, 3 * 600/4, "dynamic"))
	tank2:getBody():setMass(10)
	tank2:getBody():setAngle(0)
	tank2:setShape(love.physics.newCircleShape(20))
	tank2:setFixture(love.physics.newFixture(tank2:getBody(), tank2.shape))
	tank2:setSprite(love.graphics.newImage("sprites/tank.png"));
	tank2.color = {}
	tank2.color.r = 100
	tank2.color.g = 100
	tank2.color.b = 68
	tank2:setControllers("w", "s", "a", "d", "f")

	bullets = {}

	defaultlinearvelocity = 150
	defaultshootvelocity = 250

	love.graphics.setBackgroundColor(62, 62, 62) 
  	love.window.setMode(600, 600)
end

function love.update(dt)
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

function love.draw()
	if tank1:getBody():isActive() then
		love.graphics.setColor(tank1.color.r, tank1.color.g, tank1.color.b)
		
		--if tank1.sprite ~= nil then
			--TODO: corrigir
		--	love.graphics.draw(tank1.sprite, tank1.body:getX() - tank1.shape:getRadius(), tank1.body:getY() - tank1.shape:getRadius(), tank1.body:getAngle())
		-- else
		love.graphics.circle("fill", tank1.body:getX(), tank1.body:getY(), tank1.shape:getRadius())
		-- end

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
	love.graphics.print(tank2:getId(), 600 - 50, 0)
	love.graphics.print(tank2:getPontuacao(), 600 - 50, 15)
end

--Classes

Tank = {
	id = nil,
	pontuacao = 3,

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

function Tank:addPontuacao()
	self.pontuacao = self.pontuacao + 1
end

function Tank:subPontuacao()
	self.pontuacao = self.pontuacao - 1
end

function Tank:readMovement( dt )
	if self.up == nil or self.down == nil or self.left == nil or self.right == nil then return end
	uppressed = false
	downpressed = false
	leftpressed = false
	rightpressed = false
	if love.keyboard.isDown(self.up) then
		uppressed = true
		self.body:setY(self.body:getY() - defaultlinearvelocity*dt)
    elseif love.keyboard.isDown(self.down) then
		downpressed = true
		self.body:setY(self.body:getY() + defaultlinearvelocity*dt)
    end
	if love.keyboard.isDown(self.right) then
		rightpressed = true
		self.body:setX(self.body:getX() + defaultlinearvelocity*dt)
    elseif love.keyboard.isDown(self.left) then
		leftpressed = true
		self.body:setX(self.body:getX() - defaultlinearvelocity*dt)
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

function Tank:checkBulletCollision()
	for i, v in ipairs(bullets) do
		if math.sqrt((v.x - self.body:getX())^2 + (v.y - self.body:getY())^2) < self.shape:getRadius() and v.active == true then
			self:subPontuacao()
			v.active = false
		end
	end
end

function Tank:update( dt )
	self:readMovement(dt)
	self:readShootingState()
	self:checkBulletCollision()
end