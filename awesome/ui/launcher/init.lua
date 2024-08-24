local menu_gen = require("menubar.menu_gen")
local theme = require("beautiful")
local wibox = require("wibox")
local awful = require("awful")
local gfs = require("gears.filesystem")
local gstring = require("gears.string")
local dpi = theme.xresources.apply_dpi

local itemheight = 38

return function (s)

  s.launcher = {
    search = "", -- current search term
    prompt = awful.widget.prompt(),
    entrymenu = wibox.layout.fixed.vertical()
  }

  -- Launcher settings
  s.launcher.screen_width = s.geometry.width
  s.launcher.screen_height = s.geometry.height
  s.launcher.height = s.launcher.screen_height / 2
  s.launcher.prompt_text = "<i><b>$ </b></i>"

  local current_item = 1
  local count_table = {}
  local raw_entries = {}
  local menu_entries = {}

  -- load raw menu entries
  menu_gen.generate(function (entries)
    raw_entries = entries
  end)

  local fg_color = theme.launcher_fg_normal or theme.menu_fg_normal or theme.fg_normal
  local bg_color = theme.launcher_bg_normal or theme.menu_bg_normal or theme.bg_normal
  local fg_focus_color = theme.launcher_fg_focus or theme.menu_fg_focus or theme.bg_focus
  local bg_focus_color = theme.launcher_bg_focus or theme.menu_bg_focus or theme.bg_focus

  local boxlayout = wibox.layout {
    layout = wibox.layout.fixed.vertical,
    forced_width = s.launcher.screen_width / 2,
    forced_height = s.launcher.height,
  }

  boxlayout:add({
    widget = wibox.container.margin,
    margins = dpi(10),
    forced_height = dpi(itemheight),
    s.launcher.prompt
  })

  boxlayout:add(s.launcher.entrymenu)

  s.launcher.w = awful.popup {
    widget = boxlayout,
    fg = fg_color,
    bg = bg_color,
    -- width = s.launcher.screen_width / 2,
    -- height = s.launcher.screen_height / 2,
    -- x = s.launcher.screen_width / 4,
    -- y = s.launcher.screen_height / 4,
    placement = awful.placement.centered,
    screen = s,
    ontop = true,
    visible = false
  }

  -- Ethically stolen from the menubar library
  local function load_count_table()
    count_table = {}
    local count_file_name = gfs.get_cache_dir() .. "/menu_count_file"
    local count_file = io.open (count_file_name, "r")
    if count_file then
      for line in count_file:lines() do
        local name, count = string.match(line, "([^;]+);([^;]+)")
        if name ~= nil and count ~= nil then
          count_table[name] = count
        end
      end
      count_file:close()
    end
  end

  local function write_count_table(count_table)
    count_table = count_table or count_table
    local count_file_name = gfs.get_cache_dir() .. "/menu_count_file"
    local count_file = assert(io.open(count_file_name, "w"))
    for name, count in pairs(count_table) do
      local str = string.format("%s;%d\n", name, count)
      count_file:write(str)
    end
    count_file:close()
  end

  function s.launcher.get_entries()
    local pattern = gstring.query_to_pattern(s.launcher.search or '')
    local result = {}
    menu_entries = {}

    for _, entry in ipairs(raw_entries or {}) do

      local text = entry.name

      if string.match(text, pattern) then

        local weight = 0
        local prio = 0

        -- get use count from count_table if present
        -- and use it as weight
        if string.len(pattern) > 0 and count_table[text] ~= nil then
          weight = tonumber(count_table[text]) or 0
        end

        -- check for prefix match
        if string.match(text, "^" .. pattern) then
          -- increase default priority
          prio = 1
        else
          prio = 0
        end

        table.insert (result, {
          weight = weight,
          prio = prio,
          name = entry.name,
          cmdline = entry.cmdline,
        })
      end
    end

    table.sort(result, function (a, b)
      if a.prio == b.prio then
        return a.weight > b.weight
      end
      return a.prio > b.prio
    end)

    menu_entries = result

    if #menu_entries > 0 then
      -- Insert a run item value as the last choice
      table.insert(menu_entries, { name = "Exec: " .. s.launcher.search, cmdline = s.launcher.search })

    else
      table.insert(menu_entries, { name = "", cmdline = s.launcher.search })
    end


    if current_item > #menu_entries then
      current_item = 1
    end
    menu_entries[current_item].focused = true
  end

  local function update_entries ()
    s.launcher.get_entries()

    local freearea = s.launcher.height - dpi(itemheight)
    local totalcount = freearea / dpi(itemheight)

    s.launcher.entrymenu:reset()

    for i, entry in ipairs(menu_entries) do

      if i < totalcount then

        s.launcher.entrymenu:add {
          forced_height = dpi(itemheight),
          widget = wibox.container.background,
          bg = (entry.focused and bg_focus_color) or bg_color,
          fg = (entry.focused and fg_focus_color) or fg_color,
          {
            widget = wibox.container.margin,
            margins = 10,
            {
              widget = wibox.widget.textbox,
              markup = '<b>' .. entry.name .. '</b>'
            }
          }
        }
      end
    end
  end

  local function keypress (mod, key, comm)
    if key == "Up" then
      current_item = math.max(1, current_item - 1)

      update_entries()

      return true
    elseif key == "Down" then

      current_item = current_item + 1

      update_entries()

      return true
    elseif key == "Return" or key == "KP_Enter" then
      awful.spawn(menu_entries[current_item].cmdline)

      load_count_table()

      local curname = menu_entries[current_item].name
      count_table[curname] = (count_table[curname] or 0) + 1

      write_count_table(count_table)

      -- let the prompt do the rest
      return false
    end

    return false
  end

  function s.launcher.show()
    s.launcher.w.visible = true
    load_count_table()
    update_entries()
    awful.prompt.run {
      prompt = s.launcher.prompt_text,
      textbox = s.launcher.prompt.widget,
      done_callback = function ()
        s.launcher.hide()
        s.launcher.search = ""
      end,
      completion_callback = awful.completion.shell,
      changed_callback = function (query)
        s.launcher.search = query

        update_entries()
      end,
      keypressed_callback = keypress,
      history_path = gfs.get_cache_dir() .. "/history_menu",
    }
  end

  function s.launcher.hide()
    s.launcher.w.visible = false
    if count_table then
      write_count_table(count_table)
    end
  end

  -- testing
  function s.launcher.toggle ()
    if s.launcher.w.visible then
      s.launcher.hide()
    else
      s.launcher.show()
    end
  end
end