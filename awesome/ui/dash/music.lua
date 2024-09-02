local wibox = require 'wibox'
local music = require 'signal.music'
local theme = require 'beautiful'
local naughty = require 'naughty'
local awful = require 'awful'
local gears = require 'gears'

return function (dashwidth, dashmargins)

  local totalmargins = 16
  local margins = totalmargins - dashmargins
  local width = dashwidth - margins * 2
  local height = width / 2

  local imagewidget = nil
  local titlewidget = nil
  local artistwidget = nil
  local playwidget = nil
  local progresswidget = nil

  local musicwidget = wibox.widget {
    widget = wibox.container.margin,
    margins = margins,
    {
      layout = wibox.layout.stack,
      {
        forced_width = width,
        forced_height = height,
        widget = wibox.container.background,
        bg = theme.bg,
        {
          widget = wibox.widget.imagebox,
          id = 'image'
        }
      },
      {
        forced_width = width,
        forced_height = height,
        widget = wibox.container.place,
        placement = awful.placement.centered,
        {
          widget = wibox.container.background,
          bg = theme.bg_dark .. "ef", -- With some transparency
          {
            widget = wibox.container.margin,
            margins = 8,
            {
  
              layout = wibox.layout.fixed.vertical,
              spacing = 8,
              forced_width = width * 3 / 4,
              {
                widget = wibox.widget.textbox,
                font = theme.base_font .. ' 12',
                align = 'center',
                id = 'title',
                forced_height = 20,
              },
              {
                widget = wibox.widget.textbox,
                font = theme.base_font .. ' 10',
                align = 'center',
                id = 'artist'
              },
              {
                widget = wibox.widget.progressbar,
                forced_height = 5,
                color = theme.emphasis,
                background_color = theme.bg_dark,
                max_value = 1,
                min_value = 0,
                value = 0,
                shape = gears.shape.rounded_bar,
                bar_shape = gears.shape.rounded_bar,
                id = 'progressbar',
              },
              {
                widget = wibox.container.place,
                placement = awful.placement.centered,
                {
                  layout = wibox.layout.flex.horizontal,
                  spacing = 8,
                  {
                    forced_width = 20,
                    widget = wibox.widget.textbox,
                    font = theme.symbol_font .. ' 12',
                    text = '',
                    align = 'center',
                    buttons = {
                      awful.button {
                        button = 1,
                        on_press = function ()
                          music.do_command('previous')
                        end
                      }
                    }
                  },
                  {
                    forced_width = 20,
                    widget = wibox.widget.textbox,
                    font = theme.symbol_font .. ' 12',
                    align = 'center',
                    id = 'playbtn',
                    buttons = {
                      awful.button {
                        button = 1,
                        on_press = function ()
                          music.do_command('play-pause')
                        end
                      }
                    }
                  },
                  {
                    forced_width = 20,
                    widget = wibox.widget.textbox,
                    font = theme.symbol_font .. ' 12',
                    text = '',
                    align = 'center',
                    buttons = {
                      awful.button {
                        button = 1,
                        on_press = function ()
                          music.do_command('next')
                        end
                      }
                    }
                  },
                }
              },
            }
          }
        },
      },
    },
    set_image = function (self, imageuri)
      local image = gears.surface.load_uncached(imageuri)
      local cropped = gears.surface.crop_surface {
        ratio = (width + totalmargins * 2) / (height + totalmargins * 2),
        surface = image
      }
      self:get_children_by_id('image')[1]:set_image(cropped);
    end,
    set_values = function (self, musicinfo)
      if not (imagewidget and titlewidget and artistwidget and playwidget and progresswidget) then
        naughty.notify {
          title = "Could not load music widget elements",
          urgency = "critical"
        }
        return
      end
      if musicinfo.image then
        self.image = musicinfo.image
      end
      titlewidget.text = musicinfo.title or 'Nothing playing'
      artistwidget.text = musicinfo.artist or ''
      playwidget.text = musicinfo.status == 'Playing\n' and '' or ''
      if musicinfo.length and musicinfo.position then
        progresswidget.value = tonumber(musicinfo.position) / (tonumber(musicinfo.length) / 1000000)
      else
        progresswidget.value = 0
      end
    end
  }

  imagewidget = musicwidget:get_children_by_id("image")[1]
  titlewidget = musicwidget:get_children_by_id("title")[1]
  artistwidget = musicwidget:get_children_by_id("artist")[1]
  playwidget = musicwidget:get_children_by_id("playbtn")[1]
  progresswidget = musicwidget:get_children_by_id("progressbar")[1]

  music.get_info(function (v)
    musicwidget.values = v
  end)

  awesome.connect_signal('music::response', function (v)
    musicwidget.values = v
  end)

  return musicwidget
end