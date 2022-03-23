---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "Montserrat Alternates 10"

theme.black = "#F0F0F0"
theme.titlebar = "#d7d7d7"
theme.titlebar_active = "#cacaca"

theme.playerctl_update_on_activity = true
theme.playerctl_position_update_interval = 1
theme.parent_filter_list   = {"firefox"} -- class names list of parents that should not be swallowed
theme.child_filter_list    = { "firefox" }        -- class names list that should not swallow their parents
theme.swallowing_filter = true     
theme.purple1 = "#8F8AAC"
theme.pink1 = "#AC8AAC"
theme.yellow1 = "#ACA98A"
theme.red1 = "#AC8A8C"
theme.orange1 = "#C6A679"
theme.cyan1 = "#8AACAB"
theme.green1 = "#8AAC8B"
theme.blue1 = "#8A98AC"
theme.white1 = "#262626"
theme.black1 = "#E7E7E7"

theme.purple2 = "#A39EC4"
theme.pink2 = "#C49EC4"
theme.yellow2 = "#C4C19E"
theme.red2 = "#C49EA0"
theme.orange2 = "#CEB188"
theme.cyan2 = "#9EC3C4"
theme.green2 = "#9EC49F"
theme.blue2 = "#A5B4CB"
theme.white2 = "#4C4C4C"
theme.black2 = "#F0F0F0"

theme.font_name = "Iosevka Nerd Font"
theme.black3 = "#cacaca"

theme.bg_normal     = theme.black
theme.bg_focus      = theme.black1
theme.bg_urgent     = theme.red1
theme.bg_minimize   = theme.black2
theme.bg_systray    = theme.black
theme.systray_icon_spacing = 10

theme.fg_normal     = theme.white1
theme.fg_focus      = theme.white1
theme.fg_urgent     = theme.black1
theme.fg_minimize   = theme.white1

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(0)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path.."default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "/home/nix/.config/awesome/themes/tokyo-night/close.png"
theme.titlebar_close_button_focus  = theme.titlebar_close_button_normal

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path.."default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path.."default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path.."default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = themes_path.."default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path.."default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path.."default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path.."default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = themes_path.."default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maimized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path.."default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = gears.color.recolor_image(themes_path.."default/layouts/fairhw.png", "#262626")
theme.layout_fairv = gears.color.recolor_image(themes_path.."default/layouts/fairvw.png", "#262626")
theme.layout_floating  = gears.color.recolor_image(themes_path.."default/layouts/floatingw.png", "#262626")
theme.layout_magnifier = gears.color.recolor_image(themes_path.."default/layouts/magnifierw.png", "#262626")
theme.layout_max = gears.color.recolor_image(themes_path.."default/layouts/maxw.png", "#262626")
theme.layout_fullscreen = gears.color.recolor_image(themes_path.."default/layouts/fullscreenw.png", "#262626")
theme.layout_tilebottom = gears.color.recolor_image(themes_path.."default/layouts/tilebottomw.png", "#262626")
theme.layout_tileleft   = gears.color.recolor_image(themes_path.."default/layouts/tileleftw.png", "#262626")
theme.layout_tile = gears.color.recolor_image(themes_path.."default/layouts/tilew.png", "#262626")
theme.layout_tiletop = gears.color.recolor_image(themes_path.."default/layouts/tiletopw.png", "#262626")
theme.layout_spiral  = gears.color.recolor_image(themes_path.."default/layouts/spiralw.png", "#262626")
theme.layout_dwindle = gears.color.recolor_image(themes_path.."default/layouts/dwindlew.png", "#262626")
theme.layout_cornernw = gears.color.recolor_image(themes_path.."default/layouts/cornernww.png", "#262626")
theme.layout_cornerne = gears.color.recolor_image(themes_path.."default/layouts/cornernew.png", "#262626")
theme.layout_cornersw = gears.color.recolor_image(themes_path.."default/layouts/cornersww.png", "#262626")
theme.layout_cornerse = gears.color.recolor_image(themes_path.."default/layouts/cornersew.png", "#262626")

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil
theme.wallpaper = "/home/nix/nixfiles/wallz/2333.png"
theme.rofi = "light"
theme.toggle_icon = "  "

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80x