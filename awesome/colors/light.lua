local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font_name = "M PLUS 1"
theme.font = "M PLUS 1 12"

theme.titlebar= "#24292f"
theme.titlebar_active = "#24292f"

theme.bg1 = "#FFFFFF"
theme.bg2 = "#4C4C4C"
theme.bg3 = "#FFFFFF"

theme.fg1 = "#24292f"
theme.fg2 = "#24292F"

theme.red = "#ff7b72"
theme.green = "#9ece6a"
theme.yellow = "#f78166"
theme.blue = "#79c0ff"
theme.purple = "#d2a8ff"
theme.cyan = "#a5d6ff"

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

theme.wallpaper = "/home/nix/Downloads/701802.jpg"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80x
