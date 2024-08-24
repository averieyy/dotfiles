local awful = require 'awful'
local wibox = require 'wibox'
local theme = require 'beautiful'
local gears = require 'gears'
local dpi = theme.xresources.apply_dpi

-- Create tasklist
local function create_tasklist (s)
  local layout = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
  }

  local outer = wibox.widget {
    widget = wibox.container.margin,
    margins = dpi(4),
    layout
  }

  local function hide ()
    outer.visible = false
  end

  local function show ()
    outer.visible = true
  end

  local function update ()
    layout:reset()

    local t = s.selected_tag

    if not t then 
      return hide()
    end

    local clients = t:clients()

    local f = client.focus

    show()

    for _, c in ipairs(clients) do
      if not f then break end
      local in_focus = c.pid == f.pid

      local instance = wibox.widget {
        layout = wibox.layout.fixed.vertical,
        forced_width = dpi(32),
        forced_height = dpi(32),
        {
          widget = wibox.container.margin,
          margins = dpi(2),
          {
            {
              widget = wibox.widget.imagebox,
              forced_height = dpi(24),
              forced_width = dpi(24),
              
              halign = true,
              image = c.icon,
            },
            widget = wibox.container.place,
            halign = 'center'
          }
        },
        {
          widget = wibox.container.place,
          halign = 'center',
          {
            align = 'center',
            widget = wibox.container.background,
            bg = theme.emphasis,
            forced_height = dpi(4),
            forced_width = dpi(in_focus and 12 or 6),
            shape = gears.shape.rounded_bar,
          }
        }
      }

      -- Focus
      instance:add_button (awful.button {
        button = 1,
        on_press = function () c:jump_to() end
      })

      -- Close
      instance:add_button (awful.button {
        button = 2,
        on_press = function () c:kill() end
      })

      layout:add (instance)
    end
  end
  
  update()

  client.connect_signal('manage', update)
  client.connect_signal('focus', update)
  client.connect_signal('properties::name', update)
  client.connect_signal('unfocus', update)

  return {
    hide = hide,
    show = show,
    tasklist = outer
  }
end

-- Setup an appbar for a specific screen
return function (s)
  s.appbar = create_tasklist(s)

  s.appbar.w = awful.popup {
    widget = s.appbar.tasklist,
    screen = s,
    ontop = true,
    bg = theme.bg_focus,
    placement = awful.placement.bottom,
  }
end