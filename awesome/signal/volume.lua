local awful = require 'awful'
local gears = require 'gears'

local command = [[amixer sget Master | grep 'Left:' | grep '[^\[]*%' --only-matching | grep '[0-9]*' --only-matching]]

gears.timer {
  timeout = 5,
  call_now = true,
  autostart = true,
  callback = function ()
    awful.spawn.easy_async_with_shell(command, function (volume)
      awesome.emit_signal('volume::value', tonumber(volume) or 0)
    end)
  end
}