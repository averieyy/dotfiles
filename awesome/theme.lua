local themes_path = os.getenv("HOME") .. "/.config/awesome/"
local default_theme_path = require("gears.filesystem").get_themes_dir() .. "default/"
local dpi = require("beautiful.xresources").apply_dpi
local preferences = require("user")

local theme = {}


theme.wallpaper = ""
theme.font = "Jetbrains Mono 10"

-- Colours
theme.fg_normal = "#bac2de"
theme.fg_focus = "#cdd6f4"
theme.fg_urgent = "#fab387"
theme.bg_normal = "#1e1e2e"
theme.bg_focus = "#11111b"
theme.bg_urgent = theme.bg_normal
theme.bg_systray = theme.bg_normal

-- Borders
theme.useless_gap = dpi(5)
theme.border_width = dpi(0)
theme.border_normal = theme.bg_normal
theme.border_focus = theme.fg_focus
theme.border_marked = theme.fg_urgent

-- Titlebars
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal

-- Icons
theme.layout_dwindle = themes_path .. "assets/dwindle.png"
theme.layout_floating = themes_path .. "assets/floating.png"
theme.layout_fullscreen = themes_path .. "assets/full.png"

theme.titlebar_close_button_focus = themes_path .. "assets/close.png"
theme.titlebar_close_button_normal = themes_path .. "assets/close.png"

theme.awesome_icon = themes_path .. "assets/logo.png"

theme.wallpaper = preferences.wallpaper or default_theme_path .. "background.png"

-- Notification
theme.notification_border_width = dpi(0)
theme.notification_border_color = "#181825"
theme.notification_bg = "#181825"
theme.notification_width = dpi(200)
theme.notification_height = dpi(75)

-- Menu
theme.menu_width = dpi(150)
theme.menu_height = dpi(32.5)
theme.menu_bg_normal = "#181825"

-- General
theme.border_radius = 10

return theme