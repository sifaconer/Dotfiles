-- ╔══════════════════════════════════════════════════════════════╗
-- ║  AUTOSTART — Daemons al iniciar (equivalente a exec-once)  ║
-- ║  ORDEN IMPORTA: polkit → dbus → wallpaper → shell → rest    ║
-- ╚══════════════════════════════════════════════════════════════╝

hl.on("hyprland.start", function()
    -- 1. Polkit
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- 2. Propagar env a dbus/systemd (CRÍTICO para portals)
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- 3. Wallpaper (hyprpaper, estático)
    hl.exec_cmd("hyprpaper")

    -- 4. Shell — quickshell (bar + notificaciones + futuros launcher/power menu)
    hl.exec_cmd("qs")

    -- 5. Clipboard
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- 6. Idle
    hl.exec_cmd("hypridle")

    -- 7. Tray (los applets proveen items al bus; quickshell los muestra via SystemTray)
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")

    -- 8. Plugins
    hl.exec_cmd("hyprpm reload -n")
end)
