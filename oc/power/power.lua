local component = require('component')
local internet = require('internet')
local lce1 = component.proxy('84bb9dfd-be90-4dd8-96c7-968d83d91a6b')
local lce2 = component.proxy('7d6848e5-5b09-4a5c-8f8c-2581efc348bb')
local lgt1 = component.proxy('96bbe4c0-5c36-42c9-a7c5-64d4890092ad')
local nuk1 = component.proxy('c37e2e7e-1b2f-4eae-81b9-fb745ce03fc4')
local nuk2 = component.proxy('4c37f73c-b7cb-4572-b0e9-87ba9ff65e50')
local battery = component.proxy('88aae174-0299-4c4d-81d7-6b862ef824c2')
local addr = "http://10.0.0.130:8080"

local maxHeat = 1

local lceThreshold = 0.9
local lceShutdown = 0.95

function getbatteryjson(label, curr, maxx, volts, amps, input, output)
  ret = string.format("[{\"label\":\"%s\",\"currPower\":\"%s\",\"maxPower\":\"%s\",\"volts\":\"%s\",\"amps\":\"%s\",\"input\":\"%s\",\"output\":\"%s\"},]",
    label, curr, maxx, volts, amps, input, output)
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
  local sensorBatt = battery.getSensorInformation()
  local sensorLgt1 = lgt1.getSensorInformation()
  local sensorLce1 = lce1.getSensorInformation()
  local sensorLce2 = lce1.getSensorInformation()

  local curr = string.sub(sensorBatt[3], string.find(sensorBatt[3], "[%d%p]+"))
  local maxx = string.sub(sensorBatt[3], string.find(sensorBatt[3], "[%d%p]+", 24))
  local input = string.sub(sensorBatt[5], string.find(sensorBatt[5], "[%d%p]+"))
  local output= string.sub(sensorBatt[7], string.find(sensorBatt[7], "[%d%p]+"))

  --print (curr .. "/" .. maxx)
  curr = (string.gsub(curr, "%D", ""))
  maxx = (string.gsub(maxx, "%D", ""))
  input = (string.gsub(input, "%D", ""))
  output= (string.gsub(output, "%D", ""))


  internet.request(addr .. "/battery", "Battery=" .. getbatteryjson('batt', curr, maxx, battery.getOutputVoltage(), battery.getOutputAmperage(), input, output), POST).read()
  os.sleep(1)
  internet.request(addr .. "/power", "Power=" .. getpowerjson('lce1', lce1.getWorkMaxProgress() > 0, sensorLce1[3]:find("No Maintainance") == nil), POST).read()
  os.sleep(1)
  internet.request(addr .. "/power", "Power=" .. getpowerjson('lce2', lce2.getWorkMaxProgress() > 0, sensorLce2[3]:find("No Maintainance") == nil), POST).read()
  os.sleep(1)
  internet.request(addr .. "/power", "Power=" .. getpowerjson('lgt1', lgt1.getWorkMaxProgress() > 0, sensorLgt1[2]:find("No Maintainance") == nil), POST).read()
  os.sleep(1)
  internet.request(addr .. "/power", "Power=" .. getpowerjson('nuk1', nuk1.producesEnergy(), nuk1.getHeat() >= maxHeat), POST).read()
  os.sleep(1)
  internet.request(addr .. "/power", "Power=" .. getpowerjson('nuk2', nuk2.producesEnergy(), nuk2.getHeat() >= maxHeat), POST).read()
  os.sleep(1)
  -- need two sleeps to get gc to close internet handles..


  if ((curr / maxx) < .8) then
    lce1.setWorkAllowed(true)
  elseif ((curr / maxx) > lceShutdown) then
    lce1.setWorkAllowed(false)
  end
  if ((curr / maxx) < .5) then
    lce2.setWorkAllowed(true)
  elseif ((curr / maxx) > lceShutdown) then
    lce2.setWorkAllowed(false)
  end
  os.sleep(5)
end
