local awful = require 'awful'
local wibox = require 'wibox'
local theme = require 'beautiful'

return function (s)

  local popup_width = 350
  local popup_height = 75

  return awful.popup {
    x = s.geometry.width - popup_width - 75,
    y = s.geometry.height - popup_height - 75,
    ontop = true,
    bg = "#00000000",
    widget = {
      forced_width = popup_width,
      forced_height = popup_height,
      widget = wibox.container.background,
      fg = theme.fg .. 'af',
      {
        layout = wibox.layout.flex.vertical,
        {
          widget = wibox.widget.textbox,
          text = 'Activate Linux',
          font = theme.base_font .. ' 20',
        },
        {
          widget = wibox.widget.textbox,
          text = 'Go to settings to activate Linux.',
          font = theme.base_font .. ' 12',
        }
      }
    }
  }
end