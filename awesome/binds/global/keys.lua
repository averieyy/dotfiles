local awful = require('awful')
local naughty = require 'naughty'

local mod    = require('binds.mod')
local modkey = mod.modkey

local apps    = require('config.apps')
local widgets = require('ui')

--- Global key bindings
awful.keyboard.append_global_keybindings({
   -- General Awesome keys.
   awful.key({ modkey }, 'h', require('awful.hotkeys_popup').show_help,
      { description = 'show help', group = 'awesome' }),
   awful.key({ modkey }, 'space', function() widgets.menu.main:show() end,
      { description = 'show main menu', group = 'awesome' }),
   awful.key({ modkey, mod.ctrl  }, 'r', awesome.restart,
      { description = 'reload awesome', group = 'awesome' }),
   awful.key({ modkey, mod.ctrl }, 'q', awesome.quit,
      { description = 'quit awesome', group = 'awesome' }),
   awful.key({ modkey }, 'x', function() awful.prompt.run({
      prompt       = 'Run Lua code: ',
      textbox      = awful.screen.focused().mypromptbox.widget,
      exe_callback = awful.util.eval,
      history_path = awful.util.get_cache_dir() .. '/history_eval' })
      end, { description = 'lua execute prompt', group = 'awesome' }),
   awful.key({ modkey,           }, 'Return', function() awful.spawn(apps.terminal) end,
      { description = 'open a terminal', group = 'launcher' }),
   
   -- Run menu
   awful.key({ modkey }, 'r', function () awful.screen.focused().launcher:show() end,
         { description = 'open launcher', group = 'launcher' }),
   
   -- Time popup
   awful.key({ modkey }, 't', function () awful.screen.focused().timebox:show() end,
         { description = 'show time popup', group = 'launcher' }),
   
   -- Notification menu
   awful.key({ modkey, }, 'n', function () awful.screen.focused().notify_menu:toggle() end,
      { description = 'open notification menu', group = 'launcher' }),

   -- Dashboard
   awful.key({ modkey, }, 'd', function () awful.screen.focused().dash:toggle() end,
      { description = 'open dashboard', group = 'launcher' }),
   
   -- Lock screen
   awful.key({ modkey, }, 'l', function () awful.spawn.with_shell('xsecurelock') end,
      { description = 'lock screen', group = 'launcher' }),

   -- Tags related keybindings.
   awful.key({ modkey,           }, 'Left', awful.tag.viewprev,
      { description = 'view previous', group = 'tag' }),
   awful.key({ modkey,           }, 'Right', awful.tag.viewnext,
      { description = 'view next', group = 'tag' }),
   awful.key({ modkey,           }, 'Escape', awful.tag.history.restore,
      { description = 'go back', group = 'tag' }),

   -- Focus related keybindings.
   awful.key({ mod.alt,           }, 'Tab', function() awful.client.focus.byidx( 1) end,
      { description = 'focus next by index', group = 'client' }),
   awful.key({ mod.alt, mod.shift }, 'Tab', function() awful.client.focus.byidx(-1) end,
      { description = 'focus previous by index', group = 'client'}),
   awful.key({ modkey }, 'Tab', function() awful.screen.focus_relative( 1) end,
      { description = 'focus the next screen', group = 'screen' }),
   awful.key({ modkey, mod.shift }, 'Tab', function() awful.screen.focus_relative(-1) end,
      { description = 'focus the previous screen', group = 'screen' }),
   
   awful.key({
      modifiers   = { modkey },
      keygroup    = 'numrow',
      description = 'only view tag',
      group       = 'tag',
      on_press    = function(index)
         local tag = awful.screen.focused().tags[index]
         if tag then tag:view_only() end
      end
   }),
   awful.key({
      modifiers   = { modkey, mod.ctrl },
      keygroup    = 'numrow',
      description = 'toggle tag',
      group       = 'tag',
      on_press    = function(index)
         local tag = awful.screen.focused().tags[index]
         if tag then awful.tag.viewtoggle(tag) end
      end
   }),
   awful.key({
      modifiers   = { modkey, mod.shift },
      keygroup    = 'numrow',
      description = 'move focused client to tag',
      group       = 'tag',
      on_press    = function(index)
         if client.focus then
            local tag = client.focus.screen.tags[index]
            if tag then client.focus:move_to_tag(tag) end
         end
      end
   }),
})
