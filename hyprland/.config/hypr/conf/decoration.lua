-- ╔══════════════════════════════════════════════════════════════╗
-- ║  DECORATION — Blur, rounding, sombras, opacidad             ║
-- ║  QUÉ EDITAR: rounding, blur.size/passes, shadow.range       ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Estilo limpio y sutil (personalizable desde aquí)
hl.config({
    decoration = {
        rounding = 10, rounding_power = 2,
        active_opacity = 1.0, inactive_opacity = 0.95,
        blur = { enabled = true, size = 6, passes = 2,
                 new_optimizations = true, vibrancy = 0.17 },
        shadow = { enabled = true, range = 25, render_power = 3,
                   color = Theme.shadow_color },
    },
})
