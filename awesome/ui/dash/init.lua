local awful = require 'awful'
local wibox = require 'wibox'
local user_widget = require 'ui.dash.user'
local sysinfo = require 'ui.dash.sysinfo'
local music   = require 'ui.dash.music'
local sliders = require 'ui.dash.sliders'

local dash_width = 400
local dash_margins = 16

return function (s)
  s.dash = {}

  s.dash.w = awful.popup {
    screen = s,
    placement = awful.placement.bottom_left,
    ontop = true,
    visible = false,
    widget = {
      forced_width = dash_width,
      widget = wibox.container.margin,
      margins = dash_margins,
      {
        layout = wibox.layout.fixed.vertical,
        spacing = 16,
        user_widget,
        music (dash_width, dash_margins),
        sysinfo (dash_width, dash_margins),
        sliders (dash_width, dash_margins),
      }
    }
  }

  function s.dash:toggle ()
    s.dash.w.visible = not s.dash.w.visible
  end
end