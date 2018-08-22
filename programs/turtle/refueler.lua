-- Copyright (C) 2017-2018, GReaperEx(Marios F.)

-- Change this line for different facing
local chestDir = "north"
-- And the following for different stand-by position
local standbyPos = vector.new(0, 0, 0)

local serverID = nil

local function deliverFuel(x, y, z, dir)
    -- Go refill if empty
    local fuelSlot = 0
    for i=16,2 do
        if turtle.getItemCount(i) ~= 0 then
            fuelSlot = i
            break
        end
    end
    if fuelSlot == 0 then
        xpos.moveTo(standbyPos.x, standbyPos.y, standbyPos.z)
        xpos.turnAbs(chestDir)
        for i=1,16 do
            turtle.select(i)
            turtle.suck()
        end
        fuelSlot = 16
    end

    xpos.moveTo(x, y, z)
    xpos.turnAbs(dir)
    turtle.select(fuelSlot)
    turtle.drop()

    xpos.moveTo(standbyPos.x, standbyPos.y, standbyPos.z)
    xpos.turnAbs(chestDir)
    rednet.send(serverID, textutils.serialize(toSend), "register-fuel")
end


xpos.moveTo(standbyPos.x, standbyPos.y, standbyPos.z)
xpos.turnAbs(chestDir)

serverID = rednet.lookup("CtrlServer")
if serverID == nil then
    print("Failed to connect with a control server.")
    return
end

local toSend = {}
toSend.id = os.getComputerID()
rednet.send(serverID, textutils.serialize(toSend), "register-fuel")

while true do
    local id, msg = rednet.receive("refuel")
    local address = textutils.unserialize(msg)

    deliverFuel(address.x, address.y, address.z, address.dir)
end

