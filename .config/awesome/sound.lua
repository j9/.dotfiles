-- sound.lua
-- original from fest with my modifications
 
local M = {}
local naughty = require("naughty")
local awful = require("awful")
 
-- Helpers 
function print_volume(amixer_result, vol_icon)
  i, t, vol = string.find(amixer_result, "%[(%d+.)%]")
  if vol then
    generic_print(string.format("Volume: %s", vol), vol_icon)
  end
end


function generic_print(notify_text, vol_icon)
    naughty.notify({text=notify_text, timeout=0.5,
                    icon=vol_icon})
end

 
-- Toggles mute, shows notification about current state of sound
function M.toggle_mute()
  res = awful.util.pread("amixer set Master toggle")
  mute_icon = "spkr_03"
  if string.find(res, "%[on%]") then
    generic_print("Sound on!", mute_icon)
  else
    generic_print("Sound off!", mute_icon)
  end
end
 
 
function M.vol_up()
  res = awful.util.pread("amixer -c 0 set Master playback 5dB+")
  icon = "spkr_01"
  print_volume(res, icon)      
end


function M.vol_down()
  res = awful.util.pread("amixer -c 0 set Master playback 5dB-")
  icon = "spkr_02"
  print_volume(res, icon)
end

return M
 
-- end of sound.lua
