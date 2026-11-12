-- ~/.config/hypr/hyprland/rules.lua
-- Window rules and layer rules.

----------------------
---- Window rules ----
----------------------

-- Every non-fullscreen window fully opaque
hl.window_rule({ match = { fullscreen = false }, opacity = "1 override" })

-- Apps (kitty) ask to maximize on open: ignore it, the tiler decides
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({ match = { float = true, xwayland = false }, center = true }) -- Center all floating windows (not xwayland, because of popups)

-- Floating applications
hl.window_rule({
    match = {
        class =
        "guifetch|yad|zenity|wev|org.gnome.FileRoller|file-roller|blueman-manager|com.github.GradienceTeam.Gradience|feh|imv|system-config-printer|org.quickshell",
    },
    tag   = "+float",
})
hl.window_rule({
    match = {
        title =
        "(Select|Open)( a)? (File|Folder)(s)?|File (Operation|Upload)( Progress)?|.* Properties|Export Image as PNG|GIMP Crash Debug|Save As|Library",
    },
    tag   = "+float",
})

hl.window_rule({ match = { tag = "float" }, float = true })

-- Opaque apps (terminal, image viewers, creative software, games): they want their own native transparency handling
hl.window_rule({
    match = {
        class =
        "kitty|equibop|org.quickshell|imv|swappy|krita|gimp|inkscape|darktable|resolve|kdenlive|shotcut|blender|godot|(steam_app_(default|[0-9]+))|gamescope",
    },
    tag   = "+opaque_app",
})

hl.window_rule({ match = { tag = "opaque_app" }, opaque = true })

-- Sized & centered floaters
hl.window_rule({ match = { class = "kitty", title = "nmtui" }, tag = "+float_60_70" })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol|yad-icon-browser" }, tag = "+float_60_70" })
hl.window_rule({ match = { class = "org.gnome.Settings" }, tag = "+float_70_80" })
hl.window_rule({ match = { class = "nwg-look" }, tag = "+float_50_60" })

hl.window_rule({
    match  = { tag = "float_60_70" },
    float  = true,
    size   = "(monitor_w*0.6) (monitor_h*0.7)",
    center = true,
})
hl.window_rule({
    match  = { tag = "float_70_80" },
    float  = true,
    size   = "(monitor_w*0.7) (monitor_h*0.8)",
    center = true,
})
hl.window_rule({
    match  = { tag = "float_50_60" },
    float  = true,
    size   = "(monitor_w*0.5) (monitor_h*0.6)",
    center = true,
})

-- Games (Steam, Lutris/Wine, Gamescope)
hl.window_rule({
    match        = { class = "(steam_app_(default|[0-9]+))|gamescope" },
    immediate    = true,
    idle_inhibit = "always",
})

-- Picture in picture (resize and move are done by the Super+Alt+\ bind)
hl.window_rule({
    match             = { title = "Picture(-| )in(-| )[Pp]icture" },
    move              = "(monitor_w*0.98-window_w) (monitor_h*0.97-window_h)",
    pin               = true,
    float             = true,
    keep_aspect_ratio = true,
})

-- Ugh, xwayland popups
hl.window_rule({ match = { xwayland = true, title = "win[0-9]+" }, tag = "+xwl_popup" })
hl.window_rule({
    match = { xwayland = true, title = "", class = "", initial_title = "", initial_class = "" },
    tag   = "+xwl_popup",
})
hl.window_rule({
    match     = { tag = "xwl_popup" },
    no_dim    = true,
    no_shadow = true,
    no_blur   = true,
    opaque    = true,
})

-- Special workspaces (Super+M music, Super+D communication)
hl.window_rule({ match = { class = ".*g4music.*" }, workspace = "special:music" })
hl.window_rule({ match = { class = "discord|equibop|vesktop|org\\.telegram\\.desktop|TelegramDesktop" }, workspace = "special:communication" })

---------------------
---- Layer rules ----
---------------------

hl.layer_rule({ match = { namespace = "hyprpicker" }, animation = "fade" }) -- colour picker
hl.layer_rule({ match = { namespace = "selection" }, animation = "fade" })  -- slurp
