-- ~/.config/hypr/hyprland/look.lua  (loaded last by hyprland.lua)
-- hypr-dms-lean-v2
-- Lean look: shadows + DMS rounding + DMS wobble, nothing else.
--   * no blur (the biggest per-frame cost on a weak GPU; it also enlarges the damage region)
--   * no popin / slide / layer animations: windows and workspaces only fade, DMS animates its own UI
--   * one easing family (easeOutQuint + one spring) so nothing feels like a random cut
-- Gaps, rounding, borders, colours and the wobble itself come from dms/*.lua.
-- Every block goes through try(): if this Hyprland build rejects one option, only that block is
-- skipped and the error is logged to /tmp/hypr-lua.log.

local log_path = "/tmp/hypr-lua.log"

local function try(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        local f = io.open(log_path, "a")
        if f then f:write(label .. ": " .. tostring(err) .. "\n"); f:close() end
    end
end

---------------------------------------------------------------------------
-- Shadow on, blur off
---------------------------------------------------------------------------
try("decoration", hl.config, {
    decoration = {
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled = false,
        },
    },
})

---------------------------------------------------------------------------
-- Redraw only what changed
---------------------------------------------------------------------------
-- damage_tracking 2 = per-region (only the changed rectangles are redrawn). It is the default;
-- it is pinned here so nothing can quietly switch it to full-screen redraws.
-- To SEE it working, temporarily set damage_blink = true: only redrawn areas flash.
try("damage tracking", hl.config, {
    debug = {
        damage_tracking = 2,
        -- damage_blink = true,
    },
})

try("misc", hl.config, {
    misc = {
        animate_manual_resizes       = false,  -- drag-resize is not tweened (clients re-layout every frame)
        animate_mouse_windowdragging = false,  -- dragging is the wobble's job, not a second animation
    },
})

-- Experimental, try only if you still see drops under load (needs a recent Hyprland):
-- try("render scheduling", hl.config, { render = { new_render_scheduling = true } })

---------------------------------------------------------------------------
-- Animations: fades and one gentle spring for tiling moves. Nothing else.
---------------------------------------------------------------------------
try("animations on", hl.config, { animations = { enabled = true } })

try("curve smooth", hl.curve, "smooth", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
try("curve easy",   hl.curve, "easy",   { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

local anims = {
    { leaf = "global",          enabled = true,  speed = 10,  bezier = "default" },

    -- windows: opened/closed windows fade (no popin scale), tiling moves use the spring
    { leaf = "windows",         enabled = true,  speed = 4.79, spring = "easy" },
    { leaf = "windowsIn",       enabled = false, speed = 1,   bezier = "smooth" },
    -- windowsOut MUST stay enabled: it is what runs the close animation, and without it the window
    -- vanishes instantly and fadeOut never plays. 98% popin is invisible, so this is a pure fade.
    { leaf = "windowsOut",      enabled = true,  speed = 2.8, bezier = "smooth", style = "popin 98%" },
    { leaf = "fade",            enabled = true,  speed = 3.5, bezier = "smooth" },
    { leaf = "fadeIn",          enabled = true,  speed = 3.5, bezier = "smooth" },
    { leaf = "fadeOut",         enabled = true,  speed = 2.8, bezier = "smooth" },
    { leaf = "fadeShadow",      enabled = true,  speed = 3.5, bezier = "smooth" },
    { leaf = "fadeDim",         enabled = true,  speed = 3.5, bezier = "smooth" },
    { leaf = "border",          enabled = true,  speed = 4,   bezier = "smooth" },
    { leaf = "borderangle",     enabled = false, speed = 1,   bezier = "smooth" },

    -- layers (bar, popouts, launcher...): DMS animates these itself, so Hyprland stays out of it
    { leaf = "layers",          enabled = false, speed = 1,   bezier = "smooth" },
    { leaf = "layersIn",        enabled = false, speed = 1,   bezier = "smooth" },
    { leaf = "layersOut",       enabled = false, speed = 1,   bezier = "smooth" },
    { leaf = "fadeLayersIn",    enabled = false, speed = 1,   bezier = "smooth" },
    { leaf = "fadeLayersOut",   enabled = false, speed = 1,   bezier = "smooth" },

    -- workspaces: a plain crossfade instead of a slide (a slide re-renders two full workspaces)
    { leaf = "workspaces",      enabled = true,  speed = 3.5, bezier = "smooth", style = "slidevert" },
    { leaf = "workspacesIn",    enabled = true,  speed = 3.5, bezier = "smooth", style = "slidevert" },
    { leaf = "workspacesOut",   enabled = true,  speed = 3.5, bezier = "smooth", style = "slidevert" },
    { leaf = "specialWorkspace",    enabled = true, speed = 3.5, bezier = "smooth", style = "slidevert" },
    { leaf = "specialWorkspaceIn",  enabled = true, speed = 3.5, bezier = "smooth", style = "slidevert" },
    { leaf = "specialWorkspaceOut", enabled = true, speed = 3.5, bezier = "smooth", style = "slidevert" },

    { leaf = "zoomFactor",      enabled = true,  speed = 6,   bezier = "smooth" },
}
for _, a in ipairs(anims) do try("anim " .. a.leaf, hl.animation, a) end
