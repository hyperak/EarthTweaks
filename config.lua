-- Meant to be used with the map at earth.motfe.net

---- Dimensions of the map scales
-- 1:1000 is 43008x21504
-- 1:2000 is 21504x10752
-- 1:4000 is 10752x5376

local settings = {

    mapscale = "1:1000",

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
g_mapdiv = nil
g_modules = {}

-- Set up cool gamer fallback
setmetatable(settings["modules"], g_modules)
g_modules.__index = g_modules

local ms = settings.mapscale

if ms == "1:1000" then
    g_mapdiv = 1
elseif ms == "1:2000" then
    g_mapdiv = 2
elseif ms == "1:4000" then
    g_mapdiv = 4
else
    LOGERROR("No map scale specified! Using 1:1000 by default")
    g_mapdiv = 1
end