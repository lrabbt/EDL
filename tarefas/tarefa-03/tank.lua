Tank = {
	actualdirection = nil,

	physic = {},

	up = "up",
	down = "down",
	left = "left",
	right = "right"
}

function Tank:setControllers( up, down, left, right )
	self.up = up
	self.down = down
	self.left = left
	self.right = right
end

function Tank:setDirection( actualdirection )
	self.actualdirection = actualdirection
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

function Tank:move( dt )
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

function Tank:update( dt )
	self:move(dt)
end