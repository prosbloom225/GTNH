local component = require('component')
local internet = require("internet")
local gpu = component.gpu

local battery = component.proxy('4620b3e1-c221-48ca-8642-2c13d1803a95')

local oldW, oldH = gpu.getResolution()
local curr = 0
local maxx = 0

function clearScreen()
  local oldColor = gpu.getBackground( false )
  local w,h = gpu.getResolution()
  gpu.setBackground( 0x000000, false )
  gpu.fill( 1, 1, w, h, " " )
  gpu.setBackground( oldColor, false )
end

function formatBig( value )
  local output = ""
  local valRem = 0
  local valPart = 0
  while value > 0 do
    valRem = math.floor( value / 1000 )
    valPart = value - (valRem * 1000)
    if output == "" then
      output = string.format( "%03d", valPart )
    elseif valRem == 0 then
      output = valPart .. "," .. output
    else
      output = string.format( "%03d", valPart ) .. "," .. output
    end
    value = valRem
  end
  return output
end

function progressBar( label, y, value, maxVal, color, show, unit )
  local oldColor = gpu.getBackground( false )
  gpu.setBackground(0x000000, false)
  gpu.fill( 3, y, 155, 2, " " )
  w = math.floor( value * (155 / maxVal) )
  p = math.floor( (w / 155) * 100 )
  gpu.set( 3, y, label .. ": " .. tostring( p ) .. "%" )
  gpu.setBackground( 0x222222, false )
  gpu.fill( 3, y+1, 155, 1, " " )
  gpu.setBackground( color, false )
  gpu.fill( 3, y+1, w, 1, " " )
  gpu.setBackground( oldColor, false )
  if show then
    local valStr = formatBig( value ) .. unit
    local n = string.len( valStr )
    gpu.set( 158 - n, y, valStr )
  end
end

function getbatterytotal()
  local handle = internet.request("http://10.0.0.130:8080/getBatteryTotal")
  local result = ""
  for chunk in handle do result = result..chunk end
  curr = tonumber(string.sub(result, 0, string.find(result, "%p")-1))
  maxx = tonumber(string.sub(result, string.find(result, "%p")+4, string.len(result)-3))
end

function getpowerstatus()
  local handle = internet.request("http://10.0.0.130:8080/getPowers")
  local result = ""
  local w,h = gpu.getResolution()
  for chunk in handle do result = result..chunk end

  local offset = 6
  for power in string.gmatch(result, "[^,]+") do
    local label = string.sub(power, 0, string.find(power, "-")-1)
    local enabled = string.sub(power, string.find(power, "-")+1, string.find(power, ";")-1)
    local maint = string.sub(power, string.find(power, ";")+1, string.len(power))
    gpu.fill( 1, offset, h, 1, " " )
    if (maint == "true") then
      gpu.setForeground(0xcc0000)
    else
      gpu.setForeground(0x00bb00)
    end
    gpu.set(2,offset, label .. " - " .. enabled)
    offset = offset +1
  end
  gpu.setForeground(0xFFFFFF)
  if (enabled == "true") then
    return 0xcc0000
  else
    return 0x00bb00
  end
end

function main()
  clearScreen()
  gpu.set(1, 1, "Power Monitor" )
  while (true) do
    getbatterytotal()
    gpu.set(2, 2, curr .. "/" .. maxx)
    local color = getpowerstatus()
    progressBar('Total', 3, curr, maxx, color , true, "EU")
    --progressBar('Total', 3, 1, 4, color , true, "EU")
    os.sleep(5)
  end
end

main()
