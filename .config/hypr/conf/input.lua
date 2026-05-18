-- ╔══════════════════════════════════════════════════════════════╗
-- ║  INPUT — Teclado, mouse, touchpad, gestos                   ║
-- ║  QUÉ EDITAR: kb_layout, kb_options, sensitivity, touchpad   ║
-- ║  Comandos: hyprctl devices | wev (ver keycodes)             ║
-- ╚══════════════════════════════════════════════════════════════╝

hl.config({
    input = {
        kb_layout  = "us,es",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle,caps:escape",
        kb_rules   = "",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            disable_while_typing = true,
        },
    },
})

-- Gestos touchpad
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down",       action = "close" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "move" })

-- Per-device (obtener nombres con: hyprctl devices)
-- hl.device({ name = "logitech-mx-master-3s", sensitivity = -0.3 })
