local awful = require 'awful'
local wibox = require 'wibox'
local theme = require 'beautiful'
local gears = require 'gears'

return function (s)
  s.timebox = {}
  
  s.mainwidget = wibox.widget {
    widget = wibox.container.margin,
    margins = theme.useless_gap * 1.5,
    {
      widget = wibox.widget.textclock,
      format = '%H:%M',
      font = theme.base_font .. ' 10',
    }
  }

  s.timebox.popup = awful.popup {
    widget = s.mainwidget,
    screen = s,
    placement = awful.placement.centered,
    visible = false,
    ontop = true,
  }

  s.mainwidget:add_button(awful.button {
    modifiers = { "Any" },
    on_press = function ()
      s.timebox.popup.visible = false
      s.timebox.timer:stop()
    end
  })

  function s.timebox:show ()

    s.timebox.popup.visible = not s.timebox.popup.visible

    if s.timebox.timer then
      s.timebox.timer:stop()
    end

    s.timebox.timer = gears.timer {
      timeout = 5,
      autostart = true,
      single_shot = true,
      callback = function ()
        s.timebox.popup.visible = false
      end,
    }
  end
end