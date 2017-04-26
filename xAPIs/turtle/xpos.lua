-- Copyright (C) 2017, GReaperEx(Marios F.)

--[[ Determines what happens when the turtle's path is obstructed.
     1 == Wait until you can move
     2 == Try to break the block that's blocking you
     3 == Try to attack the entity that's blocking you
     4 == Try to both break block and attack entity ]]
local movePolicy = 1

function getMovePolicy()
	return movePolicy
end

function getMovePolicyS()
	local names = { "wait", "break", "attack", "both" }
	return names[movePolicy]
end

--[[ Possible values for 'p': numerical and strings
     1 or "wait"
     2 or "break"
     3 or "attack"
     4 or "both"   ]]
function setMovePolicy(p)
	if p == 1 or p == "wait" then
		movePolicy = 1
	elseif p == 2 or p == "break" then
		movePolicy = 2
	elseif p == 3 or p == "attack" then
		movePolicy = 3
	elseif p == 4 or p == "both" then
		movePolicy = 4
	end
end

--[[ Saves the current direction towards which the turtle is facing.
     1 == north
     2 == west
     3 == south
     4 == east  ]]
local direction = 1

function getDirection()
	return direction
end

function getDirectionS()
	local names = { "north", "west", "south", "east" }
	return names[direction]
end

--[[ Possible values for 'd': numerical and strings
     1 or "north"
     2 or "west"
     3 or "south"
     4 or "east"  ]]
function setDirection(d)
	if d == 1 or d == "north" then
		direction = 1
	elseif d == 2 or d == "west" then
		direction = 2
	elseif d == 3 or d == "south" then
		direction = 3
	elseif d == 4 or d == "east" then
		direction = 4
	end
end

-- Save the turtle's current position
local posX = 0
local posY = 0
local posZ = 0

function getPosition()
	return posX, posY, posZ
end

function getPosX()
	return posX
end

function getPosY()
	return posY
end

function getPosZ()
	return posZ
end

-- Any of these parameters can be nil so as to be ignored
function setPosition(x, y, z)
	if x ~= nil then
		posX = x
	end
	if y ~= nil then
		posY = y
	end
	if z ~= nil then
		posZ = z
	end
end

-- Warning: It'll burn anything it can find!
local function searchForFuel()
	local oldSlot = turtle.getSelectedSlot()
	for i=16,1,-1 do
		turtle.select(i)
		if turtle.refuel(1) then
			turtle.select(oldSlot)
			return true
		end
	end
	turtle.select(oldSlot)
	return false
end

-- Asks for fuel from the main server
local function onOutOfFuel()
	print("Out of fuel. Standing by...")

	local ack = false
	while not searchForFuel() do
		if not ack then
			local id = rednet.lookup("CtrlServer")
			if id ~= nil then
				local toSend = {}
		--[[ This should be modified for correct placement ]]
				toSend.x = posX
				toSend.y = posY
				toSend.z = posZ + 1
				toSend.dir = 1

				rednet.send(id, textutils.serialize(toSend), "out-of-fuel")
				local id, answer = rednet.receive("out-of-fuel", 10)
				if answer == "ACK" then
					ack = true
				end
			end
		end
		os.sleep(5)
	end
end

local function checkForFuel()
	if turtle.getFuelLevel() == 0 then
		if not searchForFuel() then
			onOutOfFuel()
		end
		return true
	end
	return false
end

--[[+++++ All movement functions start here +++++]]

function forward()
	while not turtle.forward() do
		if not checkForFuel() then
			if movePolicy == 1 then
				os.sleep(2)
			elseif movePolicy == 2 then
				turtle.dig()
			elseif movePolicy == 3 then
				turtle.attack()
				os.sleep(1)
			elseif movePolicy == 4 then
				turtle.dig()
				turtle.attack()
			end
		end
	end

	if direction == 1 then
		posZ = posZ - 1
	elseif direction == 2 then
		posX = posX - 1
	elseif direction == 3 then
		posZ = posZ + 1
	elseif direction == 4 then
		posX = posX + 1
	end
end

function back()
	while not turtle.back() do
		if not checkForFuel() then
			if movePolicy == 1 then
				os.sleep(2)
			elseif movePolicy == 2 then
				turtle.turnLeft()
				turtle.turnLeft()
				turtle.dig()
				turtle.turnLeft()
				turtle.turnLeft()
			elseif movePolicy == 3 then
				turtle.turnLeft()
				turtle.turnLeft()
				turtle.attack()
				turtle.turnLeft()
				turtle.turnLeft()
			elseif movePolicy == 4 then
				turtle.turnLeft()
				turtle.turnLeft()
				turtle.dig()
				turtle.attack()
				turtle.turnLeft()
				turtle.turnLeft()
			end
		end
	end

	if direction == 1 then
		posZ = posZ + 1
	elseif direction == 2 then
		posX = posX + 1
	elseif direction == 3 then
		posZ = posZ - 1
	elseif direction == 4 then
		posX = posX - 1
	end
end

function up()
	while not turtle.up() do
		if not checkForFuel() then
			if movePolicy == 1 then
				os.sleep(2)
			elseif movePolicy == 2 then
				turtle.digUp()
			elseif movePolicy == 3 then
				turtle.attackUp()
				os.sleep(1)
			elseif movePolicy == 4 then
				turtle.digUp()
				turtle.attackUp()
			end
		end
	end

	posY = posY + 1
end

function down()
	while not turtle.down() do
		if not checkForFuel() then
			if movePolicy == 1 then
				os.sleep(2)
			elseif movePolicy == 2 then
				turtle.digDown()
			elseif movePolicy == 3 then
				turtle.attackDown()
				os.sleep(1)
			elseif movePolicy == 4 then
				turtle.digDown()
				turtle.attackDown()
			end
		end
	end

	posY = posY - 1
end

function turnLeft()
	turtle.turnLeft()
	direction = math.fmod(direction, 4) + 1
end

function turnRight()
	turtle.turnRight()
	direction = math.fmod(direction+2, 4) + 1
end

-- Absolute turn, integers 1-4 or strings "north", "west", "south" and "east"
function turnAbs(t)
	if t == "north" then
		t = 1
	elseif t == "west" then
		t = 2
	elseif t == "south" then
		t = 3
	elseif t == "east" then
		t = 4
	else
		t = math.fmod(t-1, 4) + 1
	end

	while direction ~= t do
		local dist = direction - t
		if dist < 0 then
			if dist == -3 then
				turnRight()
			else
				turnLeft()
			end
		else
			if dist == 3 then
				turnLeft()
			else
				turnRight()
			end
		end
	end
end

local function moveX(newX)
	if newX > posX then
		turnAbs(4)
		while newX ~= posX do
			forward()
		end
	elseif newX < posX then
		turnAbs(2)
		while newX ~= posX do
			forward()
		end
	end
end

local function moveY(newY)
	if newY > posY then
		while newY ~= posY do
			up()
		end
	elseif newY < posY then
		while newY ~= posY do
			down()
		end
	end
end

local function moveZ(newZ)
	if newZ > posZ then
		turnAbs(3)
		while newZ ~= posZ do
			forward()
		end
	elseif newZ < posZ then
		turnAbs(1)
		while newZ ~= posZ do
			forward()
		end
	end
end

--[[ Relative move, any parameter can be nil so as to be ignored.
     'order' should be a 3-element array that indicates in which order the
     movement should happen. 1 for X, 2 for Y and 3 for Z. ]]
function move(x, y, z, order)
	if order == nil then
		order = { 2, 1, 3 }
	end

	for i=1,3 do
		if order[i] == 1 and x ~= nil then
			moveX(posX + x)
		elseif order[i] == 2 and y ~= nil then
			moveY(posY + y)
		elseif order[i] == 3 and z ~= nil then
			moveZ(posZ + z)
		end
	end
end


--[[ Absolute move, any parameter can be nil so as to be ignored.
     'order' should be a 3-element array that indicates in which order the
     movement should happen. 1 for X, 2 for Y and 3 for Z. ]]
function moveTo(x, y, z, order)
	if order == nil then
		order = { 2, 1, 3 }
	end

	for i=1,3 do
		if order[i] == 1 and x ~= nil then
			moveX(x)
		elseif order[i] == 2 and y ~= nil then
			moveY(y)
		elseif order[i] == 3 and z ~= nil then
			moveZ(z)
		end
	end
end

--[[ Tries to initialize the internal state with correct values.
     In order for position to be correct, a GPS must already be set up and the
     turtle must have a wireless modem installed.
     To find the correct direction, it should have some free space to 
     move around at the same level. ]]
function init()
	local x, y, z = gps.locate(10)
	if x ~= nil then
		checkForFuel()
		if turtle.forward() then
			local newX, newY, newZ = gps.locate(10)
			if newX > x then
				direction = 4
			elseif newX < x then
				direction = 2
			elseif newZ > z then
				direction = 3
			elseif newZ < z then
				direction = 1
			end
			setPosition(newX, newY, newZ)
			back()
		elseif turtle.back() then
			local newX, newY, newZ = gps.locate(10)
			if newX < x then
				direction = 4
			elseif newX > x then
				direction = 2
			elseif newZ < z then
				direction = 3
			elseif newZ > z then
				direction = 1
			end
			setPosition(newX, newY, newZ)
			forward()
		else
			turnLeft()
			if turtle.forward() then
				local newX, newY, newZ = gps.locate(10)
				if newX > x then
					direction = 4
				elseif newX < x then
					direction = 2
				elseif newZ > z then
					direction = 3
				elseif newZ < z then
					direction = 1
				end
				setPosition(newX, newY, newZ)
				back()
			elseif turtle.back() then
				local newX, newY, newZ = gps.locate(10)
				if newX < x then
					direction = 4
				elseif newX > x then
					direction = 2
				elseif newZ < z then
					direction = 3
				elseif newZ > z then
					direction = 1
				end
				setPosition(newX, newY, newZ)
				forward()
			end
			turnRight()
		end
	end
end

