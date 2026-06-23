-- ╔══════════════════════════════════════════════════════════════╗
-- ║  FZF-LUA — Fuzzy finder                                      ║
-- ║                                                              ║
-- ║  Usa el binary de fzf (C) para fuzzy matching. Mucho más     ║
-- ║  rápido que telescope (Lua). Profile "telescope" mimetea     ║
-- ║  la UI de telescope sin el overhead.                          ║
-- ║                                                              ║
-- ║  Reemplaza: telescope.nvim                                   ║
-- ║  Requiere: fzf + ripgrep (ya en pacman.txt)                   ║
-- ║  Docs: https://github.com/ibhagwan/fzf-lua                    ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "ibhagwan/fzf-lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    local fzf = require("fzf-lua")
    local map = vim.keymap.set

    fzf.setup({
      "telescope",  -- profile base: UI estilo telescope con perf de fzf

      winopts = {
        border = "rounded",
        preview = {
          layout = "flex",        -- horizontal o vertical según espacio
          flip_columns = 120,     -- cambia a vertical si < 120 columnas
        },
      },

      keymap = {
        builtin = {
          ["<F1>"] = "toggle-help",
          ["<F2>"] = "toggle-fullscreen",
          ["<F4>"] = "toggle-preview",
        },
        fzf = {
          ["ctrl-z"] = "abort",
          ["ctrl-u"] = "unix-line-discard",
          ["ctrl-a"] = "beginning-of-line",
        },
      },

      -- Defaults de los pickers
      files = { cwd_prompt = true, prompt = "❯ " },
      grep = { prompt = "rg❯ " },
      buffers = { sort_lastused = true, prompt = "buf❯ " },
    })

    -- ── Keymaps: archivos / grep / buffers / help ──────────────
    map("n", "<leader>ff", fzf.files, { desc = "Find files" })
    map("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
    map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
    map("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
    map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
    map("n", "<leader>fc", fzf.commands, { desc = "Commands" })

    -- ── Keymaps: símbolos LSP (globales, no por buffer) ────────
    map("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Document symbols" })
    map("n", "<leader>fS", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })

    -- ── Keymaps: git ───────────────────────────────────────────
    map("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
    map("n", "<leader>gb", fzf.git_branches, { desc = "Git branches" })
    map("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
  end,
}
