local awful = require 'awful'
local gears = require 'gears'

local command = "df --output=pcent / | tail -n 1 | sed 's/%//g' | xargs"

gears.timer {
  timeout = 30,
  call_now = true,
  autostart = true,
  callback = function ()
    awful.spawn.easy_async_with_shell(command, function (usage)
      awesome.emit_signal('disk::usage', usage)
    end)
  end
}