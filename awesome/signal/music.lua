-- Get musin info
-- This requires the package 'playerctl'

local apps = require 'config.apps'
local naughty = require 'naughty'
local awful = require 'awful'
local gears = require 'gears'
local helpers = require 'helpers'

local music = {}

music.player = apps.player or 'spotify'

music.base_command = "playerctl --player=" .. music.player .. ",%any -s "

local metadata_command = "metadata"
local status_command = "status"
local position_command = 'position'


local lastimageurl = nil

function music.get_info (callback)
  local response = {
    image = nil,
    title = nil,
    artist = nil,
    status = nil,
  }

  local finished = {
    metadata = false,
    status = false,
    position = false,
  }

  awful.spawn.easy_async_with_shell(music.base_command .. metadata_command, function (raw_metadata)
    if #raw_metadata == 0 then
      finished.metadata = true
    if finished.status and finished.position then callback(response) end
      return
    end

    response.artist = string.match(raw_metadata, 'artist *([^\n]*)')
    response.title = string.match(raw_metadata, 'title *([^\n]*)')
    response.length = string.match(raw_metadata, 'length *([^\n]*)')
    local arturl = string.match(raw_metadata, 'artUrl *([^\n]*)')

    if lastimageurl ~= arturl then
      lastimageurl = arturl

      response.image = os.tmpname()
      helpers.save_image_async_curl(arturl, response.image, function ()
        if finished.status and finished.position then callback(response) end
        finished.metadata = true
      end)
    else

      if finished.status and finished.position then callback(response) end
      finished.metadata = true
    end
  end)

  awful.spawn.easy_async_with_shell(music.base_command .. status_command, function (status)

    if #status == 0 then
      finished.status = true
      if finished.metadata and finished.position then callback(response) end
      return
    end

    response.status = status

    if finished.metadata and finished.position then callback(response) end
    finished.status = true
  end)

  awful.spawn.easy_async_with_shell(music.base_command .. position_command, function (position)

    if #position == 0 then
      finished.status = true
      if finished.metadata and finished.status then callback(response) end
      return
    end

    response.position = tonumber(position)

    if finished.metadata and finished.status then callback(response) end
    finished.position = true
  end)
end

gears.timer {
  timeout = 5,
  call_now = true,
  autostart = true,
  callback = function ()
    music.get_info(function (response)
      awesome.emit_signal('music::response', response)
    end)
  end
}

function music.do_command (command)
  awful.spawn.easy_async_with_shell(music.base_command .. command, function ()
    music.get_info(function (response)
      awesome.emit_signal('music::response', response)
    end)
  end)
end

return music