-- ╔══════════════════════════════════════════════════════════════╗
-- ║  TREESITTER — Sintaxis real (no regex)                       ║
-- ║                                                              ║
-- ║  Usamos branch=main (rewrite con API nativa de nvim 0.11+).  ║
--  El plugin gestiona parsers; el highlighting lo hace nvim      ║
-- ║  nativamente con vim.treesitter.start().                     ║
-- ║                                                              ║
-- ║  Docs: https://github.com/nvim-treesitter/nvim-treesitter     ║
-- ║  Rama main: https://github.com/nvim-treesitter/nvim-treesitter/tree/main ║
-- ╚══════════════════════════════════════════════════════════════╝

-- Parsers para los lenguajes del usuario + esenciales de nvim
local parsers = {
  -- Esenciales de nvim
  "lua", "vim", "vimdoc", "query",

  -- Lenguajes del usuario
  "go", "gomod", "gosum",           -- Go
  "python",                          -- Python
  "c", "cpp",                        -- C/C++
  "rust",                            -- Rust
  "typescript", "tsx", "javascript", -- TypeScript/JavaScript
  "elixir", "heex", "eex",           -- Elixir + templates

  -- Config y docs (útil para todos)
  "bash", "json", "yaml", "toml", "ini",
  "markdown", "markdown_inline",
  "html", "css", "regex", "git_config",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",          -- rewrite con API nativa (master está deprecated)
  lazy = false,             -- cargar al startup (necesario para highlighting)

  -- Recompilar parsers cuando el plugin se instala/actualiza
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,

  config = function()
    -- 1. Instalar parsers faltantes (idempotente: no reinstala los que ya están)
    require("nvim-treesitter").install(parsers)

    -- 2. Habilitar treesitter nativo para todos los filetypes con parser
    --    pcall: si un filetype no tiene parser, falla silenciosamente
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
      callback = function()
        if pcall(vim.treesitter.start) then
          -- Folding basado en treesitter (nvim nativo)
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          vim.wo.foldlevel = 99  -- empezar con todo desplegado
        end
      end,
    })
  end,
}
