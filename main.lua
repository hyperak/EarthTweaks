PLUGIN = nil

-- Hard-coded to be used with the 1:1000 map at http://earth.motfe.net

local settings = {}

settings.WORLD_NAME = "world"

function Initialize(Plugin)
    Plugin:SetName("EarthTweaks")
    Plugin:SetVersion(1)
    PLUGIN = Plugin

    
    LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

    -- Timer Setup

    local timerID = 0
    local Timer = {}
    local timers = {}

    Timer.__index = Timer

    function Timer:New(sec, func)
       local object = {Function = func, SetTime = sec^2, CurrentTime = 0, TimesRun = 0}
       setmetatable(object, Timer)
       return object
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
       for k, v in pairs(timers) do
	  if v.CurrentTime % v.SetTime == 0 and v.CurrentTime % 20 == 0 then
	     Timer.Run(v)
	     v.CurrentTime = 0
	  end
	  v.CurrentTime = v.CurrentTime + 1
       end
    end

    
    ---- Functions

    local function catatumbo() 
       cRoot:Get():GetWorld(settings.WORLD_NAME):CastThunderbolt(Vector3i(math.random(-8593, -8583), 62, math.random(-1115, -1105)))
    end

    ---- Timers

    timers.catatumbo = Timer:New(3, catatumbo)    

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
    
