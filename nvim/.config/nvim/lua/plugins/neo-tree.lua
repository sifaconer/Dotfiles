-- ╔══════════════════════════════════════════════════════════════╗
-- ║  NEO-TREE — Explorador de archivos (panel lateral izquierdo)  ║
-- ║                                                              ║
-- ║  Slot en el layout: "BARRA LATERAL" de la imagen.            ║
-- ║  Por ahora abre como split normal a la izquierda. En la      ║
-- ║  Capa 8/paso 5, edgy.nvim lo ANCLA al borde como panel fijo. ║
-- ║                                                              ║
-- ║  Tres fuentes (sources): filesystem (archivos), git_status,  ║
-- ║  y buffers. Toggleás con <leader>e.                           ║
-- ║                                                              ║
-- ║  Docs: https://github.com/nvim-neo-tree/neo-tree.nvim         ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",                       -- lazy-load: solo al usar el comando o el keymap
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",       -- iconos (ya instalado por fzf-lua)
    "MunifTanjim/nui.nvim",              -- librería de UI que usa neo-tree
  },

  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>",            desc = "Explorer (toggle)" },
    { "<leader>E", "<cmd>Neotree reveal<cr>",            desc = "Explorer (reveal file)" },
    { "<leader>ge", "<cmd>Neotree git_status<cr>",       desc = "Explorer git status" },
  },

  opts = {
    close_if_last_window = true,         -- si neo-tree es la última window, cierra nvim
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,           -- muestra errores LSP sobre archivos/carpetas

    -- ── Cómo se ve y comporta la ventana ──────────────────────
    window = {
      position = "left",
      width = 32,
      mappings = {
        ["<space>"] = "none",            -- liberamos space (es nuestro leader)
        ["l"] = "open",                  -- l = abrir (natural en vim)
        ["h"] = "close_node",            -- h = cerrar nodo
        ["P"] = { "toggle_preview", config = { use_float = true } },
      },
    },

    filesystem = {
      follow_current_file = { enabled = true },   -- sigue el archivo abierto en el árbol
      use_libuv_file_watcher = true,              -- detecta cambios externos sin refrescar a mano
      filtered_items = {
        visible = false,                 -- ocultos no se ven...
        hide_dotfiles = false,           -- ...pero los dotfiles SÍ (útil en un repo de dotfiles)
        hide_gitignored = true,
      },
    },

    default_component_configs = {
      indent = { with_expanders = true },         -- flechas de expandir/colapsar
      git_status = {
        symbols = {
          added = "", modified = "", deleted = "", renamed = "",
          untracked = "", ignored = "", unstaged = "", staged = "", conflict = "",
        },
      },
    },
  },
}
