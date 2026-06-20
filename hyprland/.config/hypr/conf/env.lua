-- ╔══════════════════════════════════════════════════════════════╗
-- ║  ENV — Variables de entorno (antes de init display server)  ║
-- ║  Si usas uwsm, mover a ~/.config/uwsm/env en su lugar.    ║
-- ╚══════════════════════════════════════════════════════════════╝

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Qt
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- GTK
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("GTK_USE_PORTAL", "1")

-- Apps
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- Cursor (lee de Theme)
hl.env("XCURSOR_THEME", Theme.cursor_theme)
hl.env("XCURSOR_SIZE", tostring(Theme.cursor_size))
hl.env("HYPRCURSOR_THEME", Theme.cursor_theme)
hl.env("HYPRCURSOR_SIZE", tostring(Theme.cursor_size))
