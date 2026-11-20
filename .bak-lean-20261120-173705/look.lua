-- ~/.config/hypr/hyprland/look.lua  (loaded last by hyprland.lua)
-- Shadow, blur and animations. Gaps, rounding, borders and colours come from dms/*.lua.
-- Every block goes through try(): if this Hyprland build rejects one, only that block is skipped
-- and the error is logged to /tmp/hypr-lua.log.

local log_path = "/tmp/hypr-lua.log"

local function try(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        local f = io.open(log_path, "a")
        if f then f:write(label .. ": " .. tostring(err) .. "\n"); f:close() end
    end
end

---------------------------------------------------------------------------
-- Shadow + blur (the GPU is weak, so keep blur light)
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
            enabled  = true,
            size     = 3,
            passes   = 2,
            vibrancy = 0,
        },
    },
})

---------------------------------------------------------------------------
-- Animations: springs for windows, fades, layers, vertical workspaces
---------------------------------------------------------------------------
try("animations on", hl.config, { animations = { enabled = true } })

try("curve easeOutQuint",   hl.curve, "easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
try("curve easeInOutCubic", hl.curve, "easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
try("curve linear",         hl.curve, "linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
try("curve almostLinear",   hl.curve, "almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
try("curve quick",          hl.curve, "quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })
try("curve easy",           hl.curve, "easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

local anims = {
    { leaf = "global",        enabled = true, speed = 10,   bezier = "default" },
    { leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" },
    { leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" },
    { leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "easy", style = "popin 87%" },
    { leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" },
    { leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" },
    { leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" },
    { leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" },
    { leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" },
    { leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" },
    { leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear", style = "fade" },
    { leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" },
    { leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" },
    { leaf = "workspaces",    enabled = true, speed = 4,    bezier = "easeOutQuint", style = "slidevert" },
    { leaf = "workspacesIn",  enabled = true, speed = 4,    bezier = "easeOutQuint", style = "slidevert" },
    { leaf = "workspacesOut", enabled = true, speed = 4,    bezier = "easeOutQuint", style = "slidevert" },
    { leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" },
}
for _, a in ipairs(anims) do try("anim " .. a.leaf, hl.animation, a) end
