local awful = require('awful')

local mod    = require('binds.mod')
local modkey = mod.modkey

--- Client keybindings.
client.connect_signal('request::default_keybindings', function()
   awful.keyboard.append_client_keybindings({
      -- Client state management.
      awful.key({ modkey }, 'f',
         function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
         end, { description = 'toggle fullscreen', group = 'client' }),
      awful.key({ modkey }, 'w', function(c) c:kill() end,
         { description = 'close', group = 'client' }),
      awful.key({ modkey }, 's', awful.client.floating.toggle,
         { description = 'toggle floating', group = 'client' }),

      -- Client position in tiling management.
      awful.key({ modkey }, 'n', function(c) c.ontop = not c.ontop end,
         { description = 'toggle keep on top', group = 'client' })
   })
end)