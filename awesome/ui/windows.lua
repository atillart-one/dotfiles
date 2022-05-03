local awful = require "awful"
local wibox = require "wibox"

awful.popup {
    widget = {
        {
            {
                text = "Activate Windows",
                font = "Segoe UI 20",
                widget = wibox.widget.textbox
            },

            {
                text = "Go to Settings to activate Windows.",
                font = "Segoe UI 15",
                widget = wibox.widget.textbox
            },

            layout = wibox.layout.fixed.vertical
        },

        margins = 60,
        widget = wibox.container.margin
    },

    opacity = 0.5,
    bg = "#00000000",
    type = "desktop",
    visible = true,
    ontop = true,
    input_passthrough = true,
    placement = awful.placement.bottom_right
}
