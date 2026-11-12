-- ~/.config/hypr/hyprland.lua
-- Hyprland config: window rules, keybinds, look. The shell is DMS (started below).
require("hyprland.rules")
require("hyprland.keybinds")

hl.on("hyprland.start", function ()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("dms run")
end)

-- DMS-generated files (do not edit them by hand): colours, window rules, input, gaps/rounding, cursor.
pcall(require, "dms.colors")
pcall(require, "dms.windowrules")
require("dms.input")
require("dms.layout")
require("dms.cursor")

-- Look (shadow, blur, animations) is loaded LAST on purpose: DMS can't handle blur, and anything
-- loaded after dms/layout.lua wins, so blur set in look.lua can't be silently overridden.
-- pcall: a bad option here can never break the rest of the config.
package.loaded["hyprland.look"] = nil
pcall(require, "hyprland.look")
