local awful   = require('awful')
local naughty = require('naughty')
local ruled   = require('ruled')
local wibox   = require('wibox')
local theme   = require('beautiful')
local gears   = require('gears')

local notification_list = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = 16
}

--- Notifications
ruled.notification.connect_signal('request::rules', function()
  -- All notifications will match this rule.
  ruled.notification.append_rule({
    rule = nil,
    properties = {
      screen           = awful.screen.preferred,
      implicit_timeout = 5
    }
  })
end)

---comment
---@param n naughty.notification
local function create_notification (n)
  local notif_margins = theme.notification_margin or 8

  local w = wibox.widget {
    forced_width = theme.notification_width or 256,
    forced_height = theme.notification_height or theme.notification_icon_size and (theme.notification_icon_size + notif_margins * 2) or (96 + notif_margins * 2),
    widget = wibox.container.margin,
    margins = notif_margins,
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = notif_margins,
      n.icon and {
        forced_width = theme.notification_icon_size,
        widget = wibox.container.place,
        valign = 'center',
        {
          widget = wibox.widget.imagebox,
          image = gears.surface.crop_surface {
            ratio = 1,
            surface = n.icon
          }
        }
      },
      {
        forced_width = (theme.notification_width or 256) - (notif_margins - (theme.notification_icon_size or 96)),
        widget = wibox.container.place,
        valign = 'center',
        {
          layout = wibox.layout.fixed.vertical,
          spacing = notif_margins,
          {
            widget = wibox.widget.textbox,
            markup = '<b>'..n.title..'</b>',
            font = theme.notification_font .. ' ' .. theme.base_size * 1.1,
            align = 'center',
          },
          {
            widget = wibox.widget.textbox,
            markup = '<i>'..n.message..'</i>',
            font = theme.notification_font .. ' ' .. theme.base_size,
            align = 'center',
          },
        }
      }
    },
  }

  w:add_button(awful.button {
    button = 1,
    on_press = function ()
      notification_list:remove_widgets(w)
    end
  })

  gears.timer {
    single_shot = true,
    timeout = 5,
    autostart = true,
    callback = function ()
      notification_list:remove_widgets(w)
    end
  }

  notification_list:add(w)
end

naughty.connect_signal('request::display', function(n)
  create_notification(n)
end)

awful.popup {
  placement = awful.placement.top_right,
  widget = notification_list,
  ontop = true,
  visible = true
}