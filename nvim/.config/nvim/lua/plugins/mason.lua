-- ╔══════════════════════════════════════════════════════════════╗
-- ║  MASON — Gestor de LSP servers, formatters, linters          ║
-- ║                                                              ║
-- ║  Instala tools dentro de ~/.local/share/nvim/mason/ (aislado  ║
-- ║  del sistema). No es AUR — instala desde fuentes oficiales.   ║
-- ║  :Mason para UI, :MasonInstall <tool> para instalar.          ║
-- ║  Docs: https://github.com/mason-org/mason.nvim                ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  {
    "mason-org/mason.nvim",
    lazy = false,           -- cargar al startup (necesario antes de LSP)
    priority = 90,          -- cargar antes que LSP pero después de blink

    opts = {
      PATH = "prepend",     -- bin de mason al inicio de PATH (LSP lo encuentra)
      ui = { border = "rounded" },
    },
  },

  -- Auto-instalar tools al abrir nvim (idempotente: no reinstala)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    dependencies = { "mason-org/mason.nvim" },

    opts = {
      -- Tools a auto-instalar. Se instalan en background al abrir nvim.
      -- ty NO está acá: usa el binario del sistema (~/.local/bin/ty, Astral).
      ensure_installed = {
        "gopls",           -- Go LSP
        "clangd",          -- C/C++ LSP
        "rust-analyzer",   -- Rust LSP
        "vtsls",           -- TypeScript/JavaScript LSP
        "elixir-ls",       -- Elixir LSP
      },
      auto_update = true,
      run_on_start = true,  -- instalar al arrancar nvim
    },
  },
}
