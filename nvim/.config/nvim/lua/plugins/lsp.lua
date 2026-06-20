-- ╔══════════════════════════════════════════════════════════════╗
-- ║  LSP — Orquestador: capabilities, enable, keymaps, diagnostics║
-- ║                                                              ║
-- ║  Los configs de cada server están en lsp/<name>.lua.          ║
-- ║  Este archivo los habilita y configura el comportamiento      ║
-- ║  global de LSP (keymaps, diagnostics, capabilities).          ║
-- ║                                                              ║
-- ║  API nativa nvim 0.11+: vim.lsp.config() + vim.lsp.enable()  ║
-- ║  Sin nvim-lspconfig para configs (solo para :LspLog).         ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  "neovim/nvim-lspconfig",   -- solo por :LspLog y configs de referencia
  lazy = false,
  dependencies = {
    "mason-org/mason.nvim",   -- asegurar que mason carga antes
    "saghen/blink.cmp",       -- asegurar que blink carga antes (capabilities)
    "ibhagwan/fzf-lua",       -- asegurar que fzf-lua carga antes (LSP pickers)
  },

  config = function()
    local lsp = vim.lsp
    local map = vim.keymap.set
    local api = vim.api

    -- ── 1. Capabilities globales ─────────────────────────────
    -- blink.cmp le dice al LSP "soy un completion engine".
    -- Sin esto, el server no manda completions.
    lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- ── 2. Habilitar servers ──────────────────────────────────
    -- Los configs están en lsp/gopls.lua y lsp/basedpyright.lua.
    -- nvim los auto-carga. enable() arranca el server según filetype.
    lsp.enable({ "gopls", "basedpyright" })

    -- ── 3. Diagnostics ────────────────────────────────────────
    -- Cómo se muestran los errores/warnings/hints.
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",        -- bullet antes del mensaje
        spacing = 4,
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "",
          [vim.diagnostic.severity.INFO] = "",
        },
      },
      underline = true,
      update_in_insert = false,  -- no actualizar mientras escribís (performance)
      severity_sort = true,       -- errores antes que warnings
      float = {
        border = "rounded",
        source = "if_many",       -- mostrar fuente solo si hay múltiples
      },
    })

    -- ── 4. Keymaps por buffer (LspAttach) ─────────────────────
    -- LspAttach reemplaza on_attach en nvim 0.11+.
    -- Los keymaps son { buffer = bufnr } → se limpian solos al cerrar.
    api.nvim_create_autocmd("LspAttach", {
      group = api.nvim_create_augroup("lsp_keymaps", { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        local client = lsp.get_client_by_id(args.data.client_id)
        local fzf = require("fzf-lua")

        -- Saltar a definición/referencias (fzf-lua pickers)
        -- jump1=true: si hay 1 resultado, salta directo sin abrir picker
        map("n", "gd", function() fzf.lsp_definitions({ jump1 = true }) end, { buffer = bufnr, desc = "Go to definition" })
        map("n", "gD", function() lsp.buf.declaration() end, { buffer = bufnr, desc = "Go to declaration" })
        map("n", "gi", function() fzf.lsp_implementations({ jump1 = true }) end, { buffer = bufnr, desc = "Go to implementation" })
        map("n", "gr", function() fzf.lsp_references() end, { buffer = bufnr, desc = "Find references" })
        map("n", "gy", function() fzf.lsp_typedefs({ jump1 = true }) end, { buffer = bufnr, desc = "Go to type definition" })

        -- LSP finder: combina definitions + references + implementations en una vista
        map("n", "<leader>ls", function() fzf.lsp_finder() end, { buffer = bufnr, desc = "LSP finder (def+ref+impl)" })

        -- Hover (documentación del símbolo bajo el cursor) — nativo, fzf no lo reemplaza
        map("n", "K", function() lsp.buf.hover() end, { buffer = bufnr, desc = "Hover documentation" })

        -- Code actions (refactors, fixes, imports) — fzf-lua picker
        map({ "n", "v" }, "<leader>ca", function() fzf.lsp_code_actions() end, { buffer = bufnr, desc = "Code action" })

        -- Rename (renombrar símbolo en todo el proyecto) — nativo, fzf no lo reemplaza
        map("n", "<leader>rn", function() lsp.buf.rename() end, { buffer = bufnr, desc = "Rename symbol" })

        -- Formatear buffer — nativo, fzf no lo reemplaza
        map("n", "<leader>cf", function() lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "Format buffer" })

        -- Navegar diagnostics — ]d/[d nativos (jump), <leader>dl con fzf-lua picker
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { buffer = bufnr, desc = "Next diagnostic" })
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { buffer = bufnr, desc = "Previous diagnostic" })
        map("n", "<leader>dl", function() fzf.diagnostics_workspace() end, { buffer = bufnr, desc = "Diagnostics (workspace)" })

        -- Signature help (parámetros de función mientras escribís) — nativo
        map("i", "<C-k>", function() lsp.buf.signature_help() end, { buffer = bufnr, desc = "Signature help" })

        -- ── Format on save (opcional, por server) ──────────────
        -- Solo si el server soporta formatting. Se puede desactivar
        -- por buffer con :lua vim.b.disable_format = true
        if client and client:supports_method("textDocument/formatting") then
          api.nvim_create_autocmd("BufWritePre", {
            group = api.nvim_create_augroup("lsp_format_" .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function()
              if not vim.b.disable_format then
                lsp.buf.format({ bufnr = bufnr, async = false })
              end
            end,
          })
        end
      end,
    })
  end,
}
