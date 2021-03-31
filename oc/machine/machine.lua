local component = require('component')
local sides = require('sides')
local coroutine = require('coroutine')


Machine = {}
Machine.__index = Machine

function Machine:new(machineName, ore, machine, dirMachine, dirMachineInput, dirMachineOutput, multi, d)
  local mach = {}
  setmetatable(mach,Machine)

  mach.machineName = machineName
  mach.ore = ore
  mach.machine = component.proxy(machine)
  mach.dirMachine = dirMachine
  mach.dirMachineInput  = dirMachineInput
  mach.dirMachineOutput = dirMachineOutput
  mach.multi = multi
  mach.debug = d
  mach.tick = 0
  mach.inputSlot = 1
  mach.start = os.time()

  return mach
end


function Machine:pprint(s)
  print (self.machineName .. " " .. s)
end

function Machine:dump()
  if self.debug then
    -- dump the machine list
    self:pprint("dumping ore list")
    for k,v in pairs(self.ore) do
      self:pprint(k .. " " .. v)
    end
  end
end



-- INIT
function Machine:init()
  -- init vars
  self.start = os.time()
  self.tick = 0
  if (self.multi == true) then
    self.inputSlot = self.machine.getInventorySize(self.dirMachine)
    self:pprint("input slot set to: " .. self.inputSlot)
  else
    self:pprint("input slot set to: " .. self.inputSlot)
  end
  -- clean machine input
  if self.debug then
    self:pprint ("cleaning input")
  end
  for i=self.machine.getInventorySize(self.dirMachine),1,-1 do
    if (self.machine.getSlotStackSize(self.dirMachine, i) > 0) then
      self:pprint('cleaning item')
      for j=1,self.machine.getInventorySize(self.dirMachineOutput) do
        if (self.machine.getSlotStackSize(self.dirMachineOutput, j) == 0) then
          if self.debug then 
            self:pprint ('found output slot' .. j)
            self:pprint (self.machine.getSlotStackSize(self.dirMachine, i) .. " " .. i .. " " .. j)
          end
          self.machine.transferItem(self.dirMachine, self.dirMachineOutput, self.machine.getSlotStackSize(self.dirMachine, i), i, j)
          break
        end
      end
    end
  end
end

function Machine:mainloop()
  self:pprint("Begin!")
  while (true) do
    for i=1,self.machine.getInventorySize(self.dirMachineInput) do
      item = self.machine.getStackInSlot(self.dirMachineInput, i)
      if (item ~= nil) then
        for k,v in pairs(self.ore) do
          if (string.find(item.label, k) and ((item.size-1) // v > 0)) then
            if self.debug then
              self:pprint("found: " .. item.label .. "x" .. (item.size-1) // v)
            end
            while (self.machine.getSlotStackSize(self.dirMachine, self.inputSlot) ~=0) do
              if self.debug then
                self:pprint("waiting for slot: " .. self.inputSlot .. ": " .. self.machine.getSlotStackSize(self.dirMachine, self.inputSlot))
              end
              coroutine.yield()
              --os.sleep(1)
            end
            self:pprint("processing item: " .. item.label .. "x" .. ((item.size-1)//v))
            self.machine.transferItem(self.dirMachineInput, self.dirMachine, ((item.size-1) //v) * v, i, self.inputSlot)
          end
        end
      end
    end
    -- clean input every x ticks to prevent stuck
    -- dump the items back in the storage
    self.tick = self.tick +1
    if (self.tick == 10) then
      self:init()
    end
    if self.debug then
      self:pprint("tick : " .. self.tick .. " - " .. (os.difftime(os.time(), self.start) // 100 ))
      self:pprint("Sleeping...")
    end
    coroutine.yield()
    --os.sleep(1)
  end
end

function Machine:process()
  --self:dump()
  self:init()
  self:mainloop()
end

