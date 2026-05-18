-- ╔══════════════════════════════════════════════════════════════╗
-- ║  AUTOSTART — Daemons al iniciar (equivalente a exec-once)  ║
-- ║  ORDEN IMPORTA: polkit → dbus → wallpaper → bar → rest     ║
-- ║  Lee .variant para adaptar (dev=hyprpaper+mako, macos=swww+swaync)
-- ╚══════════════════════════════════════════════════════════════╝

hl.on("hyprland.start", function()
    -- 1. Polkit
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- 2. Propagar env a dbus/systemd (CRÍTICO para portals)
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- 3. Wallpaper (variante)
    local variant = "dev"
    local vf = io.open(os.getenv("HOME") .. "/.config/hypr/.variant", "r")
    if vf then variant = vf:read("*l") or "dev"; vf:close() end

    if variant == "macos" then
        hl.exec_cmd("swww-daemon")
        hl.exec_cmd("sleep 1 && swww img ~/Pictures/Wallpapers/current.jpg --transition-type fade --transition-duration 2")
    else
        hl.exec_cmd("hyprpaper")
    end

    -- 4. Status bar
    hl.exec_cmd("waybar")

    -- 5. Notificaciones (variante)
    if variant == "macos" then
        hl.exec_cmd("swaync")
    else
        hl.exec_cmd("mako")
    end

    -- 6. Clipboard
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- 7. Idle
    hl.exec_cmd("hypridle")

    -- 8. Tray
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")

    -- 9. Plugins
    hl.exec_cmd("hyprpm reload -n")
end)
