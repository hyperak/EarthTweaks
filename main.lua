PLUGIN = nil
Timer = {}
-- json = require('json') -- I do not read API-ese

function Initialize(Plugin)
    Plugin:SetName("EarthTweaks")
    Plugin:SetVersion(1)
    PLUGIN = Plugin
    LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

    -- Timer Setup

    Timer = {}
    Timer.__index = Timer
    local timers = {}
    local timerID = 0

    function Timer:New(sec, func)
       func = func or function() LOGERROR("A timer with no function has been provided!") return end;
       sec = sec or 30
       local self = setmetatable({Function = func, SetTime = sec*60, CurrentTime = 0}, Timer)
       table.insert(timers, self)
       return self
    end

    function Timer:ChangeDelay(sec)
        self.SetTime = sec*60
    end

    function Timer:Run()
        if type(self.Function) == "function" then
            self.Function()
        end
    end

    -- Ticker

    local function onTick()
       for _, v in pairs(timers) do
            if v.CurrentTime % v.SetTime == 0 and v.CurrentTime % 20 == 0 then
                Timer.Run(v)
                v.CurrentTime = 0
            end
            v.CurrentTime = v.CurrentTime + 1
        end
    end

    
    ---- Functions

    local function catatumbo()
        local x = math.random(-8593, -8583/CONFIG.MAPDIV)
        local y = 62
        local z = math.random(-1115, -1105/CONFIG.MAPDIV)
        cRoot:Get():GetWorld(CONFIG.WORLD_NAME):CastThunderbolt(Vector3i(x, y, z))
    end

    ---- Timers

    local catatumbo_t = Timer:New(3, catatumbo)

    -- Randomizes Catatumbo lighting strike time

    Timer:New(60, function()
        catatumbo_t:ChangeDelay(math.random(3,10))
    end)

    ---- Hooks

    cPluginManager.AddHook(cPluginManager.HOOK_WORLD_TICK, onTick)

    return true
end

function OnDisable()
    LOG(PLUGIN:GetName() .. " is shutting down...")
end
