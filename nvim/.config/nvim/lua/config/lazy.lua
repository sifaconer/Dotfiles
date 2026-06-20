-- ╔══════════════════════════════════════════════════════════════╗
-- ║  LAZY.NVIM — Bootstrap y configuración del gestor de plugins ║
-- ║                                                              ║
-- ║  Tres pasos:                                                 ║
-- ║  1. Si lazy no está instalado, clonarlo de GitHub             ║
-- ║  2. Inicializarlo con config (paths, opciones)               ║
-- ║  3. Cargar specs desde lua/plugins/*.lua automáticamente     ║
-- ║                                                              ║
-- ║  Docs: https://lazyrocks.dev                                 ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ── 1. Bootstrap ──────────────────────────────────────────────
-- Si lazy.nvim no está en el rtp, clonarlo.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "Error cloning lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

-- ── 2. Setup ──────────────────────────────────────────────────
-- require("plugins") hace que lazy busque lua/plugins/*.lua como specs.
-- Cada archivo en esa carpeta es un spec (o una tabla de specs).
require("lazy").setup("plugins", {
  -- Detección automática de plugins en lua/plugins/
  -- (no hay que registrar nada manualmente)

  -- Colorscheme inicial (vacío — se setea en Capa 2 con catppuccin)
  install = { colorscheme = {} },

  -- Checker: avisar si hay updates (no instalar automáticamente)
  checker = { enabled = true, notify = false },

  -- Performance: no cargar plugins en voyeur mode
  change_detection = { notify = false },

  -- UI flotante bonita
  ui = { border = "rounded" },
})
