-- ╔══════════════════════════════════════════════════════════════╗
-- ║  DECORATION — Blur, rounding, sombras, opacidad             ║
-- ║  Lee ~/.config/hypr/.variant para aplicar dev o macOS       ║
-- ║  QUÉ EDITAR: rounding, blur.size/passes, shadow.range       ║
-- ╚══════════════════════════════════════════════════════════════╝

local variant = "dev"
local vf = io.open(os.getenv("HOME") .. "/.config/hypr/.variant", "r")
if vf then variant = vf:read("*l") or "dev"; vf:close() end

if variant == "macos" then
    -- ══ macOS: blur vidrio, rounding alto, sombras pronunciadas ══
    hl.config({
        decoration = {
            rounding = 14, rounding_power = 2,
            active_opacity = 1.0, inactive_opacity = 0.92,
            blur = { enabled = true, size = 10, passes = 4,
                     new_optimizations = true, vibrancy = 0.18 },
            shadow = { enabled = true, range = 30, render_power = 3,
                       color = 0x7a000000 },
        },
        general = {
            gaps_in = 5, gaps_out = 12, border_size = 1,
            col = { active_border = "rgba(ffffff33)",
                    inactive_border = "rgba(00000022)" },
        },
    })
else
    -- ══ Dev: limpio, sutil, no distrae ══
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
end
