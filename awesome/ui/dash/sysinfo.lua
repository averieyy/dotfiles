local theme = require 'beautiful'
local wibox = require 'wibox'
local gears = require 'gears'
local user = require 'config.user'
local naughty = require 'naughty'

local function exists (file)
  local f = io.open(file)
  if not f then return false else
    f:close()
    return true
  end
end

local battery_connected = exists('/sys/class/power_supply/BAT1/capacity')

require 'signal.cpu'
require 'signal.disk'
require 'signal.ram'
if battery_connected then
  require 'signal.battery'
end


---comment
---@param icon string
---@param bg string
---@param fg string
---@param prog_fg string
---@param prog_bg string
---@param width number
---@return wibox.widget
local function progressbar (name, icon, bg, fg, prog_fg, prog_bg, width)
  local w = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    {
      widget = wibox.container.background,
      bg = bg,
      fg = theme.subtext,
      {
        widget = wibox.container.margin,
        margins = 8,
        {
          widget = wibox.widget.textbox,
          markup = '<i>' .. name .. '</i>',
          -- halign = 'center',
          font = theme.base_font .. ' 9'
        }
      }
    },
    {
      widget = wibox.container.background,
      fg = fg,
      bg = bg,
      forced_height = width,
      forced_width = width,
      {
        widget = wibox.container.margin,
        margins = 8,
        {
          id = 'chart',
          widget = wibox.container.arcchart,
          min_value = 0,
          max_value = 100,
          start_angle = math.pi * 1.5,
          rounded_edge = true,
          colors = {
            prog_fg
          },
          bg = prog_bg or theme.bg_dark,
          thickness = 10,
          {
            widget = wibox.container.place,
            align = 'center',
            {
              widget = wibox.widget.textbox,
              text = icon,
              font = theme.symbol_font .. ' 32'
            }
          }
        }
      }
    },
    set_value = function (self, value)
      self:get_children_by_id('chart')[1].value = value
    end
  }

  return w
end

return function (width, margins)
  local innerwidth = width - (margins * 2)
  local widget_spacing = 16
  local widget_margins = math.max(0, widget_spacing - margins)
  local columns = 2
  local progwidth = (innerwidth - widget_spacing - (widget_margins * 2)) / columns

  local cpu = progressbar('cpu', '󰍛', theme.bg_dark, theme.fg_focus, theme.emphasis, theme.bg, progwidth)
  local ram = progressbar('ram', '', theme.bg_dark, theme.fg_focus, theme.emphasis, theme.bg, progwidth)
  local disk = progressbar('disk', '󰋊', theme.bg_dark, theme.fg_focus, theme.emphasis, theme.bg, progwidth)
  local battery = battery_connected and progressbar('bat', '󰁿', theme.bg_dark, theme.fg_focus, theme.emphasis, theme.bg, progwidth)

  awesome.connect_signal('cpu::percent', function (value)
    cpu.value = value
  end)

  awesome.connect_signal('disk::usage', function (value)
    disk.value = value
  end)

  awesome.connect_signal('ram::percent', function (value)
    ram.value = value
  end)

  if battery_connected then
    awesome.connect_signal('battery::capacity', function (value)
      battery.value = value
    end)
  end

  return wibox.widget {
    widget = wibox.container.margin,
    margins = widget_margins,
    {
      column_count = columns,
      layout = wibox.layout.grid,
      spacing = widget_spacing,
      cpu,
      ram,
      disk,
      battery,
    }
  }
end