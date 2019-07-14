gl.setup(1920, 1080)

local json = require "json"

local bold_twc = resource.load_font("Tw Cen MT Bold.ttf")
local regular_twc = resource.load_font("Tw Cen MT.ttf")
local bold_scp = resource.load_font("bold.ttf")
local regular_scp = resource.load_font("regular.ttf")

local header = resource.load_image("header.png")

local frame = 1
local await = true

local day = 0
local hour = 0
local minute = 0
local second = 0
local unixtime = 0

local sep = {'.', ':'}

local talks = {}
local next_talks = {}


function update_next_talks()
   next_talks = get_next_talks(talks)
end


function get_next_talks(talks)
   local next_talks = {}

   for idx, talk in ipairs(talks) do
      local starttime = talk['timestamp']
      if starttime >= unixtime - 300*3 and starttime <= unixtime + 3600*12 then
         table.insert(next_talks, talk)
      end
   end

   return next_talks
end


function wrap(str, limit)
   local limit = limit or 72
   local here = 1
   local wrapped = str:gsub("(%s+)()(%S+)()",
                            function(sp, st, word, fi)
                               if fi - here > limit then
                                  here = st
                                  return "\n" .. word
                               end
                            end
   )
   local splitted = {}
   for token in string.gmatch(wrapped, "[^\n]+") do
      splitted[#splitted + 1] = token
   end
   return splitted
end


function node.render()
   gl.clear(0,0,0,1)

   local xpos = 70

   -- Header
--   if second % 12 == 0 then
--      if await == true then
--         await = false
--         frame = frame % #header + 1
 --     end
--   else
--      await = true
--   end

--   header[frame]:draw(0, 0, 1920, 580)
   header:draw(0, 0, 1920, 580)

   bold_twc:write(xpos, 20, 'Technik Camp', 120, 1,1,1,alpha)
   bold_twc:write(xpos, 170, '2019', 120, 1,1,1,alpha)


   -- Day and clock
   local timestr = 'Day ' .. day .. ' / ' .. string.format('%02d', hour) .. sep[second % 2 + 1] .. string.format('%02d', minute)
   regular_scp:write(480, 219, timestr, 60, 1,1,1,alpha)


   -- Next talks
   bold_scp:write(xpos, 360, 'Next Blocks in Chain:', 60, 1,1,1,alpha)

   local ypos = 460
   local ydiff = 70

   for i=1, math.min(#next_talks, 8) do
      -- font color
      local r = next_talks[i]['color'][1]
      local g = next_talks[i]['color'][2]
      local b = next_talks[i]['color'][3]

      regular_scp:write(xpos, ypos,
                        next_talks[i]['starttime'],
                        50, 1,1,1,alpha)

      regular_scp:write(xpos + 210, ypos,
                        '@' .. next_talks[i]["room"],
                        50, 1,1,1,alpha)

      regular_scp:write(xpos + 350, ypos,
                        '->',
                        50, 1,1,1,alpha)

      local tparts = wrap(next_talks[i]["title"], 38)

      for _, part in pairs(tparts) do
         regular_scp:write(xpos + 470, ypos,
                           part,
                           50, r,g,b,alpha)
         ypos = ypos + ydiff

         -- Cut of if too large for screen
         if ypos > 1000 then
            break
         end
      end

      -- Cut of if too large for screen
      if ypos > 1000 then
         break
      end
   end

   -- Room lookup table
   regular_scp:write(xpos, 1028,
   'HBK: Vortr\xe4ge HBK Geb\xe4ude  /  WS: Workshop HBK Geb\xe4ude / FR: Feuerstelle  /  DA: Unterm Vordach  /  GB: Gartenbaugeb\xe4ude',
    30, 1,1,1,alpha)
end


util.file_watch("events_ts.json",
                function(content)
                   talks = json.decode(content)
                   print("Found " .. #talks .. " talks")
                   update_next_talks()
                end
)


util.data_mapper{
   ["day/set"] = function(curday)
      day = tonumber(curday)
   end;
   ["hour/set"] = function(curhour)
      hour = tonumber(curhour)
   end;
   ["minute/set"] = function(curminute)
      minute = tonumber(curminute)
   end;
   ["second/set"] = function(cursecond)
      second = tonumber(cursecond)
   end;
   ["unixtime/set"] = function(curts)
      unixtime = tonumber(curts)
      update_next_talks()
   end;
}
