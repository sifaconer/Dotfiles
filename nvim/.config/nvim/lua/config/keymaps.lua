-- ╔══════════════════════════════════════════════════════════════╗
-- ║  KEYMAPS — Atajos minimal                                   ║
-- ║                                                              ║
-- ║  PRINCIPIO: no remapear lo que vim ya hace bien.            ║
-- ║  Solo remapeamos lo claramente incómodo o que suma           ║
-- ║  comportamiento nuevo. Cada keymap tiene su POR QUÉ.         ║
-- ║  Referencia: :help map-modes                                 ║
-- ╚══════════════════════════════════════════════════════════════╝
local map = vim.keymap.set

-- ── Quitar resaltado de búsqueda ──────────────────────────────
-- POR QUÉ: después de /foo, todas las coincidencias quedan highlight.
-- Esc las limpia. Es el keymap más usado por usuarios vim.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- ── Navegar con j/k por líneas VISUALES (no lógicas) ──────────
-- POR QUÉ: con wrap=true, j salta líneas lógicas (no las que ves).
-- gj/gk navegan líneas visuales. Los remapeamos para que j/k hagan
-- lo correcto automáticamente.
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (visual line)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (visual line)" })

-- ── Mover líneas seleccionadas arriba/abajo ───────────────────
-- POR QUÉ: en visual block, mover líneas requiere :m o ddp.
-- J/K en visual las mueve directo. Súper útil para reordenar.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ── Mantener cursor centrado al navegar ───────────────────────
-- POR QUÉ: C-d/C-u saltan media página y el cursor queda arriba/abajo.
-- Con zz, el cursor queda en el centro — nunca perdés contexto.
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, cursor centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, cursor centered" })

-- ── Pegar sin perder el registro (ñ) ───────────────────────────
-- POR QUÉ: al pegar sobre texto en visual, el registro se sobreescribe.
-- Con P (mayúscula) en visual, pega SIN sobreescribir el registro.
map("x", "p", '"_dP', { desc = "Paste without overwriting register" })

-- ── Window management con leader+w ────────────────────────────
-- POR QUÉ: <C-w>v/s/q son incómodos. leader+w es más ergonómico.
map("n", "<leader>wv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>ws", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>wq", "<C-w>q", { desc = "Close window" })
map("n", "<leader>wh", "<C-w>h", { desc = "Focus left" })
map("n", "<leader>wl", "<C-w>l", { desc = "Focus right" })
map("n", "<leader>wj", "<C-w>j", { desc = "Focus down" })
map("n", "<leader>wk", "<C-w>k", { desc = "Focus up" })

-- ── Salir de terminal con Esc ─────────────────────────────────
-- POR QUÉ: en terminal mode, Esc no sale por defecto (usa <C-\><C-n>).
-- Lo remapeamos para que Esc sea intuitivo.
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ── Salir sin guardar con leader+q ────────────────────────────
-- POR QUÉ: :q! es tedioso de escribir. leader+q fuerza salida.
map("n", "<leader>qq", "<cmd>q!<CR>", { desc = "Force quit" })
