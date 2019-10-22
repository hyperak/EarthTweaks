PLUGIN = nil

local settings = {}

settings.WORLD_NAME = "world"

function Initialize(Plugin)
    Plugin:SetName("EarthTweaks")
    Plugin:SetVersion(1)
    PLUGIN = Plugin

    
    LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

    -- Timer Setup

    local Timer = {}
    local timers = {}

    Timer.__index = Timer

    function Timer:New(sec, func)
       return setmetatable({Function = func, SetTime = sec^2, CurrentTime = 0, TimesRun = 0}, Timer)
    end

    function Timer:ChangeDelay(sec)
       self.SetTime = sec^2
    end

    function Timer:Run()
       if type(self.Function) == "function" then
	  self.Function()
       end
    end

    -- Ticker
    
    local function onTick()
     --[[
       for _, v in pairs(timers) do
	  if v.CurrentTime % v.SetTime == 0 and v.CurrentTime % 20 == 0 then
	     Timer.Run(v)
	     v.CurrentTime = 0
	  end
	  v.CurrentTime = v.CurrentTime + 1
       end
     --]]
	for k, v in pairs(Timer) do
	    local p = nil
	    if type(v) == table then
	       p = table.concat(v, ", ")
	    elseif type(v) == function then
	       p = v()
	    else
	       p = v
	    end
	    LOG(k..": "..p)
	end
    end

    
    ---- Functions

    local function catatumbo()
        local x = math.random(-8593, -8583)
	local y = 62
	local z = math.random(-1115, -1105)
       cRoot:Get():GetWorld(settings.WORLD_NAME):CastThunderbolt(Vector3i(x, y, z))
    end

    ---- Timers

    Timer:New(3, catatumbo)

    -- Randomizes Catatumbo lighting strike time

    timers.rantumbo = Timer:New(30, function()
       timers.catatumbo:ChangeDelay(math.random(2,5))
    end)

    ---- Hooks

    cPluginManager.AddHook(cPluginManager.HOOK_WORLD_TICK, onTick)
    
    return true
end

function OnDisable()
    LOG(PLUGIN:GetName() .. " is shutting down...")
end