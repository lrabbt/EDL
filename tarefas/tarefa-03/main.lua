function love.load()
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)

	objects = {}

	objects.tank1 = Tank
	objects.tank1.physic.body = love.physics.newBody(world, 600/2, 600/2, "dynamic")
	objects.tank1.physic.body:setMass(10)
	objects.tank1.physic.shape = love.physics.newCircleShape(50)
	objects.tank1.physic.fixture = love.physics.newFixture(objects.tank1.physic.body, objects.tank1.physic.shape)
	objects.tank1:setControllers("up", "down", "left", "right", "space")

	defaultlinearvelocity = 100

	love.graphics.setBackgroundColor(62, 62, 62) 
  	love.window.setMode(600, 600)
end

function love.keypressed(key, scancode, isrepeat)
	
end

function love.keyreleased(key, scancode)
	
end

function love.update(dt)
	world:update(dt)

	--move(objects.tank1.body, dt, "up", "down", "left", "right")
	objects.tank1:update(dt)
end

function love.draw()
	if objects.tank1.physic.body:isActive() then
		love.graphics.setColor(238, 238, 238)
		love.graphics.circle("fill", objects.tank1.physic.body:getX(), objects.tank1.physic.body:getY(), objects.tank1.physic.shape:getRadius())
	end
end

Tank = {
	actualdirection = "up",
	shooting = false,
	lastShotTime = nil,

	physic = {},

	up = "up",
	down = "down",
	left = "left",
	right = "right",
	space = "space"
}

function Tank:setControllers( up, down, left, right, space )
	self.up = up
	self.down = down
	self.left = left
	self.right = right
	self.space = space
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

--function Tank:setBody( body )
--	self.body = body
--end
--
--function Tank:setShape( shape )
--	self.shape = shape
--end
--
--function Tank:setFixture( fixture )
--	self.fixture = fixture
--end

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
    	if leftpressed == true then
    		self.actualdirection = "upleft"
    	elseif rightpressed == true then
    		self.actualdirection = "upright"
    	end
    elseif downpressed == true then
    	self.actualdirection = "down"
    	if leftpressed == true then
    		self.actualdirection = "downleft"
    	elseif rightpressed == true then
    		self.actualdirection = "downright"
    	end
    elseif rightpressed == true then
    	self.actualdirection = "right"
    elseif leftpressed == true then
    	self.actualdirection = "left"
    end
end

function Tank:readShootingState()
	if love.keyboard.isDown(self.space) and love.timer.getTime() - self.lastShotTime > 1 then
		shooting = true
    end
end

function Tank:update( dt )
	self:readMovement(dt)
	self:readShootingState()
end