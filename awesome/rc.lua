-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local lain = require("lain")
local cairo = require("lgi").cairo
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

F = {}
local ruled = require("ruled")
local rubato = require("rubato")
local bling = require("bling")
local playerctl = bling.signal.playerctl.lib()

local naughty = require("naughty")
local nconf = naughty.config
nconf.defaults.border_width = 3
nconf.defaults.border_color = beautiful.titlebar_active
nconf.defaults.margin = 16
nconf.defaults.shape = gears.shape.rectangle
nconf.defaults.timeout = 5
nconf.padding = 15
nconf.defaults.icon_size = 128
nconf.spacing = 8
nconf.defaults.ontop = true
nconf.defaults.screen = awful.screen.focused()
nconf.defaults.timeout = 10
nconf.defaults.title = "Notification"
nconf.defaults.position = "top_right"

beautiful.notification_font = beautiful.font
local music_text = wibox.widget {
    font = "M PLUS 1 20",
    widget = wibox.widget.textbox
}
    
local art = wibox.widget {
    image = (gears.filesystem.get_configuration_dir() .. "icons/music.png"),
    resize = true,
    forced_width = dpi(220),
    widget = wibox.widget.imagebox
}

playerctl:connect_signal("metadata",
                       function(_, title, artist, album_path, album, new, player_name)
    if new == true then
        art:set_image(album_path)
        naughty.notify({title = "NOW PLAYING", text = title .. "\nby " .. string.gsub(artist, "- Topic", ""), image = album_path})
    end
end)

local layoutlist = awful.popup {
  widget = {
    awful.widget.layoutlist {
      source = awful.widget.layoutlist.source.default_layouts,
      screen = 1,
      base_layout = wibox.widget {
        spacing = 5,
        forced_num_cols = 4,
        layout = wibox.layout.grid.vertical,
      },
      widget_template = {
        {
          {
            id = "icon_role",
            forced_height = 25,
            forced_width = 25,
            widget = wibox.widget.imagebox,
          },
          margins = 10,
          widget = wibox.container.margin,
        },
        id = "background_role",
        forced_width = 35,
        forced_height = 35,
        widget = wibox.container.background,
      },
    },
    widget = wibox.container.margin,
    margins = 20,
  },
  bg = beautiful.bg_dark,
  visible = false,
  border_width = 3,
  shape = gears.shape.rectangle,
  border_color = beautiful.titlebar_active,
  placement = function(c)
    (awful.placement.centered)(c, { margins = { } })
  end,
  ontop = true,
  hide_on_right_click = true,
}

local hide = timer({ timeout = 1.5 })
  hide:connect_signal("timeout", function ()
                                       layoutlist.visible=false
                                       hide:stop() end)
local function toggle()
  layoutlist.visible = true
  hide:start()
end 


-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    bling.layout.mstab,
    awful.layout.suit.floating,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "Options", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M    %A,  %B %d")
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Widgets
local mysystray = wibox.widget {
    widget = wibox.widget.systray
}
local mode_widget = wibox.widget {
    markup = beautiful.toggle_icon,
    font = 'Iosevka Nerd Font 14',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
}


local play_widget = wibox.widget {
    markup = '',
    font = 'Iosevka Nerd Font 16',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox,
}

local next_widget = wibox.widget {
    markup = '怜',
    font = 'Iosevka Nerd Font 18',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local prev_widget = wibox.widget {
    markup = '玲',
    font = 'Iosevka Nerd Font 18',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local name_widget = wibox.widget {
    markup = 'Nothing Playing',
    font = 'M PLUS 1 14',
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local artist_widget = wibox.widget {
    markup = '<span color="#767676"> Nothing Playing </span>',
    align = 'center',
    valign = 'center',
    font = 'M PLUS 1 12',
    fg = beautiful.bg1,
    widget = wibox.widget.textbox
}


local progress = wibox.widget {
        max_value     = 100,
        value         = 0,
        forced_height = 1,
        color  = beautiful.green,
        background_color = beautiful.bg1,
        widget        = wibox.widget.progressbar,
    }
    
local progress_slider = wibox.widget {
    bar_shape           = gears.shape.rounded_rect,
    bar_height          = 5,
    bar_color           = "#00000000",
    handle_color        = "#00000000",
    handle_shape        = gears.shape.rounded_rect,
    handle_border_color = beautiful.border_color,
    handle_border_width = 0,
    value               = 25,
    widget              = wibox.widget.slider,
    }
progress_slider:connect_signal("property::value", function()
        os.execute("playerctl position " .. progress_slider.value/100*time_song)
        progress.value = progress_slider.value
end)
playerctl:connect_signal("metadata",
                       function(_, title, artist, album_path, album, new, player_name)
    -- Set player name, title and artist widgets
    name_widget:set_markup_silently(title)
    artist_widget:set_markup_silently('<span color="#767676">' .. artist .. '</span>')
end)

playerctl:connect_signal("playback_status",
                       function(_, playing)
    if playing == true then
            play_widget:set_markup_silently('')
    else 
            play_widget:set_markup_silently('')
    end    
end)
play_widget:connect_signal("button::press",
    function() playerctl:play_pause()
end)

prev_widget:connect_signal("button::press", function()
    playerctl:previous()
end)

next_widget:connect_signal("button::press", function()
    playerctl:next()
end)

time_song = 0
playerctl:connect_signal("position", function(_, interval_sec, length_sec)
    progress.value = interval_sec/length_sec*100
    time_song = length_sec
end)


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () toggle() end),
                           awful.button({ }, 3, function () awful.layout.inc(1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    

-- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style   = {
        shape = gears.shape.rounded_rect, 
        shape_border_width = 2,
        shape_border_color = beautiful.bg3,
        shape_border_color_focus = beautiful.green,
        fg_focus = beautiful.bg3,
        bg_focus = beautiful.green,
        fg_empty = beautiful.bg2,
        bg_occupied = beautiful.bg3,
        bg_empty = beautiful.bg3,
    },
    layout   = {
        layout  = wibox.layout.fixed.vertical,
        spacing = 5
    },
    widget_template = {
        {
            {
                {
                    {
                        {
                            id     = 'index_role',
                            widget = wibox.widget.textbox,
                            forced_height = 0,
                            forced_width = 0,
                        },
                        margins = 0,
                        widget  = wibox.container.margin,
                    },
                    bg     = '#dddddd00',
                    shape  = gears.shape.rounded_rect,
                    widget = wibox.container.background,
                },
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            top  = 8,
            bottom = 8,
            left = 12,
            right = 12,
            widget = wibox.container.margin
        },
        id     = 'background_role',
        widget = wibox.container.background,
        -- Add support for hover colors and an index label
        create_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
            self:connect_signal('mouse::enter', function()
                if self.fg ~= beautiful.pink1 then
                    self.backup     = self.fg
                    self.has_backup = true
                end
                self.fg = beautiful.pink1
            end)
            self:connect_signal('mouse::leave', function()
                if self.has_backup then self.fg = self.backup
                end
            end)
        end,
        update_callback = function(self, c3, index, objects) --luacheck: no unused args
            self:get_children_by_id('index_role')[1].markup = '<b> '..index..' </b>'
        end,
    },
    buttons = taglist_buttons
}

s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    style    = {
        shape  = gears.shape.rounded_rect,
    },
    layout   = {
        spacing = 0,
        layout  = wibox.layout.flex.vertical,
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
    {
        {
            {
                {
                    {
                id     = 'clienticon',
                widget = awful.widget.clienticon,
                    },
                    widget  = wibox.container.margin,
                    left = 2,
                    right = 2,
                    top = 2,
                },
                layout = wibox.layout.fixed.vertical,
            },
        id     = 'background_role',
        widget = wibox.container.background,
        forced_width = 40,
        },
            widget = wibox.container.margin,
            margins = 3,
        },
        widget = wibox.container.background,
        bg = beautiful.bg3,
        shape = gears.shape.rounded_rect,
        forced_height = 36,
        forced_width = 36,
    },
}
beautiful.tasklist_align = 'right'
beautiful.tasklist_plain_task_name = true

local right_widget = wibox.widget {
        {
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox
        },
        widget = wibox.container.margin,
        draw_empty = false,
        right = 15,
        left = 15,
        bottom = 10,
        top = 10,
    }

s.leftbar = awful.popup {
        widget = {
            widget = wibox.container.margin,
            top = 10,
            bottom = 10,
            left = 15,
            right = 15,
            {
                layout = wibox.layout.align.horizontal,
                mytextclock,
                forced_height = 24,
            },
        },
  border_width = 3,
  border_color = beautiful.titlebar_active,
  placement = function(c)
    (awful.placement.bottom_left)(c, { margins = {left = 25, bottom = 18} })
  end,
} 
s.statusbar = awful.popup {
        widget = {
            widget = wibox.container.margin,
            top = 10,
            bottom = 10,
            left = 18,
            right = 10,
            {
                layout = wibox.layout.align.horizontal,
                mysystray,
                forced_height = 24,
            },
        },
  border_width = 3,
  border_color = beautiful.titlebar_active,
  placement = function(c)
    (awful.placement.bottom_left)(c, { margins = {left = 25, bottom = 18} })
  end,
} 
s.statusbar:struts{bottom = 65}
s.statusbar.visible = false
s.leftbar:struts{bottom = 65}
s.leftbar.visible = true

music_widget = wibox.widget {
  {
  layout = wibox.layout.fixed.horizontal,
  spacing = 15,
  s.mytaglist,
    {{{
        layout = wibox.layout.align.vertical,
        expand = 'outside',
        name_widget,
                {{
        layout = wibox.layout.stack;
        artist_widget,
                    },
        widget = wibox.container.margin,
        top = 5,
        bottom = -5
                    },

                {{
    layout = wibox.layout.align.vertical,
    expand = 'none',
                {
    progress,
    progress_slider,
    layout = wibox.layout.stack,
    forced_height = 3,
    forced_width = 1,
    },
        {{
            layout = wibox.layout.align.horizontal,
            expand = 'inside',
            prev_widget,
            play_widget,
            next_widget,
                },
            widget = wibox.container.margin,
            top = 20,
                        },
                    },
        widget = wibox.container.margin,
        top = 20,
},
    },
                widget = wibox.container.margin,
                left = 30,
                right = 30,
                bottom = 10,
                forced_width = 400,
            },
                widget = wibox.container.background,
                shape = gears.shape.rounded_rect,
                bg = beautiful.bg3,
                },
  },
        widget = wibox.container.margin,
        margins = 15,

  forced_height = 215,
  forced_width = 550,
            }
s.leftbar:connect_signal("mouse::enter", function() 
        s.statusbar.visible = true
        s.leftbar.visible = false
end)
s.statusbar:connect_signal("mouse::leave", function()
        s.statusbar.visible = false
        s.leftbar.visible = true
end)

end)
-- }}}
mysystray:set_base_size(21)
beautiful.tasklist_bg_focus = beautiful.green
beautiful.tasklist_bg_normal = beautiful.bg3
beautiful.tasklist_bg_minimize= beautiful.bg1
-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,  }, "w", function()
        Scratch.term:toggle()
end),
       -- Show/Hide Wibox/
    awful.key({ modkey }, "b", function ()
                 for s in screen do
                 s.leftbar.visible = not s.leftbar.visible
                 end
         end,
         {description = "toggle wibox", group = "awesome"}),
    awful.key({ modkey, "Control"          }, "s", function () bling.module.window_swallowing.toggle() end,
        {description = "toggle swallowing", group = "client"}),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
    awful.key({ }, "Print", function () awful.util.spawn("flameshot gui") end),  
    awful.key({ "Shift" }, "Print", function () awful.util.spawn("flameshot full -c") end),
    awful.key({ modkey, "Mod1"    }, "Right",     function () awful.tag.incmwfact( 0.01)    end),
    awful.key({ modkey, "Mod1"    }, "Left",     function () awful.tag.incmwfact(-0.01)    end),
    awful.key({ modkey, "Mod1"    }, "Down",     function () awful.client.incwfact( 0.01)    end),
    awful.key({ modkey, "Mod1"    }, "Up",     function () awful.client.incwfact(-0.01)    end), 
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey, "Shift"          }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function () dashboard_toggle() 
        end,
        {description = "toggle dashboard", group = "awesome"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control"   }, "c", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1) toggle() hide:again() end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) toggle() hide:again() end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey }, "x",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.util.spawn("rofi -no-lazy-grab -show drun -modi run,drun,window -theme '/home/nix/nixfiles/rofi/launcher.rasi'") end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey, "Control" }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey           }, "z",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
     awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.util.spawn("brightnessctl s 5%-") end),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.util.spawn("brightnessctl s +5%") end),
awful.key({}, "XF86AudioRaiseVolume", function() os.execute("pactl set-sink-volume 0 +5%") end),
awful.key({}, "XF86AudioLowerVolume", function() os.execute("pactl set-sink-volume 0 -5%") end),
awful.key({}, "XF86AudioMute", function() mute_toggle() end) )

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
    -- disable titlebar
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

--- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

awful.titlebar(c, {size=35, position = 'top', bg_normal= beautiful.titlebar, bg_focus= beautiful.titlebar_active}):setup {
{
      awful.titlebar.widget.closebutton(c),
      { -- Middle
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal
    },
      layout = wibox.layout.align.horizontal,
      spacing = 15,
    },
    widget = wibox.container.margin,
    top = 8,
    left = 10,
    right = 8,
    bottom = 8,
  }

end)
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Scratchpad
bling.module.window_swallowing.start()
bling.module.window_swallowing.toggle()
Scratch = {}

Scratch.term = bling.module.scratchpad {
  command = "kitty --class=scratch",
  rule = { instance = "scratch" },
  sticky = true,
  autoclose = false,
  floating = true,
  geometry = { x = (1920-850)/2, y = (1080-500)/2, height = 500, width = 850 },
  reapply = true,
  dont_focus_before_close = false,
}
bling.module.flash_focus.enable()
-- imagine using titlebars for tiled windows
 screen.connect_signal("arrange", function(s)
  local layout = s.selected_tag.layout.name
  for _, c in pairs(s.clients) do
    if layout == "floating" or c.floating then
         awful.titlebar.show(c, "top")
    else
      awful.titlebar.hide(c, "top")
    end
  end
end)
--]]
-- Fullscreen Border fix 
client.connect_signal("property::fullscreen", function(c)
  if c.fullscreen then
    gears.timer.delayed_call(function()
      if c.valid then
        c:geometry(c.screen.geometry)
      end
    end)
  end
end)
-- AutoStart Applications
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("killall pa-applet; pa-applet")
awful.spawn.with_shell('xautolock -time 5 -corners ---- -locker "betterlockscreen -l"')
awful.spawn.with_shell("pkill cbatticon; cbatticon")

bling.module.wallpaper.setup {
    wallpaper = {beautiful.wallpaper},
    position = "scale",
}
