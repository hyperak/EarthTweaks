-- Meant to be used with the map at earth.motfe.net

---- Dimensions of the map scales
-- 1:1000 is 43008x21504
-- 1:2000 is 21504x10752
-- 1:4000 is 10752x5376

g_Settings = {

    world_length = 43008,
    world_width = 21504,

    modules = {
	real_weather = true, -- Uses https://openweathermap.org/. If worried about bandwidth, reminder that this was initially made by a developer on a 200Kbps download speed.
	phenomenons = true -- Climate phenomenons, such as https://en.wikipedia.org/wiki/Catatumbo_lightning
    },

}