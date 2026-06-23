-- ╔══════════════════════════════════════════════════════════════╗
-- ║  OPTIONS — Defaults de comportamiento de nvim                ║
-- ║  Cada opción tiene un comentario de POR QUÉ.                 ║
-- ║  Referencia: :help options                                   ║
-- ╚══════════════════════════════════════════════════════════════╝
local opt = vim.opt

-- ── Apariencia ────────────────────────────────────────────────
opt.termguicolors = true   -- habilita 24-bit colors (requerido por casi todo colorscheme)
opt.number = true          -- números de línea absolutos
opt.relativenumber = true  -- números relativos (para saltar con 5j, 10k, etc.)
opt.cursorline = true      -- highlight la línea del cursor
opt.signcolumn = "yes"     -- columna de signos siempre visible (evita que el texto salte con diagnostics)
opt.showmode = false       -- oculta -- INSERT -- (lo muestra lualine después)
opt.wrap = false           -- sin wrap por defecto (lo activás por archivo si querés)
opt.scrolloff = 8          -- mantén 8 líneas de contexto arriba/abajo del cursor
opt.sidescrolloff = 8      -- lo mismo horizontal
opt.laststatus = 3         -- statusline global (una sola barra para todas las windows)

-- ── Indentación ───────────────────────────────────────────────
opt.tabstop = 2            -- un tab = 2 espacios (visual)
opt.shiftwidth = 2         -- autoindent usa 2 espacios
opt.expandtab = true       -- tabs → espacios (consistencia entre editores)
opt.smartindent = true     -- autoindent inteligente (respeta {, }, etc.)
opt.breakindent = true     -- cuando hay wrap, la línea continuada alinea al nivel

-- ── Búsqueda ──────────────────────────────────────────────────
opt.ignorecase = true      -- búsqueda case-insensitive por defecto
opt.smartcase = true       -- PERO si escribís Mayúscula, vuelve case-sensitive
                          -- (truco: /foo busca foo y FOO; /Foo solo busca Foo)

-- ── Splits ────────────────────────────────────────────────────
opt.splitbelow = true      -- :split abre abajo (más natural)
opt.splitright = true      -- :vsplit abre a la derecha
opt.splitkeep = "screen"   -- el contenido no "salta" al abrir/cerrar paneles (requerido por edgy.nvim)

-- ── Persistencia ──────────────────────────────────────────────
opt.undofile = true        -- undo persiste entre sesiones (en ~/.local/state/nvim/undo)
opt.swapfile = false       -- sin swap files (raramente útiles hoy)
opt.backup = false         -- sin backups (usá git)
opt.updatetime = 250       -- velocidad de CursorHold (diagnostics, hover)
opt.timeoutlen = 400       -- tiempo para secuencia de teclas (más rápido que default 1000)

-- ── Clipboard ─────────────────────────────────────────────────
opt.clipboard = "unnamedplus"  -- yank/paste al clipboard del sistema (wl-clipboard en Wayland)

-- ── Misc ──────────────────────────────────────────────────────
opt.completeopt = { "menu", "menuone", "noselect" }  -- comportamiento del popup de completion
opt.inccommand = "split"   -- preview de :s/old/new/ en vivo (incríblemente útil)
opt.grepprg = "rg --vimgrep"  -- usa ripgrep para :grep (mucho más rápido que grep)
opt.fillchars = { eob = " " }  -- quita el ~ en líneas vacías (limpieza visual)
