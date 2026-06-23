-- ╔══════════════════════════════════════════════════════════════╗
-- ║  BLINK.CMP — Completion engine                               ║
-- ║                                                              ║
-- ║  Reemplaza nvim-cmp. Más rápido, menos configuración,         ║
-- ║  Lua-native. Soporta LSP, snippets, path, buffer sources.     ║
-- ║                                                              ║
-- ║  Pinned a v1.* (compatible con nvim 0.10+).                   ║
-- ║  v2 (main) requiere nvim 0.12+.                              ║
-- ║                                                              ║
-- ║  Docs: https://github.com/saghen/blink.cmp                    ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "saghen/blink.cmp",
  version = "1.*",          -- pin a v1 (compatible nvim 0.10+, descarga pre-built binary)
  lazy = false,            -- cargar al startup (necesario antes de LSP)
  priority = 100,          -- cargar antes que LSP (provee capabilities)

  dependencies = {
    "rafamadriz/friendly-snippets",  -- snippets para todos los lenguajes
  },

  opts = {
    -- super-tab: Tab acepta completion (VS Code style).
    -- Si el menú está cerrado, Tab funciona como indent normal.
    -- C-space: abrir menú manualmente. C-n/C-p: navegar. C-e: cerrar.
    keymap = { preset = "super-tab" },

    -- Mostrar documentación solo al activarla manualmente (C-space dos veces)
    completion = { documentation = { auto_show = false } },

    -- Sources en orden de prioridad
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    -- Fuzzy matcher: "rust" (pre-built binary, descargado automáticamente)
    fuzzy = { implementation = "rust" },

    -- Apariencia del menu
    appearance = {
      nerd_font_variant = "mono",
    },
  },

  opts_extend = { "sources.default" },
}
