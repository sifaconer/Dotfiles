-- ╔══════════════════════════════════════════════════════════════╗
-- ║  CATPPUCCIN — Colorscheme                                   ║
-- ║                                                              ║
-- ║  4 sabores: latte (light), frappe, macchiato, mocha (dark)   ║
-- ║  Usamos mocha para coherencia con Hyprland/quickshell.       ║
-- ║  Docs: https://github.com/catppuccin/nvim                     ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "catppuccin/nvim",
  name = "catppuccin",     -- renombra el dir del plugin (require("catppuccin"))
  lazy = false,            -- cargar al startup (colorscheme debe estar primero)
  priority = 1000,         -- cargar antes que otros plugins

  opts = {
    flavour = "mocha",     -- latte, frappe, macchiato, mocha
    background = { light = "latte", dark = "mocha" },
    transparent_background = false,  -- respetamos la opacidad del terminal

    styles = {
      comments = { "italic" },
      conditionals = { "italic" },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },

    -- Auto-integración: cuando agreguemos telescope, lualine, gitsigns,
    -- etc. en capas futuras, catppuccin los colorea automáticamente.
    default_integrations = true,
    auto_integrations = false,

    integrations = {
      treesitter = true,   -- highlighting de treesitter con paleta catppuccin
      -- Las siguientes se activan automáticamente cuando instalemos los plugins:
      -- telescope = { enabled = true },
      -- gitsigns = true,
      -- lualine = { enabled = true },
      -- mason = true,
      -- which_key = true,
    },
  },

  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin-nvim")
  end,
}
