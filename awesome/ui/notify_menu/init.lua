local naughty = require 'naughty'
local wibox = require 'wibox'
local awful = require 'awful'
local theme = require 'beautiful'
local helpers = require 'helpers'
local dpi = theme.xresources.apply_dpi

local testing = false

return function (s)
  -- Widget width
  local width = 386
  local height = s.geometry.height

  s.notify_menu = {}

  s.notify_menu.close_button = wibox.widget {
    widget = wibox.container.margin,
    margins = dpi(16),
    {
      widget = wibox.container.background,
      fg = theme.red,
      forced_height = 48,
      forced_width = 48,
      {
        widget = wibox.container.place,
        align = 'center',
        forced_height = 48,
        forced_width = 48,
        {
          widget = wibox.widget.textbox,
          markup = '󰅖',
          font = theme.symbol_font .. ' 20',
        }
      }
    }
  }

  s.notify_menu.notification_list = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(16)
  }

  s.notify_menu.outer_notification_list = wibox.widget {
    widget = wibox.container.margin,
    margins = dpi(16),
    s.notify_menu.notification_list
  }

  s.notify_menu.clear_all = helpers.create_button("<b>Clear all</b>", function ()
    s.notify_menu.notifications = {}
    s.notify_menu.notification_list:reset()
  end, theme.red, theme.fg, nil)

  local function add_notification (n)

    local has_image = n.icon ~= nil

    local actions = wibox.widget {
      layout = wibox.layout.flex.horizontal,
      spacing = 8
    }

    for _, a in ipairs(n.actions) do
      actions:add (helpers.create_button('<b>' .. a.name .. '</b>', function () a:invoke(n) end, theme.emphasis, theme.fg_emphasis))
    end

    local body = wibox.widget {
      widget = wibox.container.background,
      bg = theme.darker_black,
      {
        widget = wibox.container.margin,
        margins = dpi(16),
        {
          layout = wibox.layout.fixed.vertical,
          spacing = 8,
          {
            widget = wibox.container.place,
            align = 'center',
            {
              widget = wibox.widget.textbox,
              text = #n.message == 0 and n.title or n.message,
              font = theme.base_font .. ' 10'
            }
          },
          has_image and {
            widget = wibox.widget.imagebox,
            image = n.icon
          } or nil,
          actions
        }
      }
    }

    local clear_notification = wibox.widget {
      widget = wibox.container.background,
      fg = n.urgency == 'critical' and theme.fg or theme.bg,
      {
        widget = wibox.widget.textbox,
        text = '󰅖',
        font = theme.symbol_font .. ' 16'
      }
    }

    local w = wibox.widget {
      -- Title bar
      {
        widget = wibox.container.background,
        bg = n.urgency == 'critical' and theme.red or theme.emphasis,
        fg = n.urgency == 'critical' and theme.fg or theme.fg_emphasis,
        {
          widget = wibox.container.margin,
          margins = dpi(8),
          {
            layout = wibox.layout.align.horizontal,
            {
              widget = wibox.widget.textbox,
              markup = #n.message == 0 and '<b>Notification</b>' or n.title,
              font = theme.base_font .. ' 12'
            },
            nil,
            clear_notification,
          },
        }
      },
      body,
      layout = wibox.layout.fixed.vertical,
    }

    w:add_button(awful.button {
      button = 2,
      on_press = function ()
        s.notify_menu.notification_list:remove_widgets(w)
      end
    })

    clear_notification:add_button(awful.button {
      button = 1,
      on_press = function ()
        s.notify_menu.notification_list:remove_widgets(w)
      end
    })

    s.notify_menu.notification_list:add(w)
  end

  naughty.connect_signal("request::display", add_notification)

  s.notify_menu.test_buttons = {}

  if testing then
    table.insert(s.notify_menu.test_buttons, helpers.create_button("<b>Test urgent</b>",
    function ()
      naughty.notify {
        title = 'This is a test notification',
        urgency = "critical",
      }
    end, theme.bg_dark, theme.fg, nil))

    table.insert(s.notify_menu.test_buttons, helpers.create_button("<b>Test messages</b>",
    function ()
      naughty.notify {
        title = 'Message test',
        message = 'This should be shown in the body'
      }
    end, theme.bg_dark, theme.fg, nil))

    
    table.insert(s.notify_menu.test_buttons, helpers.create_button("<b>Test actions</b>",
    function ()
      naughty.notify {
        title = 'Action test',
        message = 'Actions should be under this string',
        actions = {
          naughty.action {
            name = 'Nah',
          },
          naughty.action {
            name = 'ye',
          }
        }
      }
    end, theme.bg_dark, theme.fg, nil))
  end

  -- Main popup
  s.notify_menu.popup = awful.popup {
    screen = s,
    ontop = true,
    visible = false,
    width = width,
    height = height,
    placement = awful.placement.right,
    -- x = x,
    -- y = y,
    widget = {
      forced_height = height,
      forced_width = width,
      layout = wibox.layout.align.vertical,
      {
        layout = wibox.layout.align.horizontal,
        {
          widget = wibox.container.margin,
          margins = dpi(16),
          {
            widget = wibox.widget.textbox,
            markup = '<b>Notifications</b>',
            font = theme.base_font .. ' 16'
          }
        },
        nil,
        s.notify_menu.close_button
      },
      {
        widget = wibox.container.background,
        bg = theme.bg_focus,
        {
          widget = wibox.container.margin,
          margins = dpi(16),
          layout = wibox.layout.align.vertical,
          nil,
          s.notify_menu.outer_notification_list,
          {
            widget = wibox.container.margin,
            margins = 8,
            {
              layout = wibox.layout.flex.horizontal,
              spacing = 8,
              s.notify_menu.clear_all,
              table.unpack(s.notify_menu.test_buttons) -- list will be empty if not testing
            }
          }
        }
      },
      nil
    }
  }

  function s.notify_menu:toggle ()
    s.notify_menu.popup.visible = not s.notify_menu.popup.visible
  end

  function s.notify_menu:hide ()
    s.notify_menu.popup.visible = false
  end

  s.notify_menu.close_button:add_button(awful.button {
    on_press = function () s.notify_menu:hide() end,
    button = 1
  })
end