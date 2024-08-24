local awful = require 'awful'
local gears = require 'gears'
local naughty = require 'naughty'

local command = [[uptime -p | grep ' .*' --only-matching | sed 's/\ //']]

gears.timer {
  timeout = 60,
  call_now = true,
  autostart = true,
  callback = function ()
    awful.spawn.easy_async_with_shell(command, function (uptime)
      awesome.emit_signal('uptime::string', uptime)
    end)
  end
}