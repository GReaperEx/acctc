-- Copyright (C) 2017, GReaperEx(Marios F.)

local refuelerIDs = {}

local function registerRefueler(msg)
	local table = textutils.unserialize(msg)
	refuelerIDs[table.id] = true
end

local function askForFuel(senderID, msg)
	for id,isAvail in ipairs(refuelerIDs) do
		if isAvail == true then
			refuelerIDs[id] = false
			rednet.send(id, msg, "refuel")
			rednet.send(senderID, "ACK", "out-of-fuel")
			return
		end
	end
	rednet.send(senderID, "NAK", "out-of-fuel")
end


-- Setting up a modem for transmission
local periList = peripheral.getNames()
local modem = nil

-- You can also comment all this out and set the modem side manually
for i = 1, #periList do
	if peripheral.getType(periList[i]) == "modem" then
		modem = periList[i]
	end
end

if modem == nil then
	print("Unable to find a modem for communication.")
	return
end
rednet.open(modem)

-- Registering server
local hostname = os.getComputerLabel()
if hostname == nil then
	hostname = "Computer" .. os.getComputerID()
end

rednet.host("CtrlServer", hostname)

while true do
	local id, msg, prot = rednet.receive()
	if prot == "out-of-fuel" then
		askForFuel(id, msg)
	elseif prot == "register-fuel" then
		registerRefueler(msg)
	end
end

