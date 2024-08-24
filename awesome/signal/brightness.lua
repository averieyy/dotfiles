local awful = require 'awful'
local gears = require 'gears'

local getmax = 'brightnessctl m'

local command = 'brightnessctl g'

awful.spawn.easy_async_with_shell(getmax, function (value)
  local max = tonumber(value)

  gears.timer {
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function ()
      awful.spawn.easy_async_with_shell(command, function (v)
        local brightness = tonumber(v)
        if not brightness then return end
        awesome.emit_signal('brightness::value', brightness / (max or brightness) * 100)
      end)
    end
  }
end)