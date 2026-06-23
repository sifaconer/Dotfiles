-- ╔══════════════════════════════════════════════════════════════╗
-- ║  NEOVIDE — Config del GUI con GPU (solo aplica dentro de él)  ║
-- ║                                                              ║
-- ║  Todo este archivo se SALTA si no estás en Neovide. En kitty  ║
-- ║  no cambia nada (la transparencia la maneja kitty+Hyprland).  ║
-- ║                                                              ║
-- ║  Neovide aporta lo que el terminal NO puede: animación de     ║
-- ║  cursor sub-píxel, scroll fluido, ligaduras, render GPU.      ║
-- ║                                                              ║
-- ║  Docs: https://neovide.dev/configuration.html                 ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Guard: si no es Neovide, no hacemos nada.
if not vim.g.neovide then
  return
end

-- ── Fuente: misma que kitty (JetBrains Mono 13) para coherencia ──
vim.o.guifont = "JetBrains Mono:h13"

-- ── Opacidad: hereda la estética del rice ──────────────────────
-- Igual que kitty (0.92). Como catppuccin tiene transparent_background,
-- la ventana de Neovide queda translúcida y Hyprland le aplica BLUR.
vim.g.neovide_opacity = 0.92
vim.g.neovide_normal_opacity = 0.92

-- ── Respiración: padding alrededor del área de texto ───────────
vim.g.neovide_padding_top = 6
vim.g.neovide_padding_bottom = 6
vim.g.neovide_padding_left = 8
vim.g.neovide_padding_right = 8

-- ── Animaciones: lo que el terminal NO puede dar ───────────────
vim.g.neovide_refresh_rate = 60          -- fps con foco
vim.g.neovide_refresh_rate_idle = 5      -- fps sin foco (ahorra batería/GPU)

vim.g.neovide_cursor_animation_length = 0.08   -- duración del trail del cursor
vim.g.neovide_cursor_trail_size = 0.6
vim.g.neovide_cursor_vfx_mode = "railgun"      -- efecto de partículas al mover cursor
vim.g.neovide_scroll_animation_length = 0.25   -- scroll suave

-- ── Blur de las ventanas flotantes (interno de Neovide) ────────
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- ── Keymap: alternar pantalla completa ─────────────────────────
vim.keymap.set("n", "<F11>", function()
  vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end, { desc = "Neovide fullscreen" })
