---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local naughty       = require("naughty")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_configuration_dir() .. 'theme/'

naughty.notify {
  title = themes_path
}

-- color defs

-- Polar Night
local nord0 = "#2E3440" -- Polar night 1
local nord1 = "#3B4252" -- Polar night 2
local nord2 = "#434C5E" -- Polar night 3
local nord3 = "#4C566A" -- Polar night 4

-- Snow Storm
local nord4 = "#D8DEE9" -- Snow storm 1
local nord5 = "#E5E9F0" -- Snow storm 2
local nord6 = "#ECEFF4" -- Snow storm 3

-- Frost
local nord7 = "#8FBCBB" -- Frost 1
local nord8 = "#88C0D0" -- Frost 2
local nord9 = "#81A1C1" -- Frost 3
local nord10 = "#5E81AC" -- Frost 4

-- Aurora
local nord11 = "#BF616A"
local nord12 = "#D08770"
local nord13 = "#EBCB8B"
local nord14 = "#A3BE8C"
local nord15 = "#B48EAD"

local theme = {}

-- Font
theme.symbol_font = 'Nerd Symbols'
theme.base_font = 'Jetbrains Mono'
theme.base_size = '8'
theme.font = theme.base_font .. ' ' .. theme.base_size

-- Colours
theme.red = nord11
theme.green = nord14
theme.emphasis = nord8
theme.bg = nord1
theme.bg_dark = nord0
theme.bg_light = nord2
theme.fg = nord6
theme.fg_dark = nord4
theme.fg_emphasis = nord1

theme.bg_normal     = nord0
theme.bg_focus      = nord1
theme.bg_urgent     = nord11
theme.bg_minimize   = nord0
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.fg_dark
theme.fg_focus      = theme.fg
theme.fg_urgent     = theme.fg
theme.fg_minimize   = theme.fg_dark


theme.useless_gap         = dpi(8)
theme.border_width        = dpi(0)

-- Variables set for theming notifications:
theme.notification_font = theme.font
theme.notification_border_width = 0
theme.notification_border_color = nord0
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu = ">  "
theme.menu_height = dpi(30)
theme.menu_width  = dpi(150)
theme.menu_bg_focus = theme.emphasis
theme.menu_fg_focus = nord1

theme.wallpaper = "~/.config/awesome/theme/nord/background.jpg"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
  theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal('request::rules', function()
  rnotification.append_rule {
    rule       = { urgency = 'critical' },
    properties = { bg = nord11, fg = nord6 }
  }
end)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
