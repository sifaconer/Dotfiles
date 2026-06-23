-- ╔══════════════════════════════════════════════════════════════╗
-- ║  NOICE — UI de cmdline / mensajes / popupmenu                ║
-- ║                                                              ║
-- ║  Slot en el layout: "LÍNEA DE COMANDOS DE VIM PERSISTENTE"    ║
-- ║  de la imagen — reemplaza la cmdline de abajo por un popup    ║
-- ║  central arriba (preset command_palette).                    ║
-- ║                                                              ║
-- ║  También enruta los mensajes (:messages) y los hovers/        ║
-- ║  signatures del LSP por una UI más linda con markdown.        ║
-- ║                                                              ║
-- ║  Va ÚLTIMO en la capa a propósito: toca el cmdline, que es    ║
-- ║  sensible. Si algo molesta, este es el primer sospechoso.    ║
-- ║                                                              ║
-- ║  Deps: nui.nvim (ya por neo-tree) + nvim-notify (notifs).    ║
-- ║  Docs: https://github.com/folke/noice.nvim                    ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },

  opts = {
    -- ── LSP: hovers y signatures con markdown renderizado ──────
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },

    -- ── Presets: comportamientos comunes ya resueltos ──────────
    presets = {
      command_palette = true,        -- cmdline + menú juntos, arriba al centro (como la imagen)
      bottom_search = true,          -- / y ? siguen abajo (búsqueda incremental natural)
      long_message_to_split = true,  -- mensajes largos van a un split, no tapan el editor
      lsp_doc_border = true,         -- borde en hovers/signatures
    },
  },
}
