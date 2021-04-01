local component = require('component')
local internet = require('internet')
local lce = component.proxy('84bb9dfd-be90-4dd8-96c7-968d83d91a6b')
local battery = component.proxy('88aae174-0299-4c4d-81d7-6b862ef824c2')
local addr = "http://10.0.0.130:8080"

function getbatteryjson(label, curr, maxx, volts, amps)
  ret = string.format("[{\"label\":\"%s\",\"currPower\":\"%s\",\"maxPower\":\"%s\",\"volts\":\"%s\",\"amps\":\"%s\"},]",
    label, curr, maxx, volts, amps)
  print(ret)
  return ret
end

function getpowerjson(label, enabled)
  ret = string.format("[{\"label\":\"%s\",\"enabled\":\"%s\"},]",
    label, enabled > 0)
  print(ret)
  return ret
end

while (true) do
  --print(battery.getSensorInformation()[3])
  local curr = string.sub(battery.getSensorInformation()[3], string.find(battery.getSensorInformation()[3], "[%d%p]+"))
  local maxx = string.sub(battery.getSensorInformation()[3], string.find(battery.getSensorInformation()[3], "[%d%p]+", 24))

  print (curr .. "/" .. maxx)
  curr = (string.gsub(curr, "%D", ""))
  maxx = (string.gsub(maxx, "%D", ""))
  print(curr / maxx)
  internet.request(addr .. "/battery", "Battery=" .. getbatteryjson('battery', curr, maxx, battery.getOutputVoltage(), battery.getOutputAmperage()), POST).read()
  internet.request(addr .. "/power", "Power=" .. getpowerjson('lce', lce.getWorkProgress()), POST).read()

  if ((curr / maxx) < .9) then
    lce.setWorkAllowed(true)
  else
    lce.setWorkAllowed(false)
  end
  os.sleep(5)
end
