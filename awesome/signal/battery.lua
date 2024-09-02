local gears = require 'gears'

local battery_file = '/sys/class/power_supply/BAT1/capacity'

gears.timer {
  timeout = 5,
  call_now = true,
  autostart = true,
  callback = function ()
    local f = io.open(battery_file, 'r')
    if not f then return end
    local capacity = f:read("n")
    awesome.emit_signal('battery::capacity', capacity)
    f:close()
  end
}