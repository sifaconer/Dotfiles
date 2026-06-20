-- ╔══════════════════════════════════════════════════════════════╗
-- ║  VTSLS — TypeScript/JavaScript Language Server               ║
-- ║                                                              ║
-- ║  Wrapper de tsserver con mejor performance y features.        ║
-- ║  Soporta monorepos automáticamente.                          ║
-- ║                                                              ║
-- ║  Install: :MasonInstall vtsls                                ║
-- ║  Docs: https://github.com/yioneko/vtsls                       ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", "tsconfig.json", "jsconfig.json", ".git" },

  init_options = { hostInfo = "neovim" },

  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      tsserver = {
        -- No mostrar diagnostics de tsserver (nvim los maneja via LSP)
        -- esto evita duplicados
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        parameterNames = { enabled = "all" },
        variableTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      inlayHints = {
        parameterNames = { enabled = "all" },
        variableTypes = { enabled = true },
      },
    },
  },
}
