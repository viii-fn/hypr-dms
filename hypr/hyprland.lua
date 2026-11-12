-- Hyprland config: window rules, keybinds and look. The shell is DMS (started at the bottom).
require("hyprland.rules")
require("hyprland.keybinds")

-- look and feel (borders, rounding, shadow, blur, animations). pcall: can never break the rest.
package.loaded["hyprland.look"] = nil
pcall(require, "hyprland.look")

hl.on("hyprland.start", function ()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
--  hl.exec_cmd("hyprlock")
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP") 
  hl.exec_cmd("dms run")
end)

-- viii-removed: DMS is the only shell. Its colours colour the borders, its windows float.
-- (dms/input.lua and dms/layout.lua are left out on purpose: they would change scrolling and gaps.)
pcall(require, "dms.colors")
pcall(require, "dms.windowrules")
require("dms.input")
require("dms.layout")
require("dms.cursor")
