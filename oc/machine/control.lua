local sides = require('sides')
local thread = require('thread')
local machine = require('machine')
local coroutine = require('coroutine')


local oreCentrifuge = {
  ['Wulfenite Dust'] = 6,
  ['Yellow Garnet Dust'] = 16,
  ['Red Garnet Dust'] = 16,
  ['Endstone Dust'] = 1,
  ['Powellite Dust'] = 6,
  ['Black Granite Dust'] = 5,
  ['Diatomite Dust'] = 10,
  ['Vanadium Magnetite Dust'] = 2,
  ['Basaltic Mineral Sand'] = 1,
  ['Rare Earth'] = 1,
  ['Uranium 238 Dust'] = 1,
  ['Garnet Sand'] = 2,
  ['Realgar Dust'] = 2,
  ['^Impure Pile of.*'] = 1,
  ['^Purified.*'] = 1,

}

local oreElectrolyzer = {
  ['Spodumene Dust'] = 10,
  ['Magnetite Dust'] = 7,
  ['Cobaltite Dust'] = 3,
  ['Grossular Dust'] = 20,
  ['Barite Dust'] = 6,
  ['Sodalite Dust'] = 11, 
  ['Sapphire Dust'] = 5, 
  ['Kyanite Dust'] = 8,
  ['Spessartine Dust'] = 20,
  ['Pyrope Dust'] = 20,
  ['Glauconite Sand'] = 21,
  ['Lazurite Dust'] = 14,
  ['Zeolite Dust'] = 41,
  ['Emerald Dust'] = 29,
  ['Magnesite Dust'] = 5,
  ['Olivine Dust'] = 5,
  ['Almandine Dust'] = 20,
  ['Borax Dust'] = 23,
  ['Glauconite Dust'] = 21,
  ['Silicon Dioxide Dust'] = 3,
  ['Tantalite Dust'] = 9,
  ['Pyrolusite Dust'] = 3,
  ['^Coal Dust'] = 1,
  ['Lignite Coal Dust'] = 4,
  ['Gypsum Dust'] = 8,
  ['Sphalerite Dust'] = 2,
  ['Lepidolite Dust'] = 20,
  ['Ruby Dust'] = 6,
  ['Uvarovite Dust'] = 20,
  ['Biotite Dust'] = 22,
  ['Molybdenite Dust'] = 3,
  ['Pyrochlore Dust'] = 11,
  ['Calcite Dust'] = 5,
  ['Mica Dust'] = 19,
  ['Asbestos Dust'] = 18,
  ['Andradite Dust'] = 20,
  ['Tungstate Dust'] = 7,
  ['Saltpeter Dust'] = 5,
  ['Pollucite Dust'] = 11,
  ['Bentonite'] = 30,
  ['Phosphate Dust'] = 5,
  ['Fullers Earth'] = 21,
  ['Barite Dust'] = 6,
  ['Soapstone Dust'] = 21,
  ['Rock Salt'] = 2,
}

a = Machine:new("Centrifuge", oreCentrifuge, 'eea4e270-1c1c-4884-a2d1-46daaa3893e6', sides.left, sides.back, sides.front, true, false)
b = Machine:new("Electrolyzer", oreElectrolyzer, 'be907fcd-698e-435f-8524-480883155fa6', sides.right, sides.back, sides.front, false, false)

local c = coroutine.create(function() a:process() end)
local e = coroutine.create(function() b:process() end)

-- main loop
while (true) do
  coroutine.resume(c)
  coroutine.resume(e)
  print('---')
  os.sleep(0.1)
end

--[[
local c = coroutine.create(function() process("Centrifuge", oreCentrifuge, 'eea4e270-1c1c-4884-a2d1-46daaa3893e6', sides.left, sides.back, sides.front, true) end)
local e = coroutine.create(function() process("Electrolyzer", oreElectrolyzer, 'be907fcd-698e-435f-8524-480883155fa6', sides.right, sides.back, sides.front, true) end)

while (true) do
  print("Tick")
  coroutine.resume(c)
  print("---")
  coroutine.resume(e)
  print ("Tock")
  os.sleep(1)
end
]]--

--local procCentrifuge = thread.create(os.execute, 'centrifuge.lua')
--procCentrifuge:detach()
