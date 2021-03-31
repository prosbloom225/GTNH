require("urlencode")
local internet = require("internet")
local component = require("component")
local sides = require("sides")

local addr = "http://10.0.0.130:8080/item"
local storage = component.proxy("3bda7f2f-e3cf-4c4c-b20e-ceac4d01f2a9")
local storageSide = sides.back
local ae = component.proxy("6fdcf519-419e-451e-97e2-f9ab5bee75b4")

function getitems()
  ret = ""
  for _,item in pairs(storage.getAllStacks(storageSide).getAll()) do
    if (item.name ~= nil) then
      ret = ret .. string.format("size=%s&hasTag=%s&label=%s&maxDamage=%d&maxSize=%s&name=%s&size=%s\n", 
        item.size, 
        item.hasTag and "true" or "false",
        urlencode(item.label), 
        item.maxDamage,
        item.maxSize,
        urlencode(item.name),
        item.size
      )
    end
  end
  return ret
end

function getitemsjson()
  ret = "["
  for _,item in pairs(storage.getAllStacks(storageSide).getAll()) do
    if (item.name ~= nil) then
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


getaeitemsjson()
internet.request(addr, "Items=" .. getaeitemsjson(), POST).read()
--internet.request(addr, "Items=[{\"name\":\"aaa\"}]", POST).read()
