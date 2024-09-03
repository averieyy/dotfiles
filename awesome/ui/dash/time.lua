local theme = require 'beautiful'
local wibox = require 'wibox'
local gears = require 'gears'

return function (width, totalmargins)

  local w = wibox.widget {
    forced_width = width,
    forced_height = width / 3,
    widget = wibox.container.place,
    align = 'center',
    {
      layout = wibox.layout.fixed.vertical,
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = totalmargins / 3,
        {
          widget = wibox.container.background,
          fg = theme.emphasis,
          {
            widget = wibox.widget.textbox,
            id = 'hour',
            text = '10',
            font = theme.base_font .. ' 24'
          }
        },
        {
          widget = wibox.widget.textbox,
          text = ':',
          opacity = .5,
          font = theme.base_font .. ' 20'
        },
        {
          widget = wibox.widget.textbox,
          id = 'minutes',
          text = '10',
          font = theme.base_font .. ' 24'
        },
      },
      {
        widget = wibox.container.background,
        bg = theme.fg,
        forced_height = 3,
        shape = gears.shape.rounded_bar,
      }
    },
    set_time = function (self, time)
      local hour = self:get_children_by_id('hour')[1]
      local mins = self:get_children_by_id('minutes')[1]

      hour.text = string.format("%02d", time.hour)
      mins.text = string.format("%02d", time.min)
    end,
  }

  gears.timer {
    timeout = 1,
    autostart = true,
    callback = function ()
      w.time = os.date("*t")
    end
  }

  return w
end