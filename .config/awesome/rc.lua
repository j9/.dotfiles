-- Standard awesome library
require("awful")
require("awful.autofocus")
-- require("awful.rules")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("revelation")
-- require("blingbling")

-- Custom modules
--local scratch = require("scratch")
local quake = require("quake")
local vicious = require("vicious")
local sound   = require("sound")
local shifty  = require("shifty")

-- module configs
table.insert(naughty.config.icon_dirs, os.getenv("HOME") ..
  "/.config/awesome/naughty_icons/")

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
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/j9/.config/awesome/themes/pfpf/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

tmux_terminal = os.getenv("HOME") .. "/.scripts/main_terminal.sh"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
Alt_key = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
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
    awful.layout.suit.magnifier
}
-- }}}
--
shifty.config.tags = {
    ["1:sys"] = {
        layout    = awful.layout.suit.fair,
        mwfact    = 0.60,
        exclusive = false,
        position  = 1,
        init      = true,
        screen    = 1,
        slave     = true,
        spawn     = tmux_terminal
    },
    ["2:vim"] = {
        layout      = awful.layout.suit.max,
        mwfact      = 0.70,
        max_clients = 1,
        exclusive   = false,
        position    = 2,
        slave       = true
    },
    ["3:web"] = {
        layout      = awful.layout.suit.float,
        -- required for flash fullscreen
        exclusive   = false,
        max_clients = 1,
        position    = 3,
        -- init        = true
        -- spawn       = browser,
    },
    ["4:TeX"] = {
        layout    = awful.layout.suit.tile,
        mwfact    = 0.50,
        exclusive = false,
        position  = 4,
        slave     = true,
    },
    ["5:irc"] = {
        layout    = awful.layout.suit.float,
        exclusive = true,
        position  = 5,
        slave     = true,
    },
    ["9:fpm"] = {
        layout      = awful.layout.suit.tile.bottom,
        mwfact      = 0.65,
        exclusive   = true,
        max_clients = 1,
        position    = 9,
    },
    -- mail = {
        -- layout    = awful.layout.suit.tile,
        -- mwfact    = 0.55,
        -- exclusive = false,
        -- position  = 3,
        -- spawn     = mail,
        -- slave     = true
    -- },
}

-- SHIFTY: application matching rules
-- order here matters, early rules will be applied first
shifty.config.apps = {
    {
      match = {
        "gvim",
      },
      tag = "2:vim",
    },
    {
      match = {
        "Firefox.*",
      },
      tag = "3:web",
    },
    {
      match = {
        "fpm2",
      },
      tag = "9:fpm",
    },
    {
      match = {"latex",},
      tag = "4:TeX",
    },
    -- {
        -- match = {
            -- "Mplayer.*",
            -- "Mirage",
            -- "gimp",
            -- "gtkpod",
            -- "Ufraw",
            -- "easytag",
        -- },
        -- tag = "media",
        -- nopopup = true,
    -- },
    -- {
        -- match = {
            -- "MPlayer",
            -- "Gnuplot",
            -- "galculator",
            -- "Exe",
        -- },
        -- float = true,
    -- },
    {
      match = {
        "irc",
      },
      tag = "5:irc",
    },
    {
      match = {
        "main_terminal",
      },
      tag = "1:sys",
    },
    {
        match = {
            terminal,
        },
        honorsizehints = false,
        slave = false,
    },
    {
        match = {""},
        buttons = awful.util.table.join(
            awful.button({}, 1, function (c) client.focus = c; c:raise() end),
            awful.button({modkey}, 1, function(c)
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
                end),
            awful.button({modkey}, 3, awful.mouse.client.resize)
            )
    },
}

-- SHIFTY: default tag creation rules
-- parameter description
--  * floatBars : if floating clients should always have a titlebar
--  * guess_name : should shifty try and guess tag names when creating
--                 new (unconfigured) tags?
--  * guess_position: as above, but for position parameter
--  * run : function to exec when shifty creates a new tag
--  * all other parameters (e.g. layout, mwfact) follow awesome's tag API
shifty.config.defaults = {
    layout = awful.layout.suit.tile.bottom,
    ncol = 1,
    mwfact = 0.60,
    floatBars = true,
    guess_name = true,
    guess_position = true,
}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- tags = {
  -- names = { "a", "b", "c", "d", "e", "f", "g", "h", "j" },
  -- layouts = { layouts[1], layouts[1], layouts[1], 
              -- layouts[1], layouts[1], layouts[1],
              -- layouts[1], layouts[1], layouts[1] }
-- }

-- for s = 1, screen.count() do
    -- Each screen has its own tag table.
    -- tags[s] = awful.tag(tags.names, s, tags.layouts)
-- end

-- tags[1][1]:add_signal("property::selected", function (tag) 
  -- if awful.tag.selected(1) == tag then
    -- tag.name = "[" .. tag.name .. "]"
  -- else
    -- tag.name = tags.names[1]
  -- end
-- end)

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "&restart", awesome.restart },
   { "quit", awesome.quit }
}

bin_gvim        = "gvim"

-- browser selection
bin_chromium    = "chromium"
bin_firefox     = "firefox-bin"
bin_browser     = bin_firefox

bin_lock_screen = "xscreensaver-command -lock"
bin_file_mng    = "pcmanfm ~"
bin_fpm2        = "fpm2"

mymainmenu = awful.menu({ items = { { "&awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "&terminal", terminal, beautiful.app_icon_terminal },
                                    { "&browser", bin_browser, beautiful.app_icon_firefox },
                                    { "&vim", bin_gvim, beautiful.app_icon_gvim },
                                    { "f&pm", bin_fpm2, beautiful.app_icon_fpm },
                                    { "&file manager", bin_file_mng, beautiful.app_icon_file_mng },
                                    { "&lock screen", bin_lock_screen, beautiful.app_icon_lock_screen }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })


local quakeconsole = {}
for s = 1, screen.count() do
   quakeconsole[s] = quake({ terminal = terminal,
           height = 0.5,
           screen = s })
end
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    -- awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ }, 3, function(tag) tag.selected = not tag.selected end),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
    -- if c == client.focus then
      -- c.minimized = true
    -- else
    if not c:isvisible() then
        awful.tag.viewonly(c:tags()[1])
    end
    -- This will also un-minimize
    -- the client, if needed
    client.focus = c
    c:raise()
    end),
    -- end),
  awful.button({ }, 3, function ()
    if instance then
      instance:hide()
      instance = nil
    else
      instance = awful.menu.clients({ width=250 })
    end
    end),
  awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
    end),
  awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
    end))


-- Initialize widget
cpu_widget = awful.widget.graph()
-- -- Graph properties
cpu_widget:set_width(50)
cpu_widget:set_height(10)
cpu_widget:set_background_color("#494B4F")
cpu_widget:set_color("#FF5656")
cpu_widget:set_gradient_colors({ "#FF5656", "#88A175", "#AECF96" })
awful.widget.layout.margins[cpu_widget.widget] = { top = 5, bottom = 5, right = 4 }
-- -- Register widget
vicious.register(cpu_widget, vicious.widgets.cpu, "$1")


cpu_icon = widget({ type = "imagebox" })
cpu_icon.image = image(beautiful.widget_cpu)
cpu_icon.align = "middle"

cpu_info = widget({ type = "textbox" })
vicious.register(cpu_info, vicious.widgets.cpu, "$1")

-- Task warrior widget --
-- task_warrior = blingbling.task_warrior.new(beautiful.widget_warrior)
-- task_warrior:set_task_done_icon(beautiful.task_warrior_icon_task_done)
-- task_warrior:set_task_icon(beautiful.task_warrior_icon_task)
-- task_warrior:set_project_icon(beautiful.task_warrior_icon_project)

-- Battery --
bat_icon = widget({ type = "imagebox" })
bat_icon.image = image(beautiful.widget_bat_high)
bat_icon.align = "middle"

bat_info_perc = widget({type = "textbox" })

bat_t = awful.tooltip({ objects = { bat_info_perc, bat_icon }, })

bat_notify = function (battery_state, capacity, preset, bg_color)
  if battery_state == "-" then
    naughty.notify({ title = "Battery is getting low!",
                     text = capacity .. "% remaining!",
                     preset = preset,
                     bg = bg_color})
  end
end

vicious.register(bat_info_perc, vicious.widgets.bat, function (widget, args)
  bat_cap = args[2]
  bat_state = args[1]
  bat_t:set_text("State: " .. bat_state)
  if bat_cap > 50 then
    if bat_cap % 10 == 0 then
      bat_notify(bat_state, bat_cap, naughty.config.presets.normal,
                 "#228b22")
    end
    bat_icon.image = image(beautiful.widget_bat_high)
  elseif bat_cap >= 20 and bat_cap <= 50 then
    if bat_cap % 10 == 0 then
      bat_notify(bat_state, bat_cap, naughty.config.presets.normal,
                 "#b8860b")
    end
    bat_icon.image = image(beautiful.widget_bat_low)
  else
    bat_notify(bat_state, bat_cap, naughty.config.presets.critical)
    bat_icon.image = image(beautiful.widget_bat_empty)
  end
  return bat_cap
  end, 61, "BAT")


-- memory related
mem_icon = widget({ type = "imagebox" })
mem_icon.image = image(beautiful.widget_mem)
mem_icon.align = "middle"

mem_info_perc = widget({ type = "textbox" })
vicious.register(mem_info_perc, vicious.widgets.mem, "$1", 13)

mem_info_used = widget({ type = "textbox" })
vicious.register(mem_info_used, vicious.widgets.mem, "$2", 13)

mem_info_total = widget({ type = "textbox" })
vicious.register(mem_info_total, vicious.widgets.mem, "$3", 13)


net_down_icon = widget({ type = "imagebox" })
net_down_icon.image = image(beautiful.widget_net_down)
net_down_icon.align = "middle"

net_down_info = widget({ type = "textbox" })
vicious.register(net_down_info, vicious.widgets.net, "${eth0 down_kb}", 1)

net_up_icon = widget({ type = "imagebox" })
net_up_icon.image = image(beautiful.widget_net_up)
net_up_icon.align = "middle"

net_up_info = widget({ type = "textbox" })
vicious.register(net_up_info, vicious.widgets.net, "${eth0 up_kb}", 1)

clock_icon = widget({ type = "imagebox" })
clock_icon.image = image(beautiful.widget_clock)
clock_icon.align = "middle"

-- Spacers
sym_rbracket = widget({type = "textbox" })
sym_rbracket.text = "<span color=\"#6b8ba3\">]</span>"
sym_lbracket = widget({type = "textbox" })
sym_lbracket.text = "<span color=\"#6b8ba3\">[</span>"
sym_line = widget({type = "textbox" })
sym_line.text = "<span color=\"#404040\">│</span>"
funny = widget({type = "textbox" })
funny.text = "<span color=\"#6b8ba3\">┌∩┐(◣_◢)┌∩┐ </span>"
-- Space
sym_space = widget({ type = "textbox" })
sym_space.text = " "

-- Symbols
sym_percent = widget({ type = "textbox" })
sym_percent.text = "%"

sym_slash = widget({ type = "textbox" })
sym_slash.text = "/"


for s = 1, screen.count() do
    -- Create a promptbox for each screen
  mypromptbox[s] = 
    awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
  -- Create an imagebox widget which will contains an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

  -- Create a taglist widget
  mytaglist[s] = awful.widget.taglist(s, 
                                      awful.widget.taglist.label.all, 
                                      mytaglist.buttons)

  -- Create a tasklist widget
  mytasklist[s] = awful.widget.tasklist(function(c)
                    return awful.widget.tasklist.label.currenttags(c, s)
                  end, 
                                        mytasklist.buttons)

  -- Create the wibox
  mywibox[s] = awful.wibox({ position = "top", screen = s })
  -- Add widgets to the wibox - order matters
  mywibox[s].widgets = {
      {
        mylauncher,
        mytaglist[s],
        mypromptbox[s],
        layout = awful.widget.layout.horizontal.leftright
      },
      mylayoutbox[s],
      mytextclock,
      clock_icon,
      sym_space,

      sym_rbracket, 
        cpu_widget.widget,
        sym_space,
        sym_percent, cpu_info, cpu_icon, 
      sym_lbracket,

      sym_space,

      sym_rbracket, sym_space,
        mem_info_total, sym_slash, mem_info_used, sym_space, sym_percent, mem_info_perc, mem_icon,
      sym_lbracket,

      sym_space,

      sym_rbracket, sym_space,
        sym_percent, bat_info_perc, bat_icon,
      sym_lbracket,

      sym_space,

      sym_rbracket, sym_space,
      net_down_info, net_down_icon,
      sym_space,
      net_up_info, net_up_icon,
      sym_lbracket,

      -- task_warrior.widget,

      sym_space,
      s == 1 and mysystray or nil,
      mytasklist[s],
      layout = awful.widget.layout.horizontal.rightleft
  }
end
-- }}}
--
--
-- SHIFTY: initialize shifty
-- the assignment of shifty.taglist must always be after its actually
-- initialized with awful.widget.taglist.new()
shifty.taglist = mytaglist
shifty.init()

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
  awful.button({ }, 3, function () mymainmenu:toggle() end),
  awful.button({ }, 4, awful.tag.viewnext),
  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}
--

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

  -- Shifty: keybindings specific to shifty
  awful.key({modkey, "Shift"}, "d", shifty.del), -- delete a tag
  awful.key({modkey, "Shift"}, "n", shifty.send_prev), -- client to prev tag
  awful.key({modkey}, "n", shifty.send_next), -- client to next tag
  awful.key({modkey, "Control"},
            "n",
            function()
                local t = awful.tag.selected()
                local s = awful.util.cycle(screen.count(), t.screen + 1)
                awful.tag.history.restore()
                t = shifty.tagtoscr(s, t)
                awful.tag.viewonly(t)
            end),
  awful.key({modkey}, "a", shifty.add), -- creat a new tag
  awful.key({modkey, Alt_key}, "r", shifty.rename), -- rename a tag
  awful.key({modkey, "Shift"}, "a", -- nopopup new tag
  function()
      shifty.add({nopopup = true})
  end),
  -- end of Shifty bindings

  awful.key({ modkey,           }, "j",
      function ()
          awful.client.focus.byidx( 1)
          if client.focus then client.focus:raise() end
      end),
  awful.key({ modkey,           }, "k",
      function ()
          awful.client.focus.byidx(-1)
          if client.focus then client.focus:raise() end
      end),
  awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
  awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
  awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey,           }, "Tab",
      function ()
          awful.client.focus.history.previous()
          if client.focus then
              client.focus:raise()
          end
      end),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift"   }, "q", awesome.quit),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
  awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

  awful.key({ modkey, "Control" }, "n", awful.client.restore),

  -- Prompt
  awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

  awful.key({ modkey }, "x",
            function ()
                awful.prompt.run({ prompt = "Run Lua code: " },
                mypromptbox[mouse.screen].widget,
                awful.util.eval, nil,
                awful.util.getdir("cache") .. "/history_eval")
            end),

  -- Lock screen with Xscreensaver
  awful.key({ "Control", Alt_key }, "l", function () awful.util.spawn(bin_lock_screen) end),
  -- Revelation extension bindings
  awful.key({ modkey,            }, "e", revelation),
  
  -- Sound shortcuts for X86 events keys
  awful.key({  }, "XF86AudioMute", sound.toggle_mute),
  awful.key({  }, "XF86AudioLowerVolume", sound.vol_down),
  awful.key({  }, "XF86AudioRaiseVolume", sound.vol_up),

  -- Quake console
  awful.key({ modkey }, "`", function () quakeconsole[mouse.screen]:toggle() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- SHIFTY: assign client keys to shifty for use in
-- match() function(manage hook)
shifty.config.clientkeys = clientkeys
shifty.config.modkey = modkey

-- Compute the maximum number of digit we need, limited to 9
for i = 1, (shifty.config.maxtags or 9) do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({modkey}, i, function()
      local t =  awful.tag.viewonly(shifty.getpos(i))
      end),
    awful.key({modkey, "Control"}, i, function()
      local t = shifty.getpos(i)
      t.selected = not t.selected
      end),
    awful.key({modkey, "Control", "Shift"}, i, function()
      if client.focus then
          awful.client.toggletag(shifty.getpos(i))
      end
      end),
    -- move clients to other tags
    awful.key({modkey, "Shift"}, i, function()
      if client.focus then
        t = shifty.getpos(i)
        awful.client.movetotag(t)
        awful.tag.viewonly(t)
      end
    end))
  end



-- Compute the maximum number of digit we need, limited to 9
-- keynumber = 0
-- for s = 1, screen.count() do
   -- keynumber = math.min(9, math.max(#tags[s], keynumber));
-- end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, keynumber do
    -- globalkeys = awful.util.table.join(globalkeys,
        -- awful.key({ modkey }, "#" .. i + 9,
                  -- function ()
                        -- local screen = mouse.screen
                        -- if tags[screen][i] then
                            -- awful.tag.viewonly(tags[screen][i])
                        -- end
                  -- end),
        -- awful.key({ modkey, "Control" }, "#" .. i + 9,
                  -- function ()
                      -- local screen = mouse.screen
                      -- if tags[screen][i] then
                          -- awful.tag.viewtoggle(tags[screen][i])
                      -- end
                  -- end),
        -- awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  -- function ()
                      -- if client.focus and tags[client.focus.screen][i] then
                          -- awful.client.movetotag(tags[client.focus.screen][i])
                      -- end
                  -- end),
        -- awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  -- function ()
                      -- if client.focus and tags[client.focus.screen][i] then
                          -- awful.client.toggletag(tags[client.focus.screen][i])
                      -- end
                  -- end))
-- end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
--
--
-- {{{ my customizations
function run_once(prg,arg_string,pname,screen)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then 
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. ")",screen)
    else
        awful.util.spawn_with_shell("pgrep -f -u $USER -x '" .. pname .. "' || (" .. prg .. " " .. arg_string .. ")",screen)
    end
end
-- }}}

run_once("xscreensaver","-no-splash")          -- starts xscreensaver
run_once("xsetroot", "-cursor_name left_ptr")  -- sets the cursor icon
