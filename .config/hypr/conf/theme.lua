-- ╔══════════════════════════════════════════════════════════════╗
-- ║  THEME — Paleta de colores centralizada                     ║
-- ║                                                             ║
-- ║  ⭐ Cambiar de tema = editar SOLO este archivo.             ║
-- ║  Todos los módulos leen de la tabla global `Theme`.         ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ── Catppuccin Mocha ─────────────────────────────────────────
Theme = {
    name = "catppuccin-mocha",

    -- Base
    base      = "#1e1e2e",
    mantle    = "#181825",
    crust     = "#11111b",
    surface0  = "#313244",
    surface1  = "#45475a",
    surface2  = "#585b70",
    overlay0  = "#6c7086",
    overlay1  = "#7f849c",
    overlay2  = "#9399b2",

    -- Text
    text      = "#cdd6f4",
    subtext0  = "#a6adc8",
    subtext1  = "#bac2de",

    -- Accents
    rosewater = "#f5e0dc", flamingo = "#f2cdcd", pink   = "#f5c2e7",
    mauve     = "#cba6f7", red      = "#f38ba8", maroon = "#eba0ac",
    peach     = "#fab387", yellow   = "#f9e2af", green  = "#a6e3a1",
    teal      = "#94e2d5", sky      = "#89dceb", sapphire = "#74c7ec",
    blue      = "#89b4fa", lavender = "#b4befe",

    -- Hyprland borders (rgba)
    border_active_1 = "rgba(cba6f7ee)",
    border_active_2 = "rgba(89b4faee)",
    border_inactive = "rgba(313244aa)",
    border_angle    = 45,

    -- Shadow
    shadow_color = 0xee1a1a1a,

    -- Fonts
    font_mono = "Maple Mono NF",
    font_ui   = "Inter",
    font_size = 13,

    -- Cursor
    cursor_theme = "Bibata-Modern-Classic",
    cursor_size  = 24,

    -- GTK
    gtk_theme  = "catppuccin-mocha-mauve-standard+default",
    icon_theme = "Papirus-Dark",
}

-- Helper: generar rgba desde hex
function Theme.rgba(hex, alpha)
    alpha = alpha or "ff"
    return "rgba(" .. hex:gsub("^#", "") .. alpha .. ")"
end
