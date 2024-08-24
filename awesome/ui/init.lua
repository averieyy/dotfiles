-- Returns all widgets, with assigned names, in a table.
return {
  menu = require (... .. '.menu'),
  notification = require (... .. '.notification'),
  titlebar = require (... .. '.titlebar'),
  launcher = require (... .. '.launcher'),
  timebox = require (... .. '.timebox'),
  appbar = require (... .. '.appbar'),
  notify_menu = require (... .. '.notify_menu'),
  activate_linux = require (... .. '.activate_linux'),
  dash = require (... .. '.dash'),
}
