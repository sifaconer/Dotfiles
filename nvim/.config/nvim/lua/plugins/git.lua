-- ╔══════════════════════════════════════════════════════════════╗
-- ║  GIT — gitsigns (hunk-level) + lazygit (repo-level TUI)      ║
-- ║                                                              ║
-- ║  gitsigns: signs en signcolumn, navegación de hunks,          ║
-- ║  stage/reset/preview, blame inline, diff toggle.             ║
-- ║                                                              ║
-- ║  lazygit: TUI de git completo en una tab terminal.            ║
-- ║  Sin plugin wrapper — un keymap abre la terminal.             ║
-- ║  Requiere: lazygit (en pacman.txt)                            ║
-- ║                                                              ║
-- ║  Docs: https://github.com/lewis6991/gitsigns.nvim             ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "lewis6991/gitsigns.nvim",
  lazy = false,

  config = function()
    local gitsigns = require("gitsigns")
    local map = vim.keymap.set

    gitsigns.setup({
      signs = {
        add          = { text = "┃" },
        change       = { text = "┃" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "┆" },
      },
      signcolumn = true,       -- signs en la signcolumn (siempre visible via options)
      numhl      = false,      -- no highlight el número de línea
      linehl     = false,      -- no highlight la línea completa
      current_line_blame = false,  -- OFF por defecto (toggle con <leader>hb)
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",  -- virtual text al final de la línea
        delay = 300,
      },
      current_line_blame_formatter = " <author>, <author_time:%R> - <summary>",

      on_attach = function(bufnr)
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- ── Navegación de hunks ────────────────────────────────
        -- ]c / [c: siguiente/anterior hunk.
        -- Si estás en vimdiff, usa el diff nativo de vim.
        map("n", "]c", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true })
          else gitsigns.nav_hunk("next") end
        end, { desc = "Next hunk" })

        map("n", "[c", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true })
          else gitsigns.nav_hunk("prev") end
        end, { desc = "Prev hunk" })

        -- ── Acciones: stage / reset / preview ──────────────────
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

        -- En visual: stage/reset solo las líneas seleccionadas
        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage hunk (visual)" })

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset hunk (visual)" })

        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

        -- ── Blame ──────────────────────────────────────────────
        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "Blame line (full)" })

        -- ── Diff ───────────────────────────────────────────────
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, { desc = "Diff this (~)" })

        -- ── Quickfix ───────────────────────────────────────────
        map("n", "<leader>hq", gitsigns.setqflist, { desc = "Hunks to quickfix" })
        map("n", "<leader>hQ", function() gitsigns.setqflist("all") end, { desc = "All hunks to quickfix" })

        -- ── Toggles ────────────────────────────────────────────
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame" })
        map("n", "<leader>tw", gitsigns.toggle_word_diff, { desc = "Toggle word diff" })

        -- ── Text object: ih = inside hunk ──────────────────────
        -- vih = seleccionar dentro de un hunk, cih = change inside hunk
        map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select hunk" })
      end,
    })

    -- ── lazygit: TUI completo en tab terminal ───────────────────
    -- Sin plugin wrapper. Abre lazygit en una tab nueva.
    -- Esc sale (configurado en keymaps.lua Capa 1).
    map("n", "<leader>gl", function()
      vim.cmd("tabnew | terminal lazygit")
      vim.bo.buflisted = false
      vim.cmd("startinsert")
    end, { desc = "Lazygit" })
  end,
}
