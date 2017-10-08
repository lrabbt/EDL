function love.load()
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)

	tanks = {}

	tanks.tank1 = Tank
	tanks.tank1.physic.body = love.physics.newBody(world, 600/4, 600/4, "dynamic")
	tanks.tank1.physic.body:setMass(10)
	tanks.tank1.physic.body:setAngle(0)
	tanks.tank1.physic.shape = love.physics.newCircleShape(20)
	tanks.tank1.physic.fixture = love.physics.newFixture(tanks.tank1.physic.body, tanks.tank1.physic.shape)
	tanks.tank1:setSprite(love.graphics.newImage("sprites/tank.png"));
	tanks.tank1:setControllers("up", "down", "left", "right", " ")

	bullets = {}

	defaultlinearvelocity = 150
	defaultshootvelocity = 250

	love.graphics.setBackgroundColor(62, 62, 62) 
  	love.window.setMode(600, 600)
end

function love.keypressed(key, scancode, isrepeat)
	
end

function love.keyreleased(key, scancode)
	
end

function love.update(dt)
	world:update(dt)

	--move(tanks.tank1.body, dt, "up", "down", "left", "right")
	tanks.tank1:update(dt)

	if tanks.tank1:isShooting() then
		
		table.insert(bullets, tanks.tank1:shoot())

		tanks.tank1:setShooting(false)
	end

	for i,v in ipairs(bullets) do
		v.x = v.x + (v.dx * dt)
		v.y = v.y + (v.dy * dt)
	end
end

function love.draw()
	if tanks.tank1.physic.body:isActive() then
		love.graphics.setColor(238, 238, 238)
		
		--if tanks.tank1.sprite ~= nil then
			--TODO: corrigir
		--	love.graphics.draw(tanks.tank1.sprite, tanks.tank1.physic.body:getX() - tanks.tank1.physic.shape:getRadius(), tanks.tank1.physic.body:getY() - tanks.tank1.physic.shape:getRadius(), tanks.tank1.physic.body:getAngle())
		-- else
			love.graphics.circle("fill", tanks.tank1.physic.body:getX(), tanks.tank1.physic.body:getY(), tanks.tank1.physic.shape:getRadius())
		-- end

	end

	love.graphics.setColor(240, 0, 0)
	for i,v in ipairs(bullets) do
		love.graphics.circle("fill", v.x, v.y, 3)
	end
end

--Classes

Tank = {
	actualdirection = "up",
	shooting = false,
	lastShotTime = 0,

	physic = {},
	sprite = nil,

	up = "up",
	down = "down",
	left = "left",
	right = "right",
	space = " "
}

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

function Tank:readMovement( dt )
	if self.up == nil or self.down == nil or self.left == nil or self.right == nil then return end
	uppressed = false
	downpressed = false
	leftpressed = false
	rightpressed = false
	if love.keyboard.isDown(self.up) then
		uppressed = true
		self.physic.body:setY(self.physic.body:getY() - defaultlinearvelocity*dt)
    elseif love.keyboard.isDown(self.down) then
		downpressed = true
		self.physic.body:setY(self.physic.body:getY() + defaultlinearvelocity*dt)
    end
	if love.keyboard.isDown(self.right) then
		rightpressed = true
		self.physic.body:setX(self.physic.body:getX() + defaultlinearvelocity*dt)
    elseif love.keyboard.isDown(self.left) then
		leftpressed = true
		self.physic.body:setX(self.physic.body:getX() - defaultlinearvelocity*dt)
    end

    if uppressed == true then
    	self.actualdirection = "up"
    	self.physic.body:setAngle(math.rad(0))
    	if leftpressed == true then
    		self.actualdirection = "upleft"
    		self.physic.body:setAngle(math.rad(-45))
    	elseif rightpressed == true then
    		self.actualdirection = "upright"
    		self.physic.body:setAngle(math.rad(45))
    	end
    elseif downpressed == true then
    	self.actualdirection = "down"
    	self.physic.body:setAngle(math.rad(180))
    	if leftpressed == true then
    		self.actualdirection = "downleft"
    		self.physic.body:setAngle(math.rad(-135))
    	elseif rightpressed == true then
    		self.actualdirection = "downright"
    		self.physic.body:setAngle(math.rad(135))
    	end
    elseif rightpressed == true then
    	self.actualdirection = "right"
    	self.physic.body:setAngle(math.rad(90))
    elseif leftpressed == true then
    	self.actualdirection = "left"
    	self.physic.body:setAngle(math.rad(-90))
    end
end

function Tank:shoot()
	local bulletposition = {}
	local tankdirection = self:getDirection()

	if tankdirection == "up" then
		bulletposition.x = 0
		bulletposition.y = - self.physic.shape:getRadius()

		bulletposition.dx = 0
		bulletposition.dy = - defaultshootvelocity
	elseif tankdirection == "down" then
		bulletposition.x = 0
		bulletposition.y = self.physic.shape:getRadius()

		bulletposition.dx = 0
		bulletposition.dy = defaultshootvelocity
	elseif tankdirection == "left" then
		bulletposition.x = - self.physic.shape:getRadius()
		bulletposition.y = 0

		bulletposition.dx = - defaultshootvelocity
		bulletposition.dy = 0
	elseif tankdirection == "right" then
		bulletposition.x = self.physic.shape:getRadius()
		bulletposition.y = 0

		bulletposition.dx = defaultshootvelocity
		bulletposition.dy = 0
	elseif tankdirection == "upleft" then
		bulletposition.x = - self.physic.shape:getRadius()
		bulletposition.y = - self.physic.shape:getRadius()

		bulletposition.dx = - defaultshootvelocity
		bulletposition.dy = - defaultshootvelocity
	elseif tankdirection == "upright" then
		bulletposition.x = self.physic.shape:getRadius()
		bulletposition.y = - self.physic.shape:getRadius()

		bulletposition.dx = defaultshootvelocity
		bulletposition.dy = - defaultshootvelocity
	elseif tankdirection == "downleft" then
		bulletposition.x = - self.physic.shape:getRadius()
		bulletposition.y = self.physic.shape:getRadius()

		bulletposition.dx = - defaultshootvelocity
		bulletposition.dy = defaultshootvelocity
	elseif tankdirection == "downright" then
		bulletposition.x = self.physic.shape:getRadius()
		bulletposition.y = self.physic.shape:getRadius()

		bulletposition.dx = defaultshootvelocity
		bulletposition.dy = defaultshootvelocity
	end

	local startX = self.physic.body:getX() + bulletposition.x
	local startY = self.physic.body:getY() + bulletposition.y

	local bulletDx = bulletposition.dx
	local bulletDy = bulletposition.dy

	return {x = startX, y = startY, dx = bulletDx, dy = bulletDy}
end

function Tank:readShootingState()
	if love.keyboard.isDown(self.space) and love.timer.getTime() - self.lastShotTime > 1 then
		self.shooting = true
		self.lastShotTime = love.timer.getTime()
    end
end

function Tank:update( dt )
	self:readMovement(dt)
	self:readShootingState()
end