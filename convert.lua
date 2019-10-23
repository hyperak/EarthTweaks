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

-- Mere testing of the code
local lat, lon = toDMS(10.2532284, -67.5926057)
local mlat, mlon = toMCCoords(10.2532284, -67.5926057)

