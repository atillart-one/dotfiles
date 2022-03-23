local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"

os.execute("pactl set-sink-mute no; pactl set-sink-volume 0 25%")

slider = wibox.widget {
  bar_shape = gears.shape.rectangle,
  bar_height = 3,
  bar_color = beautiful.bg_focus,
  bar_active_color = beautiful.green1,
  handle_shape = gears.shape.circle,
  handle_color = "#00000000",
  handle_width = 12,
  value = 25,
  widget = wibox.widget.slider,
}


local image = wibox.widget{
    widget = wibox.widget.imagebox,
    image = gears.filesystem.get_configuration_dir() .. "icons/volume.png",
    stylesheet = " * { stroke: " .. beautiful.fg_normal .. " }",
    forced_width = 16,
    forced_height = 16,
    valign = "center",
    halign = "center",
}

local muted = false
function mute_toggle()
    if muted then
    os.execute("pactl set-sink-mute 0 toggle")
    image.image = gears.filesystem.get_configuration_dir() .. "icons/volume.png"
    muted = false
    else
    os.execute("pactl set-sink-mute 0 toggle")
    image.image = gears.filesystem.get_configuration_dir() .. "icons/mute.png"
    muted = true
    end
end

local vol_slider = wibox.widget {{
  layout = wibox.layout.align.horizontal,
  image,
  {{
        layout = wibox.layout.align.horizontal,
  slider,
    },
  widget = wibox.container.margin,
  forced_width = 100,
        },
  expand = 'none',
},
  widget = wibox.container.margin,
  left = 10,
  forced_width = 165,
}

slider:connect_signal("property::value", function(_, value)
  awful.spawn.with_shell("pactl set-sink-volume 0 " .. value .. "%")
end)

image:connect_signal("button::press", function() mute_toggle() end)
return vol_slider
