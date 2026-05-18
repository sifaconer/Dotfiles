-- ╔══════════════════════════════════════════════════════════════╗
-- ║  RULES — Window rules y Layer rules                         ║
-- ║  QUÉ EDITAR: añadir reglas para tus apps específicas        ║
-- ║  Comando: hyprctl clients → ver class/title de ventanas     ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ██ GLOBAL ═══════════════════════════════════════════════════
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({ name = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true })

-- ██ FLOATING ═════════════════════════════════════════════════
hl.window_rule({ name = "float-system",
    match = { class = "^(pavucontrol|blueman-manager|nm-connection-editor|xdg-desktop-portal-gtk)$" },
    float = true })
hl.window_rule({ name = "float-dialogs",
    match = { title = "^(Open File|Save As|File Upload|Choose Files|Select a File)$" },
    float = true })
hl.window_rule({ name = "pip",
    match = { title = "^Picture%-in%-Picture$" },
    float = true, pin = true, size = "30% 30%", move = "100%-w-20 100%-h-20" })

-- ██ WORKSPACE ASSIGNMENTS ════════════════════════════════════
hl.window_rule({ name = "browser-ws2",
    match = { class = "^(firefox|chromium|brave-browser|zen)$" },
    workspace = "2 silent" })
hl.window_rule({ name = "code-ws3",
    match = { class = "^(Code|code-oss|codium|zed)$" },
    workspace = "3 silent" })

-- ██ OPACITY (terminales semi-transparentes) ══════════════════
hl.window_rule({ name = "terminal-opacity",
    match = { class = "^(ghostty|kitty|Alacritty|foot|com%.mitchellh%.ghostty)$" },
    opacity = "0.92 0.85" })

-- ██ IDLE INHIBIT ═════════════════════════════════════════════
-- NOTA: 'idleinhibit' no existe en hl.window_rule de 0.55 todavía.
-- Equivalente hyprlang: windowrulev2 = idleinhibit fullscreen, class:^(mpv|vlc)$
-- hl.window_rule({ name = "idle-inhibit-media",
--     match = { class = "^(firefox|mpv|vlc|FreeTube|chromium)$", fullscreen = true },
--     idleinhibit = "fullscreen" })

-- ██ PRIVACY ══════════════════════════════════════════════════
-- NOTA: 'noscreenshare' no existe en hl.window_rule de 0.55 todavía.
-- Equivalente hyprlang: windowrulev2 = noscreenshare, class:^(KeePassXC)$
-- hl.window_rule({ name = "noscreenshare-secrets",
--     match = { class = "^(KeePassXC|1Password)$" }, noscreenshare = true })

-- ██ SMART GAPS (sin gaps con 1 sola ventana tileada) ═════════
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
hl.window_rule({ name = "smart-gaps-tv1",
    match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
hl.window_rule({ name = "smart-gaps-f1",
    match = { float = false, workspace = "f[1]" }, border_size = 0, rounding = 0 })

-- ██ LAYER RULES (blur para barras, launchers, notificaciones) ═
hl.layer_rule({ name = "blur-waybar",
    match = { namespace = "waybar" }, blur = true })
    -- NOTA: 'ignorezero' no existe en hl.layer_rule de 0.55 (campo futuro)
hl.layer_rule({ name = "blur-launcher",
    match = { namespace = "^(rofi|fuzzel)$" }, blur = true })
hl.layer_rule({ name = "blur-notifications",
    match = { namespace = "^(notifications|swaync-control-center)$" }, blur = true })
hl.layer_rule({ name = "noanim-util",
    match = { namespace = "^(selection|hyprpicker)$" }, no_anim = true })
