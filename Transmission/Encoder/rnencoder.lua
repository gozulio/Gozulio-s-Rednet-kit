--[[
Declare blah.... reedme below.
]]--
local component = require("component")
local sides = require("sides")
local colors = require("colors")
local rs = component.redstone
local arg = table.pack(...)
--print(table.unpack(arg)) --debug...

--[[REEDME: rnencoder.lua Ver: 1.1
Gozulio's RedNet encoder. (uses Bundled Redstone.)

set veriable "com" to the side of your machine the bundled output is connected to.
variable "opencon" is the wire that will be used to signal when the connection is being used by another machine.
variable "readcon" defines when its ok to read the signal.

the program takes up to 8 arguements, but can use less then 8 if desired.

changes:
Version 1.1
 - Now uses a "readcon" variable to say when its ok to read off the wire, as it takes time to output the signal.
]]--
local opencon = colors.black -- "hey, im using this connection!"
local readcon = colors.red
local com = sides.back --bundled cable connection.

--/////////////////////////////////////////////////////////////////////////////
print("Encoder running with device...")
print(rs.address)

function convertInput()
  for argCounter = 1, 8 do
    if arg[argCounter] == nil then
      --do nothing.
    else
      arg[argCounter] = tonumber(arg[argCounter])
    end
    --io.write(argCounter, "- ", tostring(arg[argCounter]), ":") -- debug...
    if arg[argCounter] == 1 then
      arg[argCounter] = 255
    elseif arg[argCounter] == nil then
      --do nothing
    else
      arg[argCounter] = 0
    end
    --io.write(tostring(arg[argCounter]), " ") -- debug...
  end
end
--/////////////////////////////////////////////////////////////////////////////
function encode()
  local fail = 1
  while fail == 1 do
    if rs.getBundledInput(com, opencon) == 0 then
      --encode...
      fail = 0
      
      rs.setBundledOutput(com, opencon, 255)
      for argCounter = 1, 8 do
        if arg[argCounter] == nil then
          --do nothing.
        else
        rs.setBundledOutput(com, argCounter - 1, arg[argCounter])
        end
      end
      
      rs.setBundledOutput(com, readcon, 255)
      os.sleep(1)
      rs.setBundledOutput(com, readcon, 0)
      
      for argCounter = 1, 8 do
        rs.setBundledOutput(com, argCounter - 1, 0)
      end
      rs.setBundledOutput(com, opencon, 0)
      
      --print("Success!") -- debug.
    else
      fail = 1
      print("connection currently in use... waiting.")
      os.sleep(math.random(1, 10))
    end
  end
end

convertInput()
encode()

io.write("done.\n")