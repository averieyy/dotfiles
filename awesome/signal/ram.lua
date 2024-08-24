local awful = require 'awful'
local gears = require 'gears'

local command = "free | grep Mem | awk '{usage=$3/$2 * 100} END {print usage}'"

gears.timer {
  timeout = 5,
  call_now = true,
  autostart = true,
  callback = function ()
    awful.spawn.easy_async_with_shell(command, function (ram)
      awesome.emit_signal('ram::percent', ram)
    end)
  end
}
