require "tank"

function love.load()
	love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0, true)

	objects = {}

	objects.tank1 = Tank
	objects.tank1:setBody(love.physics.newBody(world, 600/2, 600/2, "dynamic"))
	objects.tank1.body:setMass(10)
	objects.tank1:setShape(love.physics.newCircleShape(50))
	objects.tank1:setFixture(love.physics.newFixture(objects.tank1.body, objects.tank1.shape))
	objects.tank1:setControllers("up", "down", "left", "right")

	defaultlinearvelocity = 100

	love.graphics.setBackgroundColor(62, 62, 62) 
  	love.window.setMode(600, 600)
end

function love.keypressed(key, scancode, isrepeat)
	if scancode == 'up' or key == 'up' then
		uparrow = true
	end
	if scancode == 'down' or key == 'down' then
		downarrow = true
	end
	if scancode == 'left' or key == 'left' then
		leftarrow = true
	end
	if scancode == 'right' or key == 'right' then
		rightarrow = true
	end
end

function love.keyreleased(key, scancode)
	if scancode == 'up' or key == 'up' then
		uparrow = false
	end
	if scancode == 'down' or key == 'down' then
		downarrow = false
	end
	if scancode == 'left' or key == 'left' then
		leftarrow = false
	end
	if scancode == 'right' or key == 'right' then
		rightarrow = false
	end
end

function love.update(dt)
	world:update(dt)

	--move(objects.tank1.body, dt, "up", "down", "left", "right")
	objects.tank1:move(dt)
end

function love.draw()
	if objects.tank1.body:isActive() then
		love.graphics.setColor(238, 238, 238)
		love.graphics.circle("fill", objects.tank1.body:getX(), objects.tank1.body:getY(), objects.tank1.shape:getRadius())
	end
end

function move( body, dt, up, down, left, right )
	if love.keyboard.isDown(up) then
		body:setY(objects.tank1.body:getY() - defaultlinearvelocity*dt)
    elseif love.keyboard.isDown(down) then
		body:setY(objects.tank1.body:getY() + defaultlinearvelocity*dt)
    end
	if love.keyboard.isDown(right) then
		body:setX(objects.tank1.body:getX() + defaultlinearvelocity*dt)
    elseif love.keyboard.isDown(left) then
		body:setX(objects.tank1.body:getX() - defaultlinearvelocity*dt)
    end
end