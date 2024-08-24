local beautiful     = require('beautiful')
local gears         = require('gears')
local rnotification = require 'ruled.notification'
local base          = require 'theme.base'
local json          = require 'module.json'

local themes_fs = gears.filesystem.get_configuration_dir() .. 'theme/'

-- Themes define colors, icons, font and wallpapers.

local theme = {}

function theme.load_theme_file (filename)
  local f = io.open(filename)
  if not f then return end
  local contents = f:read('a')

  local th = json.decode(contents)
  local full_theme = {
    -- Custom properties
    symbol_font = th.symbolsfont,
    base_font   = th.basefont,
    base_size   = th.fontsize,
    font        = th.basefont .. ' ' .. th.fontsize,

    red         = th.colours.red,
    green       = th.colours.green,
    emphasis    = th.colours.emphasis,
    bg          = th.colours.bg,
    bg_dark     = th.colours.bg_dark,
    bg_light    = th.colours.bg_light,
    fg          = th.colours.fg,
    fg_subtext  = th.colours.fg_subtext,
    fg_emphasis = th.colours.fg_emphasis,

    -- Actual awesomewm theming
    bg_normal   = th.colours.bg_dark,
    bg_focus    = th.colours.bg,
    bg_urgent   = th.colours.red,
    bg_minimize = th.colours.bg_dark,
    bg_systray  = th.colours.bg,

    --
    fg_normal   = th.colours.fg_dark,
    fg_focus    = th.colours.fg,
    fg_urgent   = th.colours.fg,
    fg_minimize = th.colours.fg_dark,

    notification_font         = th.basefont,
    notification_border_color = th.colours.bg_dark,

    menu_bg_focus = th.colours.emphasis,
    menu_fg_focus = th.colours.bg,

    wallpaper = th.wallpaper,

    icon_theme = th.icon_theme,
  }

  rnotification.connect_signal('request::rules', function()
    rnotification.append_rule {
      rule       = { urgency = 'critical' },
      properties = { bg = full_theme.red, fg = full_theme.fg }
    }
  end)

  beautiful.init(
    gears.table.join(base, full_theme)
  )
end

function theme.get_theme_configs ()
  local configfile = io.open(themes_fs .. 'themes.json')
  if not configfile then return nil end
  local contents = configfile:read("a")
  return json.decode(contents)
end

function theme.get_themes ()
  local about = theme.get_theme_configs()
  if not about then return nil end
  return about.themes
end

local themeconfigs = theme.get_theme_configs()

-- Preferably the selected theme, then the first indexed theme, and if no theme exists, the default theme
local currenttheme = themeconfigs and themes_fs .. (themeconfigs.current
  or themeconfigs.themes[1])
  or gears.filesystem.get_themes_dir() .. 'default/init.lua'

theme.load_theme_file(currenttheme)

return theme
