local theme = require 'beautiful'
local wibox = require 'wibox'
local gears = require 'gears'

return function (width, totalmargins)

  local opacitystep = 0

  local w = wibox.widget {
    forced_width = width,
    forced_height = width / 3,
    widget = wibox.container.place,
    align = 'center',
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = totalmargins / 3,
      {
        widget = wibox.widget.textbox,
        id = 'hour',
        text = '10',
        font = theme.base_font .. ' 24'
      },
      {
        widget = wibox.widget.textbox,
        id = ':',
        text = ':',
        font = theme.base_font .. ' 20'
      },
      {
        widget = wibox.widget.textbox,
        id = 'minutes',
        text = '10',
        font = theme.base_font .. ' 24'
      },
    },
    set_time = function (self, time)
      local hour = self:get_children_by_id('hour')[1]
      local mins = self:get_children_by_id('minutes')[1]

      hour.text = time.hour
      mins.text = time.min
    end,
    blink = function (self, opacitystep)
      local sep = self:get_children_by_id(':')[1]
      local op = math.sin(opacitystep / 20 * math.pi)
      sep.opacity = op > .2 and op or 0
    end
  }

  gears.timer {
    timeout = .1,
    autostart = true,
    callback = function ()
      if opacitystep % 20 == 0 then
        w.time = os.date("*t")
      end
      opacitystep = (opacitystep + 1) % 20
      w:blink(opacitystep)
    end
  }

  return w
end