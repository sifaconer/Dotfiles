-- ╔══════════════════════════════════════════════════════════════╗
-- ║  LUALINE — Statusline                                        ║
-- ║                                                              ║
-- ║  theme = 'auto' hereda la paleta de catppuccin automáticamente║
-- ║  (default_integrations = true en colorscheme.lua).           ║
-- ║  globalstatus = true coincide con laststatus = 3 (options).  ║
-- ║                                                              ║
-- ║  Docs: https://github.com/nvim-lualine/lualine.nvim           ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "nvim-lualine/lualine.nvim",
  lazy = false,            -- statusline debe estar al startup
  dependencies = { "nvim-tree/nvim-web-devicons" },  -- iconos (ya instalado por fzf-lua)

  config = function()
    -- Función custom: muestra el nombre del LSP server activo
    local function lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then return "" end
      local names = {}
      for _, c in ipairs(clients) do
        table.insert(names, c.name)
      end
      return "󰒍 " .. table.concat(names, ", ")
    end

    require("lualine").setup({
      options = {
        theme = "auto",         -- catppuccin se aplica solo
        globalstatus = true,    -- una sola barra para todas las windows
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },

      sections = {
        -- ── Izquierda: quién + dónde ──────────────────────────
        lualine_a = { "mode" },                    -- NORMAL / INSERT / VISUAL
        lualine_b = { "branch" },                  --  main
        lualine_c = {
          { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
          { "filename", path = 1, symbols = { modified = " ●", readonly = " ", unnamed = "[sin nombre]" } },
          -- path = 1: ruta relativa (no solo el nombre, no ruta absoluta completa)
        },

        -- ── Derecha: qué pasa + dónde estás en el archivo ─────
        lualine_x = {
          { "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = "", warn = "", info = "", hint = "" } },
          lsp_status,     -- 󰒍 gopls, basedpyright
        },
        lualine_y = { "encoding" },                -- utf-8
        lualine_z = { "location", "progress" },    -- 42:15  30%
      },

      inactive_sections = {
        -- Statusline de windows inactivas (más sutil)
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
