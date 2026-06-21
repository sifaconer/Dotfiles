-- ╔══════════════════════════════════════════════════════════════╗
-- ║  TOGGLETERM — Terminal integrada (panel inferior)            ║
-- ║                                                              ║
-- ║  Slot en el layout: "PANEL INFERIOR" de la imagen.           ║
-- ║                                                              ║
-- ║  direction = "horizontal" → terminal abajo. ESTO es lo que   ║
-- ║  edgy.nvim (paso 5) anclará al borde inferior. Una terminal   ║
-- ║  flotante NO se acopla (edgy filtra ventanas flotantes).      ║
-- ║                                                              ║
-- ║  El Esc para salir del modo terminal ya está mapeado en      ║
-- ║  keymaps.lua (Capa 1) → <C-\><C-n>.                           ║
-- ║                                                              ║
-- ║  open_mapping <C-/> = el atajo "tipo VSCode" (Ctrl+ñ allá).   ║
-- ║                                                              ║
-- ║  Docs: https://github.com/akinsho/toggleterm.nvim             ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  keys = {
    { [[<C-/>]],    "<cmd>ToggleTerm<cr>",                       desc = "Terminal (toggle)", mode = { "n", "t" } },
    { "<leader>tt", "<cmd>ToggleTerm<cr>",                       desc = "Terminal (toggle)" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",       desc = "Terminal flotante" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",    desc = "Terminal vertical" },
  },

  opts = {
    open_mapping = [[<C-/>]],
    direction = "horizontal",            -- abajo (acoplable por edgy)
    size = function(term)
      -- horizontal: 15 líneas de alto; vertical: 40% del ancho
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.4)
      end
    end,
    shade_terminals = true,              -- oscurece levemente el fondo de la terminal
    persist_size = true,
    persist_mode = true,                 -- recuerda si estabas en insert/normal al re-abrir
    close_on_exit = true,                -- cierra la ventana cuando el proceso termina
    start_in_insert = true,
  },
}
