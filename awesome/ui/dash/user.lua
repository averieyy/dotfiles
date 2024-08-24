local theme = require 'beautiful'
local wibox = require 'wibox'
local gears = require 'gears'
local user_config = require 'config.user'
local naughty     = require 'naughty'

local user = user_config.username_override or os.getenv 'USER'
local host = user_config.hostname_override or os.getenv 'HOSTNAME'

local show_welcome_message = not host or user_config.welcome_text

require 'signal.uptime'

local w = wibox.widget {
  layout = wibox.layout.align.horizontal,
  spacing = 8,
  {
    widget = wibox.widget.imagebox,
    forced_height = 64,
    resize = true,
    clip_shape = gears.shape.circle,
    image = user_config.profile_picture or theme.wallpaper
  },
  {
    widget = wibox.container.place,
    align = 'center',
    {
      layout = wibox.layout.fixed.vertical,
      {
        align = 'center',
        widget = wibox.widget.textbox,
        text = show_welcome_message and 'Welcome, ' .. user or user .. '@' .. host,
        font = theme.base_font .. ' 12'
      },
      {
        id = 'uptime',
        align = 'center',
        widget = wibox.widget.textbox,
        font = theme.base_font .. ' 9'
      }
    }
  },
  nil,
  set_uptime = function (self, value)
    self:get_children_by_id('uptime')[1]:set_markup_silently('<i>up for ' .. value .. '</i>')
  end
}

awesome.connect_signal('uptime::string', function (value)
  w.uptime = value
end)

return w