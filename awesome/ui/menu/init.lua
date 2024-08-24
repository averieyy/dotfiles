local awful     = require('awful')
local beautiful = require('beautiful')
local naughty = require 'naughty'

--- Menu
local menu = {}
local apps = require('config.apps')
local user = require('config.user')
local hkey_popup = require('awful.hotkeys_popup')

-- Create a main menu.
-- menu.awesome = {
--   { 'hotkeys',     function() hkey_popup.show_help(nil, awful.screen.focused()) end },
--   { 'manual',      apps.terminal .. ' -e man awesome' },
--   -- Not part of the original config but extremely useful, especially as the example
--   {
--     'docs',
--     (os.getenv('BROWSER') or 'min-browser') .. ' https://awesomewm.org/apidoc'
--   },
--   -- config is meant to serve as an example to build your own environment upon.
--   { 'edit config', apps.editor_cmd .. ' ' .. awesome.conffile },
--   { 'restart',     awesome.restart },
--   { 'quit',        function() awesome.quit() end }
-- }

menu.power = {
  { 'reload', awesome.restart },
  { 'log out', function() awesome.quit() end }
}

local function take_screenshot(args)
  args.directory = '~/Pictures/screenshots'
  
  local ss = awful.screenshot (args)

  local function notify(s)
    naughty.notification {
      title     = 'Screenie taken',
      message   = "saved to " .. s.file_name,
      icon      = s.surface,
      icon_size = 128,
    }
  end

  if args.auto_save_delay > 0 then
    ss:connect_signal("file::saved", notify)
  else
    notify(ss)
  end

  return ss
end

menu.screenshot = {
  { 'full', function () take_screenshot { auto_save_delay = 0 } end },
  { 'area', function () take_screenshot { auto_save_delay = 0, interactive = true } end },
}

menu.main = awful.menu({
  items = {
    { 'terminal', apps.terminal },
    { 'screenie', menu.screenshot },
    -- { 'hotkeys', function() hkey_popup.show_help(nil, awful.screen.focused()) end },
    -- {
    --   'docs',
    --   (os.getenv('BROWSER') or 'min-browser') .. ' https://awesomewm.org/apidoc'
    -- },
    { 'power', menu.power },
  }
})

return menu
