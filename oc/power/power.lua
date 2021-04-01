local component = require('component')
local internet = require('internet')
local lce = component.proxy('84bb9dfd-be90-4dd8-96c7-968d83d91a6b')
local lgt = component.proxy('96bbe4c0-5c36-42c9-a7c5-64d4890092ad')
local nukeOne = component.proxy('c37e2e7e-1b2f-4eae-81b9-fb745ce03fc4')
local nukeTwo = component.proxy('4c37f73c-b7cb-4572-b0e9-87ba9ff65e50')
local battery = component.proxy('88aae174-0299-4c4d-81d7-6b862ef824c2')
local addr = "http://10.0.0.130:8080"

local maxHeat = 1

local lceThreshold = 0.9
local lceShutdown = 0.95

function getbatteryjson(label, curr, maxx, volts, amps)
  ret = string.format("[{\"label\":\"%s\",\"currPower\":\"%s\",\"maxPower\":\"%s\",\"volts\":\"%s\",\"amps\":\"%s\"},]",
    label, curr, maxx, volts, amps)
  print(ret)
  return ret
end

function getpowerjson(label, enabled, maint)
  ret = string.format("[{\"label\":\"%s\",\"enabled\":\"%s\",\"maintenance\":\"%s\"},]",
    label, enabled, maint)
  print(ret)
  return ret
end

while (true) do
  --print(battery.getSensorInformation()[3])
  local curr = string.sub(battery.getSensorInformation()[3], string.find(battery.getSensorInformation()[3], "[%d%p]+"))
  local maxx = string.sub(battery.getSensorInformation()[3], string.find(battery.getSensorInformation()[3], "[%d%p]+", 24))

  --print (curr .. "/" .. maxx)
  curr = (string.gsub(curr, "%D", ""))
  maxx = (string.gsub(maxx, "%D", ""))

  local sensorLgt = lgt.getSensorInformation()
  local sensorLce = lce.getSensorInformation()

  internet.request(addr .. "/battery", "Battery=" .. getbatteryjson('battery', curr, maxx, battery.getOutputVoltage(), battery.getOutputAmperage()), POST).read()
  internet.request(addr .. "/power", "Power=" .. getpowerjson('lce', lce.getWorkMaxProgress() > 0, sensorLce[3]:find("No Maintenance") ~= nil), POST).read()
  internet.request(addr .. "/power", "Power=" .. getpowerjson('lgt', lgt.getWorkMaxProgress() > 0, sensorLgt[2]:find("No Maintenance") ~= nil), POST).read()
  internet.request(addr .. "/power", "Power=" .. getpowerjson('nuke1', nukeOne.producesEnergy(), nukeOne.getHeat() >= maxHeat), POST).read()
  internet.request(addr .. "/power", "Power=" .. getpowerjson('nuke2', nukeTwo.producesEnergy(), nukeTwo.getHeat() >= maxHeat), POST).read()
  -- need two sleeps to get gc to close internet handles..
  os.sleep(1)


  if ((curr / maxx) < .9) then
    lce.setWorkAllowed(true)
  elseif ((curr / maxx) > lceShutdown) then
    lce.setWorkAllowed(false)
  end
  os.sleep(5)
end
