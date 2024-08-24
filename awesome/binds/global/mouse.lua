local awful = require('awful')

local widgets = require('ui')

awful.mouse.snap.edge_enabled = false

--- Global mouse bindings
awful.mouse.append_global_mousebindings({
   awful.button(nil, 3, function() widgets.menu.main:toggle() end),
   awful.button(nil, 4, awful.tag.viewprev),
   awful.button(nil, 5, awful.tag.viewnext)
})
