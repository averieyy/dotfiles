local wibox = require 'wibox'
local awful = require 'awful'
local theme = require 'beautiful'
local gears = require 'gears'
local naughty = require 'naughty'

local helpers = {}

---comment
---@param markup string
---@param func function
---@param bg string
---@param fg string
---@param shape gears.shape | nil
---@return wibox.widget
function helpers.create_button (markup, func, bg, fg, shape)
  return wibox.widget {
    widget = wibox.container.background,
    bg = bg or theme.bg_dark,
    fg = fg or theme.fg_normal,
    shape = shape or nil,
    {
      widget = wibox.container.margin,
      margins = 8,
      {
        widget = wibox.container.place,
        align = 'center',
        {
          widget = wibox.widget.textbox,
          markup = markup
        }
      }
    },
    buttons = gears.table.join {awful.button {
      button = 1,
      on_press = func
    }}
  }
end

---Create a slider with setup function and updates
---@param icon string
---@param update function
---@param bg string
---@param fg string
---@param icon_colour string
---@param bar_width number
---@param height number
---@param icon_size_multiplier number | nil
---@return wibox.widget
function helpers.create_slider(icon, update, bg, fg, icon_colour, bar_width, height, icon_size_multiplier)
  local bar = wibox.widget {
    widget = wibox.widget.slider,
    minimum = 0,
    maximum = 100,
    handle_width = height,
    handle_shape = gears.shape.circle,
    handle_color = fg,
    bar_color = bg,
    bar_active_color = fg,
    bar_shape = gears.shape.rounded_bar,
    forced_width = bar_width,
    forced_height = height
  }

  local offset_width = bar_width - height

  local icon_widget = wibox.widget {
    widget = wibox.container.margin,
    {
      layout = wibox.layout.fixed.horizontal,
      {
        forced_width = height,
        forced_height = height,
        widget = wibox.widget.textbox,
        text = icon,
        font = theme.symbol_font .. ' ' .. height * (icon_size_multiplier or (1 / 2)),
        align = 'center'
      }
    }
  }

  function icon_widget:update (value)
    icon_widget.left = offset_width * value / 100
  end

  bar:connect_signal('property::value', function (_, v)
    icon_widget:update(v)
    update(v)
  end)

  return wibox.widget {
    widget = wibox.container.background,
    -- bg = bg or theme.bg_dark,
    fg = icon_colour or theme.bg_dark,
    forced_height = height,
    {
      layout = wibox.layout.stack,
      bar,
      icon_widget,
    },
    set_value = function (_, value)
      bar.value = tonumber(value)
    end
  }
end

function helpers.save_image_async_curl(url, filepath, callback)
  awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", url, filepath), {
    exit=callback
  })
end

return helpers