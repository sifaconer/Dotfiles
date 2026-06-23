-- ╔══════════════════════════════════════════════════════════════╗
-- ║  BUFFERLINE — Barra de pestañas (buffers como tabs)          ║
-- ║                                                              ║
-- ║  Slot en el layout: "BARRA DE PESTAÑAS" de la imagen.        ║
-- ║                                                              ║
-- ║  CONCEPTO CLAVE (no es VSCode): en nvim un "buffer" es un     ║
-- ║  archivo en memoria; una "tab" es un LAYOUT de windows.      ║
-- ║  Lo que VSCode llama pestañas son BUFFERS. bufferline los     ║
-- ║  dibuja arriba como pestañas — pero seguís usando buffers,    ║
-- ║  no tabpages. Navegás con <S-h>/<S-l>.                        ║
-- ║                                                              ║
-- ║  offsets: deja hueco a la izquierda para que las pestañas    ║
-- ║  no queden encima de neo-tree.                                ║
-- ║                                                              ║
-- ║  Docs: https://github.com/akinsho/bufferline.nvim             ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  keys = {
    { "<S-h>",      "<cmd>BufferLineCyclePrev<cr>",     desc = "Prev buffer" },
    { "<S-l>",      "<cmd>BufferLineCycleNext<cr>",     desc = "Next buffer" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>",     desc = "Pin/unpin buffer" },
    { "<leader>bd", "<cmd>bdelete<cr>",                 desc = "Delete buffer" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>",   desc = "Close other buffers" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>",     desc = "Close buffers to the left" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>",    desc = "Close buffers to the right" },
  },

  opts = {
    options = {
      mode = "buffers",                  -- mostramos buffers, no tabpages
      diagnostics = "nvim_lsp",          -- muestra errores LSP en cada pestaña
      diagnostics_indicator = function(_, _, diag)
        local icons = { error = " ", warning = " " }
        local ret = (diag.error and icons.error .. diag.error .. " " or "")
          .. (diag.warning and icons.warning .. diag.warning or "")
        return vim.trim(ret)
      end,
      show_buffer_close_icons = true,
      show_close_icon = false,
      separator_style = "thin",

      -- ── Hueco para neo-tree (no se monta encima del explorador) ──
      offsets = {
        {
          filetype = "neo-tree",
          text = "EXPLORER",
          highlight = "Directory",
          text_align = "left",
          separator = true,
        },
      },
    },
  },
}
