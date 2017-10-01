require "tank"

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
