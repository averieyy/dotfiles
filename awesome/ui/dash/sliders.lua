local wibox = require 'wibox'
local helpers = require 'helpers'
local theme = require 'beautiful'
local awful = require 'awful'
local naughty = require 'naughty'

require 'signal.brightness'
require 'signal.volume'

return function (dash_width, dash_margins)

  local totalmargins = 16

  local innerwidth = dash_width - (totalmargins * 2)

  local brightness = helpers.create_slider('󰃠', function (value)
    awful.spawn.with_shell('brightnessctl s ' .. value .. '%')
  end, theme.bg, theme.emphasis, theme.fg_emphasis, innerwidth, 32)

  local volume = helpers.create_slider('󰕾', function (value)
    awful.spawn.with_shell('amixer sset Master ' .. value .. '%')
  end, theme.bg, theme.emphasis, theme.fg_emphasis, innerwidth, 32)

  awesome.connect_signal('brightness::value', function (value)
    brightness.value = value
  end)

  awesome.connect_signal('volume::value', function (value)
    volume.value = value
  end)

  return wibox.widget {
    widget = wibox.container.margin,
    margins = totalmargins - dash_margins,
    {
      layout = wibox.layout.fixed.vertical,
      spacing = 16,
      brightness,
      volume,
    }
  }
end