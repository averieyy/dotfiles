--------------------------------------
--       Base awesome "theme"       --
--    (without colours or fonts)    --
-- ((or anything else theme-y lol)) --
--------------------------------------

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local theme = {}

theme.useless_gap = dpi(8)

-- i dislike borders.
theme.border_width              = dpi(0)
theme.notification_border_width = dpi(0)

theme.menu_submenu = ">  "
theme.menu_height  = dpi(30)
theme.menu_width   = dpi(150)

return theme