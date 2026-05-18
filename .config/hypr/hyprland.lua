-- ╔══════════════════════════════════════════════════════════════╗
-- ║  Hyprland 0.55+ Lua Configuration                          ║
-- ║  Repo: github.com/sifaconer/Dotfiles                       ║
-- ║                                                             ║
-- ║  Cada require() corre en scope Lua aislado:                 ║
-- ║  un error en un archivo NO rompe los demás.                 ║
-- ║                                                             ║
-- ║  Orden de carga:                                            ║
-- ║  1. env       → vars de entorno (antes del display server)  ║
-- ║  2. monitors  → configuración de pantallas                  ║
-- ║  3. theme     → paleta de colores centralizada              ║
-- ║  4. general   → gaps, bordes, layout, misc                  ║
-- ║  5. decoration→ blur, rounding, sombras, opacidad           ║
-- ║  6. animations→ curvas bezier y transiciones                ║
-- ║  7. input     → teclado, mouse, touchpad, gestos            ║
-- ║  8. keybinds  → ⭐ todos los atajos de teclado              ║
-- ║  9. rules     → window rules, layer rules                   ║
-- ║  10. autostart→ daemons y apps al iniciar                   ║
-- ║  11. userprefs→ TUS overrides (nunca sobrescrito)           ║
-- ╚══════════════════════════════════════════════════════════════╝

require("conf/env")
require("conf/monitors")
require("conf/theme")
require("conf/general")
require("conf/decoration")
require("conf/animations")
require("conf/input")
require("conf/keybinds")
require("conf/rules")
require("conf/autostart")

-- ── Overrides personales ─────────────────────────────────────
-- Este archivo NUNCA es tocado por updates del repo.
-- Pon aquí monitores, keybinds extra, ajustes personales.
require("userprefs")
