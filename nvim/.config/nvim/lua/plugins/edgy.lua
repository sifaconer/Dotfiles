-- ╔══════════════════════════════════════════════════════════════╗
-- ║  EDGY — El "director": ancla windows a los bordes (chrome IDE)║
-- ║                                                              ║
-- ║  ESTE es el plugin que convierte splits sueltos en PANELES    ║
-- ║  ACOPLADOS estilo VSCode. No aporta contenido propio: toma    ║
-- ║  las ventanas de neo-tree / toggleterm / trouble (pasos 1-4)  ║
-- ║  y las fija a un borde con tamaño y título.                   ║
-- ║                                                              ║
-- ║  Mapa de la imagen → bordes:                                 ║
-- ║    left   → neo-tree (explorador)                            ║
-- ║    bottom → toggleterm (terminal) + Trouble + quickfix       ║
-- ║    right  → RESERVADO para el panel de IA (Capa 9)            ║
-- ║                                                              ║
-- ║  Requisitos (ya configurados en options.lua):                ║
-- ║    laststatus = 3   → statusline global (colapso completo)   ║
-- ║    splitkeep = screen → el editor no salta                   ║
-- ║                                                              ║
-- ║  Docs: https://github.com/folke/edgy.nvim                     ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "folke/edgy.nvim",
  event = "VeryLazy",

  opts = {
    -- ── BORDE INFERIOR: terminal + diagnósticos + listas ───────
    bottom = {
      -- Terminal toggleterm (solo la horizontal/no-flotante se ancla)
      {
        ft = "toggleterm",
        size = { height = 0.35 },
        filter = function(_, win)
          return vim.api.nvim_win_get_config(win).relative == ""
        end,
      },
      -- Panel de diagnósticos de trouble (integración nativa por string)
      "Trouble",
      -- Quickfix nativo de vim
      { ft = "qf", title = "QuickFix" },
      -- Help abre abajo en vez de tapar el editor
      {
        ft = "help",
        size = { height = 0.4 },
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
    },

    -- ── BORDE IZQUIERDO: explorador ────────────────────────────
    left = {
      {
        title = "Explorer",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "filesystem"
        end,
        size = { width = 0.2 },
      },
      {
        title = "Git",
        ft = "neo-tree",
        filter = function(buf)
          return vim.b[buf].neo_tree_source == "git_status"
        end,
        pinned = true,
        collapsed = true,
        open = "Neotree position=left git_status",
      },
    },

    -- ── BORDE DERECHO: RESERVADO para IA (Capa 9) ──────────────
    -- Cuando integremos el asistente (avante/codecompanion), su
    -- ventana se declara acá y queda anclada a la derecha, tal
    -- como en la imagen. Por ahora, vacío a propósito.
    right = {},

    -- ── Animación al abrir/cerrar paneles ──────────────────────
    animate = {
      enabled = true,
      fps = 100,
      cps = 120,
    },

    -- ── Opciones de las ventanas acopladas ─────────────────────
    wo = {
      winbar = true,             -- barrita con el título del panel
      winfixwidth = true,
      winfixheight = false,
    },

    -- ── Keymaps DENTRO de un panel acoplado ────────────────────
    keys = {
      -- ancho/alto con <C-w> + flechas
      ["<c-w>>"] = function(win) win:resize("width", 2) end,
      ["<c-w><lt>"] = function(win) win:resize("width", -2) end,
      ["<c-w>+"] = function(win) win:resize("height", 2) end,
      ["<c-w>-"] = function(win) win:resize("height", -2) end,
      ["<c-w>="] = function(win) win.view.edgebar:equalize() end,
    },
  },
}
