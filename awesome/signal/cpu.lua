local awful = require 'awful'
local gears = require 'gears'
local naughty = require 'naughty'

local command = [[grep 'cpu' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}']]

gears.timer {
  timeout = 5,
  call_now = true,
  autostart = true,
  callback = function ()
    awful.spawn.easy_async_with_shell(command, function (cpu)
      awesome.emit_signal('cpu::percent', cpu)
    end)
  end
}