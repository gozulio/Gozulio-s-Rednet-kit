local component = require("component")
local sides = require("sides")
local colors = require("colors")
local rs = component.redstone
local conopen = colors.black
local read = colors.red
local com1in = {}
local com2in = {}
local traffic = 0

--[[REEDME: rnrelay.lua Ver:1.1
Its rather painfull extending a bundled cables range and keeping it a 2 way system...
So i wrote this to cercumvent that. =P
unlike the encoder/decoder, this forwards 14 colors, red and black dont. colors.

var "com1" is the connection for your first bundled cable.
var "com2" is the connection for your second bundled cable.
NOTE: As of opencomputers version 1.5.3.10 left/right apear to be backwards...
      as this program is designed to take in and relay a signal, it should not actually effect behavior of the script.
Changes:
 - Fixed issue with traffic counter.
]]--
local com1 = sides.right
local com2 = sides.left

function com1tocom2()
  for updateCount = 1, 14 do
    com1in[updateCount] = rs.getBundledInput(com1, updateCount -1)
    if com1in[updateCount] >= 1 then
      com1in[updateCount] = 255
    else
      --do nothing.
    end
  end
  --print(table.unpack(com1in))
  --print("")
  rs.setBundledOutput(com2, conopen, 255)
  for updateCount = 1, 14 do
    rs.setBundledOutput(com2, updateCount - 1, com1in[updateCount])
  end
  rs.setBundledOutput(com2, read, 255)
  os.sleep(1.5)
  rs.setBundledOutput(com2, read, 0)
  for updateCount = 1, 14 do
    rs.setBundledOutput(com2, updateCount - 1, 0)
    com1in[updateCount] = 0
  end
  rs.setBundledOutput(com2, conopen, 0)
end

function com2tocom1()
  for updateCount = 1, 14 do
    com2in[updateCount] = rs.getBundledInput(com2, updateCount -1)
    if com2in[updateCount] >= 1 then
      com2in[updateCount] = 255
    else
      --do nothing
    end
  end
  --print(table.unpack(com2in)) --debug...
  --print("")
  rs.setBundledOutput(com1, conopen, 255)
  for updateCount = 1, 14 do
    rs.setBundledOutput(com1, updateCount - 1, com2in[updateCount])
  end
  rs.setBundledOutput(com1, read, 255)
  os.sleep(1.5)
  rs.setBundledOutput(com1, read, 0)
  for updateCount = 1, 14 do
    rs.setBundledOutput(com1, updateCount -1, 0)
    com2in[updateCount] = 0
  end
  rs.setBundledOutput(com1, conopen, 0)
end

function main()
  if rs.getBundledInput(com1, conopen) >= 1 then
    while rs.getBundledInput(com1, read) == 0 do
      os.sleep(0.2)
    end
    com1tocom2()
    traffic = traffic + 1
    io.write("relayed... ", traffic, " bytes\n")
  else
    os.sleep(0.2)
  end
  if rs.getBundledInput(com2, conopen) >= 1 then
    while rs.getBundledInput(com2, read) == 0 do
      os.sleep(0.2)
    end
    com2tocom1()
    traffic = traffic + 1
    io.write("Relayed... ", traffic, " bytes\n")
  else
    os.sleep(0.2)
  end
end

while true do
  main()
  os.sleep(0.1)
end