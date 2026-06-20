-- ╔══════════════════════════════════════════════════════════════╗
-- ║  WHICH-KEY — Descubrir keymaps al presionar <leader>         ║
-- ║                                                              ║
-- ║  v3 (folke rewrite): AUTO-DESCUBRE keymaps por el campo      ║
-- ║  `desc` que ya pusimos en las capas 1, 3 y 4. Solo           ║
-- ║  definimos los GRUPOS (prefijos) para organizar el popup.    ║
-- ║                                                              ║
-- ║  Presioná <leader> y esperá 200ms → popup con todos los      ║
-- ║  keymaps disponibles, agrupados y con iconos.                ║
-- ║                                                              ║
-- ║  Docs: https://github.com/folke/which-key.nvim                ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "folke/which-key.nvim",
  event = "VeryLazy",      -- cargar después del startup (no bloquea)

  opts = {
    preset = "modern",     -- UI moderna (vs "classic" o "helix")
    delay = 200,           -- ms antes de mostrar el popup

    -- ── Grupos: organizan el popup por jerarquía ──────────────
    -- Los keymaps individuales se auto-descubren por su `desc`.
    spec = {
      { "<leader>f", group = "find",    icon = "" },
      { "<leader>g", group = "git",     icon = "" },
      { "<leader>h", group = "hunk",    icon = "" },
      { "<leader>w", proxy = "<c-w>", group = "windows" },
      { "<leader>c", group = "code",    icon = "󰅩" },
      { "<leader>d", group = "diagnostics", icon = "󱖫" },
      { "<leader>l", group = "lsp",     icon = "󰒍" },
      { "<leader>t", group = "toggle",  icon = "" },
      { "<leader>q", group = "quit",    icon = "" },
    },

    -- Iconos para detectar automáticamente por patrón de descripción
    icons = {
      rules = {
        { pattern = "fzf", icon = "", color = "cyan" },
        { pattern = "grep", icon = "", color = "cyan" },
        { pattern = "lsp", icon = "󰒍", color = "green" },
        { pattern = "git", icon = "", color = "orange" },
        { pattern = "diagnostic", icon = "", color = "red" },
      },
    },

    -- Desactivar en buffers donde no tiene sentido
    disable = {
      ft = { "fzf", "TelescopePrompt" },
      bt = { "terminal" },
    },
  },

  keys = {
    -- <leader>? muestra los keymaps del buffer actual
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer local keymaps",
    },
  },
}
