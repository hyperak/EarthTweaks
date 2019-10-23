-- Meant to be used with the map at earth.motfe.net

---- Dimensions of the map scales
-- 1:1000 is 43008x21504
-- 1:2000 is 21504x10752
-- 1:4000 is 10752x5376

local settings = {

    mapscale = "1:1000",
    world_name = "world",

    modules = {
	real_weather = true,
	phenomenons = true
    }
}

-- Do not touch beyond here!

local mapscales = {}
mapscales["1:1000"] = {width = 43008, length = 21504}
mapscales["1:2000"] = {width = 21504, length = 10752}
mapscales["1:4000"] = {width = 10752, length = 5376}

-- Globals
_CONFIG = {}
_CONFIG.MAPDIV = nil
_CONFIG.WORLD_NAME = settings.world_name
_CONFIG.MODULES = setmetatable(settings["modules"], {__index})

local ms = settings.mapscale

if ms == "1:1000" then
    _CONFIG.MAPDIV = 1
elseif ms == "1:2000" then
    _CONFIG.MAPDIV = 2
elseif ms == "1:4000" then
    _CONFIG.MAPDIV = 4
else
    LOGERROR("No map scale specified! Using 1:1000 by default")
    _G.MAPDIV = 1
end