-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Vicious Widgets
vicious = require("vicious")
--nvinf = require("vicious.contrib.nvinf")
--sensors = require("vicious.contrib.sensors_linux")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- launch the Xcompmgr
--awful.spawn.with_shell("xcompmgr")
--awful.spawn.with_shell("compton -b")

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

-- {{{ Naughty settings
naughty.config.presets.low.opacity = 0.88
naughty.config.presets.normal.opacity = 0.92
naughty.config.presets.critical.opacity = 0.96
naughty.config.defaults.font = "cantarell 16"
naughty.config.defaults.position = "bottom_middle"
naughty.config.defaults.icon_size = 128
naughty.config.defaults.border_color = "#ff4d00"
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init("~/.config/awesome/themes/default-sakura/theme.lua")
--beautiful.init("~/.config/awesome/themes/default-black/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
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
    -- awful.layout.suit.corner.nw,
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

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Vicious CPU Usage
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "$1% ", 1)

-- Vicious CPU Temperature
cputempwidget = wibox.widget.textbox()
--vicious.register(cputempwidget, vicious.widgets.cputemp, "$1℃ ", 1)
--vicious.register(cputempwidget, sensors, "$1℃ ", 3, "Package id 0")
vicious.register(cputempwidget, vicious.widgets.hwmontemp, "$1℃ ", 2, {"coretemp"})

-- Sensors fan speed
--cpufanwidget = wibox.widget.textbox()
--vicious.register(cpufanwidget, sensors, "$1rpm ", 5, "Processor Fan")
--gpufanwidget = wibox.widget.textbox()
--vicious.register(gpufanwidget, sensors, "$1rpm | ", 5, "Video Fan")

-- Vicious CPU Frequency
cpufreqwidget = wibox.widget.textbox()
--vicious.register(cpufreqwidget, vicious.widgets.cpufreq, "$2GHz | ", 1, "cpu0")
vicious.register(cpufreqwidget, vicious.widgets.cpufreq,
    function (widget, args)
        return string.format("%.2fGHz | ",args[2])
    end, 1, "cpu0")

-- Vicious NVIDIA info
--nvinfwidget0 = wibox.widget.textbox()
--vicious.register(nvinfwidget0, nvinf, "$1% $5℃ $6MHz | ", 3, "0")
--nvinfwidget1 = wibox.widget.textbox()
--vicious.register(nvinfwidget1, nvinf, "$1% $5℃ $6MHz | ", 3, "1")

-- Vicious Memory Usage
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "$2MB | ", 3)
--vicious.register(memwidget, vicious.widgets.mem,
--    function (widget, args)
--        return string.format("%dMB | ",args[2])
--    end, 3)

-- Vicious Disk Usage
diowidget = wibox.widget.textbox()
vicious.register(diowidget, vicious.widgets.dio,
                 "R:${nvme0n1 read_mb}MB/s W:${nvme0n1 write_mb}MB/s | ", 1)

-- Vicious Net Usage
netwidget = wibox.widget.textbox()
--vicious.register(netwidget, vicious.widgets.net, "↓(tonumber(${enp10s0u1u2 down_kb}) or 0)+(tonumber(${wlp2s0 down_kb}) or 0)KB/s ↑(tonumber(${enp10s0u1u2 up_kb}) or 0)+(tonumber(${wlp2s0 up_kb}) or 0)KB/s | ", 1)
vicious.register(netwidget, vicious.widgets.net,
                 function(widget, args)
                    return string.format("↓%.1fMB/s ↑%.1fMB/s | ",
                                         (args["{enp11s0u2u4 down_mb}"]  or 0)+
                                         (args["{enp14s0f0 down_mb}"]      or 0)+
                                         (args["{enp14s0f1 down_mb}"]      or 0)+
                                         (args["{thunderbolt0 down_mb}"] or 0)+
                                         (args["{wlp2s0 down_mb}"]       or 0),
                                         (args["{enp11s0u2u4 up_mb}"]    or 0)+
                                         (args["{enp14s0f0 up_mb}"]        or 0)+
                                         (args["{enp14s0f1 up_mb}"]        or 0)+
                                         (args["{thunderbolt0 up_mb}"]   or 0)+
                                         (args["{wlp2s0 up_mb}"]         or 0))
                 end,
                 1)

-- Vicious Battery
batwidget = wibox.widget.textbox()
vicious.register(batwidget, vicious.widgets.bat, "$1$2% $3 $5W | ", 30, "BAT0")

-- Vicious Uptime
uptimewidget = wibox.widget.textbox()
vicious.register(uptimewidget, vicious.widgets.uptime,
    function (widget, args)
        return string.format("%dd %02d:%02d ", args[1], args[2], args[3])
    end, 60)

-- Create a textclock widget
--mytextclock = wibox.widget.textclock(" AD %Y.%m.%d %T:%f %a", 0.1)
mytextclock = wibox.widget.textclock(" AD %Y.%m.%d %T", 1)

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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    awful.tag(
        { "main", "dev", "fx", "IM", "doc", "F1", "F2", "ddb" },
        s,
        {
            awful.layout.layouts[7], 
            awful.layout.layouts[7], 
            awful.layout.layouts[1], 
            awful.layout.layouts[2], 
            awful.layout.layouts[6], 
            awful.layout.layouts[1], 
            awful.layout.layouts[1], 
            awful.layout.layouts[6], 
        })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            mytextclock,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            cpuwidget,
            cputempwidget,
            cpufreqwidget,
            --cpufanwidget,
            --gpufanwidget,
            --nvinfwidget0,
            --nvinfwidget1,
            memwidget,
            diowidget,
            netwidget,
            batwidget,
            uptimewidget,
            --mykeyboardlayout,
            wibox.widget.systray(),
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

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
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
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
    awful.key({ modkey,           }, "Tab", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    --awful.key({ modkey,           }, "Tab",
    --    function ()
    --        awful.client.focus.history.previous()
    --        if client.focus then
    --            client.focus:raise()
    --        end
    --    end,
    --    {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn("volume_up.sh") end,
              {description = "increase volume", group = "function"}),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn("volume_down.sh") end,
              {description = "decrease volume", group = "function"}),
    awful.key({ }, "XF86AudioMute", function () awful.spawn("volume_mute.sh") end,
              {description = "mute audio", group = "function"}),
    awful.key({ }, "XF86MonBrightnessUp", function () awful.spawn("backlight_inc.sh") end,
              {description = "increase monitor brightness", group = "function"}),
    awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn("backlight_dec.sh") end,
              {description = "decrease monitor brightness", group = "function"}),
    --awful.key({ }, "Print", function () awful.spawn("scrot -e 'mv $f ~/Pictures/Screenshots/ 2>/dev/null'") end,
    awful.key({ }, "Print", function () awful.spawn("flameshot gui") end,
              {description = "print screen", group = "function"}),
    awful.key({         "Control"   }, "Print", function () awful.spawn("record_window.sh") end,
              {description = "record window, ctrl+shift+s to stop", group = "function"}),
    awful.key({ }, "XF86Search", function () awful.spawn("xscreensaver-command -lock") end,
              {description = "activate xscreensaver", group = "function"}),

    -- DOTA2
    --awful.key({ modkey,           }, "i", function () awful.spawn("xdotool mousemove 800 305;xdotool click 1") end),
    --awful.key({ modkey,           }, "d", function () awful.spawn("xdotool mousemove 900 360;xdotool click 1") end),
    --awful.key({ modkey,           }, "h", function () awful.spawn("xdotool mousemove 180 300;xdotool click 1") end),

    --remap copy and paste
    awful.key({         "Control" }, "j", function () awful.spawn("xdotool keyup j key c") end,
              {description = "copy", group = "function"}),
    awful.key({         "Control" }, "k", function () awful.spawn("xdotool keyup k key v") end,
              {description = "paste", group = "function"}),

    --input for steam
    awful.key({ modkey,           }, "p", function () awful.spawn("input.sh") end,
              {description = "open a input dialog", group = "function"}),

    --translate
    awful.key({ modkey,           }, "y", function () awful.spawn("translate.sh") end,
              {description = "translate selected text", group = "function"}),
    awful.key({ modkey,           }, "e", function () awful.spawn("nautilus -w") end,
    --awful.key({ modkey,           }, "e", function () awful.spawn("pcmanfm -n") end,
    --awful.key({ modkey,           }, "e", function () awful.spawn("thunar") end,
              {description = "open file explorer", group = "launcher"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Control" }, "q", awesome.quit,
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
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
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
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
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
    awful.key({ modkey, "Control" }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
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
        {description = "(un)maximize horizontally", group = "client"})
)

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
    -- { rule_any = {type = { "normal", "dialog" }
    --   }, properties = { titlebars_enabled = true }
    -- },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    { rule = { class = "Firefox", instance = "Navigator" },
    --  properties = { tag = tags[1][3], floating = true }, callback = function(c) c:geometry({ x = 0, y = -1, width = 1920, height = 1080 }) end },
    --  properties = { screen = 1, tag = "Fx", fullscreen = true } },
      properties = { tag = "fx" } },
    { rule = { class = "Pidgin" },
      properties = { tag = "IM" } },
    { rule = { class = "Telegram" },
      properties = { tag = "IM" } },
    { rule = { class = "discord" },
      properties = { tag = "IM" } },
    { rule = { class = "Whatsie" },
      properties = { tag = "IM" } },
    { rule = { class = "AliWangWang" },
      properties = { tag = "IM" } },
    { rule = { class = "Skype" },
      properties = { tag = "IM" } },
    { rule = { class = "skypeforlinux" },
      properties = { tag = "IM" } },
    { rule = { class = "Signal" },
      properties = { tag = "IM" } },
    { rule = { class = "Deadbeef" },
      properties = { tag = "ddb" } },
    { rule = { class = "easyeffects" },
      properties = { tag = "ddb" } },
--    { rule = { class = "Steam" },
--      properties = { screen = 1, tag = "F1" } },
    { rule = { class = "dota_linux" },
      properties = { tag = "F1", fullscreen = true } },
    { rule = { class = "dota2" },
      properties = { tag = "F1", fullscreen = true } },
    { rule = { class = "csgo_linux" },
      properties = { tag = "F1", fullscreen = true } },
    { rule = { class = "steam" },
      properties = { tag = "F1", fullscreen = true } },
    { rule = { class = "mpv" },
      properties = { fullscreen = true } },
    { rule = { class = "XTerm" },
      properties = { opacity = 0.96 } },
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

-- Add a titlebar if titlebars_enabled is set to true in the rules.
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

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ AutoStart
--awful.spawn.with_shell("xinput set-prop 10 'Evdev Scrolling Distance' -1 -1 -1")
--awful.spawn.with_shell("xinput set-prop 11 'Evdev Scrolling Distance' -1 -1 -1")
--Moved to /etc/X11/xorg.conf.d/50-mouse.conf

--awful.spawn.with_shell("xcalib /home/s10e/.color/m18x.icc")
--Moved to /etc/X11/xinit/xinitrc.d/color.sh
awful.spawn.with_shell("sleep 10;/etc/X11/xinit/xinitrc.d/50-color.sh")

awful.spawn.with_shell("sleep 5;setmonitor.sh")

-- }}}
