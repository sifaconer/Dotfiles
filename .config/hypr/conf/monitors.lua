-- ╔══════════════════════════════════════════════════════════════╗
-- ║  MONITORS — Configuración de pantallas                      ║
-- ║  Para tu setup específico → editar userprefs.lua            ║
-- ║  Comandos: hyprctl monitors all | hyprctl monitors          ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Catch-all: cualquier monitor no listado explícitamente
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- ── Ejemplos (mover a userprefs.lua) ────────────────────────
-- hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "0x0", scale = "1" })
-- hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "2560x0", scale = "1" })
