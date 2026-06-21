-- ╔══════════════════════════════════════════════════════════════╗
-- ║  TROUBLE — Panel de diagnósticos / errores LSP (v3)          ║
-- ║                                                              ║
-- ║  Slot en el layout: "ERRORES DE LSP Y SOLUCIONES" de la       ║
-- ║  imagen. Lista navegable de errores/warnings con preview.    ║
-- ║                                                              ║
-- ║  Complementa lo que ya tenés:                                ║
-- ║    - lualine muestra el CONTEO de diagnostics.               ║
-- ║    - fzf (<leader>fs/fS) busca símbolos de forma fuzzy.       ║
-- ║    - trouble da un PANEL persistente y navegable.            ║
-- ║                                                              ║
-- ║  diagnostics/qf/loclist → se anclarán ABAJO por edgy (paso 5)║
-- ║  symbols (<leader>cs) → panel derecho toggleable.            ║
-- ║                                                              ║
-- ║  Docs: https://github.com/folke/trouble.nvim                  ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    focus = false,                       -- al abrir no roba el foco del editor
  },

  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                desc = "Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",   desc = "Diagnostics del buffer" },
    { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>",        desc = "Symbols (outline)" },
    { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP refs/defs (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                    desc = "Location list (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                     desc = "Quickfix (Trouble)" },
  },
}
