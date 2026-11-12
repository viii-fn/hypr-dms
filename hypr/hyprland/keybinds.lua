-- ~/.config/hypr/hyprland/keybinds.lua
-- All keybinds. The `dms ipc call ...` binds open/close the DMS (Quickshell) panels.
local fn = require("hyprland.functions")

-- Shell (DMS)
hl.bind("SUPER + Return", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("dms ipc call settings toggle"))
hl.bind("SUPER + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("dms ipc call powermenu toggle"))

-- Lock
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("hyprlock"), { locked = true }) -- lock crashed: bring it back (session is still locked, so it needs `locked`)

-- Brightness: DMS moves the OSD immediately, brightnessctl catches up
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd('dms ipc call brightness increment 5 ""'), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd('dms ipc call brightness decrement 5 ""'), { locked = true, repeating = true })

-- Media
hl.bind("CTRL + SUPER + Space", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("CTRL + SUPER + Equal", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("CTRL + SUPER + Minus", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- Kill/restart the shell
hl.bind("CTRL + SUPER + SHIFT + R", hl.dsp.exec_cmd("dms kill"), { release = true })
hl.bind("CTRL + SUPER + ALT + R", hl.dsp.exec_cmd("dms restart"), { release = true })

-- Workspaces 1-10 (SUPER+1..0), groups of ten (CTRL+SUPER+1..0); ALT added = move the window there
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER + " .. key, fn.wsaction("focus", "", i))
    hl.bind("SUPER + ALT + " .. key, fn.wsaction("move", "", i))
    hl.bind("CTRL + SUPER + " .. key, fn.wsaction("focus", "group", i))
    hl.bind("CTRL + SUPER + ALT + " .. key, fn.wsaction("move", "group", i))
end

-- Go to workspace -1/+1
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "+1" }))
hl.bind("CTRL + SUPER + Left", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind("CTRL + SUPER + Right", hl.dsp.focus({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + Page_down", hl.dsp.focus({ workspace = "+1" }), { repeating = true })

-- Go to workspace group -1/+1
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "-10" }))
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "+10" }))

-- Move window to workspace -1/+1
hl.bind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("CTRL + SUPER + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind("CTRL + SUPER + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })

-- Window groups
hl.bind("ALT + TAB", hl.dsp.window.cycle_next(), { repeating = true })
hl.bind("SHIFT + ALT + TAB", hl.dsp.window.cycle_next({ next = false }), { repeating = true })
hl.bind("CTRL + ALT + Tab", hl.dsp.group.next(), { repeating = true })
hl.bind("CTRL + SHIFT + ALT + Tab", hl.dsp.group.prev(), { repeating = true })
hl.bind("SUPER + Comma", hl.dsp.group.toggle())
hl.bind("SUPER + U", hl.dsp.window.move({ out_of_group = true }))
hl.bind("SUPER + SHIFT + Comma", hl.dsp.group.lock())

-- Window actions
hl.bind("SUPER + J", hl.dsp.layout("togglesplit")) -- dwindle only

hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Resize by 10% of the window's current size (see functions.lua: runs at key press)
hl.bind("SUPER + Minus", fn.resize_by_percent(-10, 0), { repeating = true })
hl.bind("SUPER + Equal", fn.resize_by_percent(10, 0), { repeating = true })
hl.bind("SUPER + SHIFT + Minus", fn.resize_by_percent(0, -10), { repeating = true })
hl.bind("SUPER + SHIFT + Equal", fn.resize_by_percent(0, 10), { repeating = true })
hl.bind("SUPER + ALT + left", fn.resize_by_percent(-10, 0), { repeating = true })
hl.bind("SUPER + ALT + right", fn.resize_by_percent(10, 0), { repeating = true })
hl.bind("SUPER + ALT + up", fn.resize_by_percent(0, -10), { repeating = true })
hl.bind("SUPER + ALT + down", fn.resize_by_percent(0, 10), { repeating = true })

-- Mouse: drag to move, drag to resize
hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + Z", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + X", hl.dsp.window.resize(), { mouse = true })

hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.center())
hl.bind("CTRL + SUPER + ALT + Backslash", fn.size_and_center(55, 70))

-- Picture-in-picture: float, shrink, pin to the bottom-right corner
hl.bind("SUPER + ALT + backslash", function()
    local a = hl.get_active_window()
    if a then
        local pip = fn.move_actions(a) or {}
        if not a.floating then table.insert(pip, 1, hl.dsp.window.float()) end
        table.insert(pip, hl.dsp.window.pin({ action = "on", window = "address:" .. a.address }))

        for _, x in ipairs(pip) do
            hl.dispatch(x)
        end
    end
end)
hl.bind("SUPER + SHIFT + P", hl.dsp.window.pin())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind("SUPER + ALT + space", hl.dsp.window.float())
hl.bind("SUPER + C", hl.dsp.window.close())

-- Special workspaces (launch the app into it if the workspace is empty)
hl.bind("SUPER + M", fn.toggle_special("music", "g4music"))
hl.bind("SUPER + D", fn.toggle_special("communication", "Telegram"))

-- Apps
hl.bind("SUPER + Q", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd("pavucontrol"))

-- Utilities
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SUPER + ALT + R", fn.record(false, true))
hl.bind("CTRL + ALT + R", fn.record(false, false))
hl.bind("SUPER + SHIFT + ALT + R", fn.record(true, false))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + SHIFT + U", hl.dsp.exec_cmd("hyprctl kill"))

-- Volume (5% steps, max 100%)
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true }
)

-- Sleep (no hibernation set up: falls back to plain suspend)
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend-then-hibernate || systemctl suspend"), { locked = true })


-- Testing
hl.bind(
    "SUPER + ALT + F12",
    hl.dsp.exec_cmd(
        "notify-send -u low -i dialog-information-symbolic 'Test notification' " ..
        [["Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!"]] ..
        " -a 'Shell' -A 'Test1=I got it!' -A 'Test2=Another action'"
    )
)

-- Special workspace (Super+S toggles it, Super+Alt+S sends the window there)
hl.bind("SUPER + S", fn.toggle_special("special"))
hl.bind("SUPER + ALT + S", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + up", hl.dsp.window.move({ workspace = "special:special" }))
hl.bind("CTRL + SUPER + SHIFT + down", hl.dsp.window.move({ workspace = "e+0" }))
