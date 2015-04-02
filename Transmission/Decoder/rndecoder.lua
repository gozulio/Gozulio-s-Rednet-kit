--[[
Declare blah... Reedme below.
]]--
local component = require("component")
local sides = require("sides")
local colors = require("colors")
local rs = component.redstone
local output = {}
--[[REEDME: rndecoder.lua Ver: 1.0
gozulios RedNet Decoder (uses bundled redstone)

variable "opencon" is used to define the "open connection" signal.
variable "read" defines when to read the signal.
variable "com" defines what side the bundled cable is connected to.

the program will wait for "opencon" to be greater then 0, then return what it receives.
]]--
local opencon = colors.black
local readcon = colors.red
local com = sides.back

--/////////////////////////////////////////////////////////////////////////////
print("Decoder running on device...")
print(rs.address)

function decode()
  local hold = 1
  while rs.getBundledInput(com, readcon) == 0 do
    hold = 1
  end
  for outCounter = 1, 8 do
    output[outCounter] = (rs.getBundledInput(com, outCounter - 1))
  end
  hold = 0
end

function convertdata()
  for outCounter = 1, 8 do
    if output[outCounter] >= 1 then
    output[outCounter] = 1
    else
    --do nothing
    end
  end
end

decode()
print(table.unpack(output)) --debug...
convertdata()
print(table.unpack(output)) --debug...
return output