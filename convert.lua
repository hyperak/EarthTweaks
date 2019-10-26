-- Port of http://earth.motfe.net/coords.php

-- http://lua-users.org/wiki/FileInputOutput

-- Find the length of a file
--   filename: file name
-- returns
--   len: length of file
--   asserts on error

local json_filename = "Plugins/EarthTweaks/places.json"

local fs = {}
function fs.write(filename, contents)
   if type(contents) ~= "string" then return end
   local fh = assert(io.open(filename, "wb"))
   fh:write(contents)
   fh:flush()
   fh:close()
end

function toDMS(lat, lon)
   lat = lat or 0
   lon = lon or 0

   local function conversion(dd, latOrLon)
    	local dms = {}
      dms.d = math.floor(dd+.5)
      dms.m = math.floor(((dd - dms.d) * 60) + .5)
      dms.s = (dd - dms.d - dms.m/60) * 3600
      dms.pol = nil

      if dms.d < 0 then
         dms.d = -dms.d
      end

      if latOrLon == "latitude" then
         if dd <= 0 then
            dms.pol = "S"
         else
            dms.pol = "N"
	      end
      elseif latOrLon == "longitude" then
         if dd <= 0 then
	      	 dms.pol = "W"
         else
            dms.pol = "E"
	       end
      end

      return dms
   end

   return conversion(lat, "latitude"), conversion(lon, "longitude")
end

function toDD(lat, lon)
   -- Soon(tm)
end

function toMCCoords(lat, lon)
   local dms_lat, dms_lon = toDMS(lat, lon)
   local lat = dms_lat.s + dms_lat.m * 60 + dms_lat.d * 3600
   local lon = dms_lon.s + dms_lon.m * 60 + dms_lon.d * 3600
   if dms_lat.pol == "N" then
      lat = -lat
   end
   if dms_lon.pol == "W" then
      lon = -lon
   end
   local mc_lat = lat/648000
   local mc_lon = lon/324000
   local mul_lat = 21600/CONFIG.MAPDIV
   local mul_lon = 10800/CONFIG.MAPDIV

   mc_lat = math.floor((mc_lat * mul_lat) + 0.5)
   mc_lon = math.floor((mc_lon * mul_lon) + 0.5)

   return mc_lat, mc_lon
end

function getCoordsFromPlace(lat, lon)
    -- AAAARG I HAVE TO CACHE IT!!!!!
   local function loadFromCache(json)
      local foundLat = nil
      local foundLon = nil
      for k, v in pairs(json) do
         LOG("key "..tostring(k))
         LOG("value "..tostring(v))
         if v == "lat" then
            LOG((k["lat"]) - (lat))
            if (k["lat"]) - (lat) < 1 then
               foundLat = v
            end
         elseif v == "lon" then
            LOG((k["lon"]) - (lon))
            if (k["lon"]) - (lon) < 1 then
               foundLon = v
            end
         end
         if foundLat and foundLon then
            return assert(k["display_name"]), assert(k["address"]["city"]..', '..string.upper(k["address"]["country_code"])), foundLat, foundLon
         end
      end
   end
   local file_r = cFile:ReadWholeFile(json_filename)
   local nLat, nLon, name, weather_name
   local j_file_r = {}
   local _j_file_r = cJson:Parse(file_r)
   if type(_j_file_r) == "table" then -- Tasty type checking
      j_file_r = _j_file_r
      nLat, nLon, name, weather_name = loadFromCache(j_file_r)
      LOG("computation done, "..type(name))
   else
      fs.write(json_filename,'')
   end
   if not name then
      -- Downloading if it's not cached
      local url = "https://nominatim.openstreetmap.org/reverse?format=json&lat="..lat.."&lon="..lon
      local res, body, jsonBody = cUrlClient:Get(url, function(a_Body, a_Data)
         if a_Body then
            LOG(a_Body)
            return 1, a_Body, cJson:Parse(a_Body)
         else
            return 0, a_Data
         end
      end)
      fs.write(json_filename, body)
      if type(jsonBody) == 'table' then
         result = jsonBody["display_name"], jsonBody["address"]["city"]..', '..string.upper(jsonBody["address"]["country_code"])
      end
   end
   return name, weather_name
end

-- Mere testing of the code
local testlat = 10.2532284
local testlon = -67.5926057
local lat, lon = toDMS(testlat, testlon)
local mlat, mlon = toMCCoords(testlat, testlon)
local rlat, rlon, name, weather_name = getCoordsFromPlace(testlat, testlon)
LOG(name)
