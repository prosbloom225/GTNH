local component = require('component')
local lce = component.proxy('84bb9dfd-be90-4dd8-96c7-968d83d91a6b')
local battery = component.proxy('88aae174-0299-4c4d-81d7-6b862ef824c2')


while (true) do
  --print(battery.getSensorInformation()[3])
  local curr = string.sub(battery.getSensorInformation()[3], string.find(battery.getSensorInformation()[3], "[%d%p]+"))
  local maxx = string.sub(battery.getSensorInformation()[3], string.find(battery.getSensorInformation()[3], "[%d%p]+", 24))

  print (curr .. "/" .. maxx)
  curr = (string.gsub(curr, "%D", ""))
  maxx = (string.gsub(maxx, "%D", ""))
  print(curr / maxx)

  if ((curr / maxx) < .9) then
    lce.setWorkAllowed(true)
  else
    lce.setWorkAllowed(false)
  end
  os.sleep(1)
end
