-- ~/.config/hypr/hyprland/functions.lua
-- Helpers used by keybinds.lua.
--
-- IMPORTANT: every helper that looks at the current window/monitor returns a FUNCTION that runs when
-- the key is pressed. (The old resize helper ran once while the config loaded, froze whichever window
-- was focused at that moment, and that is why Super+Alt+arrows / Super+-/+ worked "once in a while".)

-- Workspace groups: workspaces 1-10, 11-20, ... "focus"/"move" within a group or across groups.
local function wsaction(action, range, i)
    return function()
        local activews = hl.get_active_workspace()
        if activews then
            local id = activews.id
            local s  = (i - 1) * 10 + (id % 10)
            local t  = math.floor((id - 1) / 10) * 10 + i
            local z  = (range == "group") and s or t

            if action == "move" then
                return hl.dispatch(hl.dsp.window.move({ workspace = z }))
            else
                return hl.dispatch(hl.dsp.focus({ workspace = z }))
            end
        end
    end
end

-- Grow/shrink the focused window by a percent of ITS OWN current size (dx = width, dy = height).
local function resize_by_percent(dx, dy)
    return function()
        local win = hl.get_active_window()
        if not (win and win.size) then return end
        hl.dispatch(hl.dsp.window.resize({
            x = math.floor(win.size.x * dx / 100),
            y = math.floor(win.size.y * dy / 100),
            relative = true,
        }))
    end
end

-- Set the focused window to x% / y% of the monitor, then centre it.
local function size_and_center(x_percent, y_percent)
    return function()
        local screen = hl.get_active_monitor()
        if not (screen and type(screen.width) == "number" and type(screen.height) == "number") then return end
        local scale = screen.scale or 1 -- logical size = pixels / scale
        hl.dispatch(hl.dsp.window.resize({
            x = math.floor(screen.width / scale * x_percent / 100),
            y = math.floor(screen.height / scale * y_percent / 100),
            relative = false,
        }))
        hl.dispatch(hl.dsp.window.center())
    end
end

-- Picture-in-picture: shrink the window to ~1/4 of the screen height, pin it to the bottom-right corner.
local function move_actions(win)
    local screen = hl.get_active_monitor()

    if screen and screen.width and screen.height and win and win.size then
        local monitor_height = screen.height / screen.scale
        local monitor_width  = screen.width / screen.scale

        local scale_factor   = (monitor_height / 4) / win.size.y

        local target_width   = win.size.x * scale_factor
        local target_height  = win.size.y * scale_factor

        local x_resize       = math.floor(math.max(200, target_width))
        local y_resize       = math.floor(math.max(150, target_height))

        local offset         = math.min(monitor_width, monitor_height) * 0.03

        local move_x         = math.floor(screen.x + monitor_width - x_resize - offset)
        local move_y         = math.floor(screen.y + monitor_height - y_resize - offset)

        return {
            hl.dsp.window.resize({ x = x_resize, y = y_resize, window = win }),
            hl.dsp.window.move({ x = move_x, y = move_y, relative = false, window = win }),
        }
    end
end

-- Special workspace: show/hide it, and if it is empty, launch `cmd` into it.
-- Show first, launch second: Hyprland opens the window where the focus was at launch time, and the
-- other order hid the workspace as soon as the window appeared.
local function toggle_special(name, cmd)
    return function()
        local launch = cmd
        for _, ws in ipairs(hl.get_workspaces()) do
            if ws.name == "special:" .. name and ws.windows > 0 then launch = nil end
        end
        hl.dispatch(hl.dsp.workspace.toggle_special(name))
        if launch then hl.exec_cmd(launch) end
    end
end

-- Screen recording with gpu-screen-recorder: press the same bind again to stop.
local function record(region, sound)
    return function()
        local mon = hl.get_active_monitor()
        local w   = region and '-w region -region "$(slurp -f %wx%h+%x+%y)"' or "-w " .. (mon and mon.name or "region")
        hl.exec_cmd("pkill -INT -f '^gpu-screen-recorder' || gpu-screen-recorder " .. w ..
            (sound and " -a default_output" or "") .. ' -o "$(xdg-user-dir VIDEOS)/rec-$(date +%F_%H-%M-%S).mp4"')
    end
end

return {
    wsaction          = wsaction,
    resize_by_percent = resize_by_percent,
    size_and_center   = size_and_center,
    move_actions      = move_actions,
    toggle_special    = toggle_special,
    record            = record,
}
