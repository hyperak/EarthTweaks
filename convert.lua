-- Port of http://earth.motfe.net/coords.php

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
   local mul_lat = 21600/_CONFIG.MAPDIV
   local mul_lon = 10800/_CONFIG.MAPDIV

   mc_lat = math.floor((mc_lat * mul_lat) + 0.5)
   mc_lon = math.floor((mc_lon * mul_lon) + 0.5)

   return mc_lat, mc_lon
end

-- This tasty part is not tasty because it's painful

function getPlaceFromCoords(lat, lon)
    -- AAAARG I HAVE TO CACHE IT!!!!!
   local function loadFromCache(json)
         for _k, _v in pairs(json) do
            LOG(_v)
            for k, v in pairs(_v) do
               LOG(v)
               local yesLat = false
               local yesLon = false
               if k == "lat" then
                  if v - lat < 1 and v - lat > 1 then -- Some flexibility as far as 1 degree
                     yesLat = true
                  end
               elseif k == "lon" then
                  if v - lon < 1 and v - lon > 1 then
                     yesLon = true
                  end
               end
            end
	       if yesLat and yesLon then
            return v["display_name"], v["address"]["city"]..', '..string.upper(v["address"]["country_code"])
	       end
	    end
   end
   local file_r = io.open("places.json", "r")
   local j_file_r = {}
   if type(file_r:read()) == "string" then
      LOG("doing result")
      local _read = file_r:read('*a')
      LOG(_read)
      local _j_file_r = cJson:Parse(_read)
      if type(_j_file_r) == "table" then
         j_file_r = _j_file_r
      end
      local result = loadFromCache(j_file_r)
      LOG("computation done, "..type(result))
      return result or nil
   else
      local file_new = io.open("places.json", "w")
      file_new:write("")
      file_new:close()
   end
   -- Downloading if it's not cached
   local url = "https://nominatim.openstreetmap.org/reverse?format=json&lat="..lat.."&lon="..lon
   local res, body, jsonBody = cUrlClient:Get(url, function(a_Body, a_Data)
      LOG("MY MEDICAL EXAM RESULTS ARE IN!!!")
      if a_Body then
         LOG(a_Body)
         return 1, a_Body, cJson:Parse(a_Body)
      else
         return 0, a_Data
      end
   end)
   local file_w = io.open("places.json", "w+")
   table.insert(j_file_r, jsonBody)
   local j_file_w = cJson:Serialize(j_file_r)
   file_w:write(j_file_w)
   file_w:close()
   file_r:close()
   return jsonBody["display_name"], jsonBody["address"]["city"]..', '..string.upper(jsonBody["address"]["country_code"])
end

-- Mere testing of the code
local testlat = 10.2532284
local testlon = -67.5926057
local lat, lon = toDMS(testlat, testlon)
local mlat, mlon = toMCCoords(testlat, testlon)
local rlat, rlon = getPlaceFromCoords(testlat, testlon)
