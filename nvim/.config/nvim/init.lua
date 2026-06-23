-- ╔══════════════════════════════════════════════════════════════╗
-- ║  INIT.LUA — Entry point                                     ║
-- ║                                                              ║
-- ║  Setea el leader ANTES de cargar plugins (crítico: si un    ║
-- ║  plugin cachea el leader antes de que lo setees, sus        ║
-- ║  keymaps se rompen). Después carga la config modular.        ║
-- ╚══════════════════════════════════════════════════════════════╝

-- ── Leader keys ───────────────────────────────────────────────
-- Espacio como leader (lo más reachable en home row)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ── Config modular ────────────────────────────────────────────
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.neovide")   -- config GUI (se auto-salta si no estás en Neovide)
require("config.lazy")
