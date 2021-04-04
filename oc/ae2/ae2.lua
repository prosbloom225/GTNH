require("urlencode")
local internet = require("internet")
local component = require("component")
local sides = require("sides")

local addr = "http://10.0.0.130:8080"
local ae = component.proxy("4f3910b4-6d04-44d4-b732-52444de610dd")


function getaeitemsjson()
  ret = "["
  filter = {}
  filter["damage"] = 0

  for _,item in pairs(ae.getItemsInNetwork()) do
    if (type(item) ~= "number" and item.name ~= nil) then
      ret = ret .. string.format("{\"damage\":\"%s\",\"hasTag\":\"%s\",\"label\":\"%s\",\"maxDamage\":\"%s\",\"maxSize\":\"%s\",\"name\":\"%s\",\"size\":\"%s\"},",
        item.damage, 
        item.hasTag and "true" or "false",
        urlencode(item.label), 
        item.maxDamage,
        item.maxSize,
        urlencode(item.name),
        item.size
      )
    end
  end
  ret = ret .. "]"
  return ret
end

function getaefluidsjson()
  ret = "["

  for _,f in pairs(ae.getFluidsInNetwork()) do
    if (type(f) ~= "number" and f.name ~= nil) then
      ret = ret .. string.format("{\"amount\":\"%s\",\"hasTag\":\"%s\",\"label\":\"%s\",\"name\":\"%s\"},",
        f.amount, 
        f.hasTag and "true" or "false",
        urlencode(f.label), 
        urlencode(f.name) 
      )
    end
  end
  ret = ret .. "]"
  return ret
end

tick = 2
while (true) do
  tick = tick+1
  internet.request(addr .. "/fluid", "Fluids=" .. getaefluidsjson(), POST).read()
  print("parsed fluids")
  if (tick %3 == 0) then
    internet.request(addr .. "/item", "Items=" .. getaeitemsjson(), POST).read()
    print("parsed items")
    tick = 0
  end
  os.sleep(60)
end
