-- ╔══════════════════════════════════════════════════════════════╗
-- ║  AUTOCMDS — Cosas que pasan solas                             ║
-- ║                                                              ║
-- ║  MECANISMO: autocmd <Evento> <Patrón> <Comando>              ║
-- ║  augroup agrupa para que no se dupliquen al recargar.        ║
-- ║  Referencia: :help autocmd                                   ║
-- ╚══════════════════════════════════════════════════════════════╝
local api = vim.api

-- ── Highlight al yankear ──────────────────────────────────────
-- POR QUÉ: al yankear (y), no ves qué copiaste. Esto highlightea
-- la región yanked por 200ms. Feedback visual inmediato.
api.nvim_create_autocmd("TextYankPost", {
  group = api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ── Restaurar posición del cursor al abrir archivo ────────────
-- POR QUÉ: al reabrir un archivo, el cursor va a la línea 1.
-- Esto lo restaura a la última línea donde estuviste. Pequeño detalle
-- que ahorra muchos segundos acumulados.
api.nvim_create_autocmd("BufReadPost", {
  group = api.nvim_create_augroup("restore_cursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

-- ── Cerrar quickfix/loc con q ─────────────────────────────────
-- POR QUÉ: quickfix y location list son buffers especiales que solo
-- querés cerrar. Mapear q para :q ahorra :q!<CR> cada vez.
api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = { "qf", "help", "man", "lspinfo" },
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})
