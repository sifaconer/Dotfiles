-- ╔══════════════════════════════════════════════════════════════╗
-- ║  GOLPS — Go Language Server                                  ║
-- ║                                                              ║
-- ║  Auto-cargado por nvim desde lsp/gopls.lua.                  ║
-- ║  El filename (sin .lua) = nombre del server.                 ║
-- ║  Install: :MasonInstall gopls                                ║
-- ║  Docs: https://github.com/golang/tools/tree/master/gopls      ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gosum" },
  root_markers = { "go.mod", "go.work", ".git" },

  settings = {
    gopls = {
      -- gofumpt: formatting más estricto que gofmt (opcional, quitá si preferís gofmt)
      usePlaceholders = true,
      completeUnimported = true,
      analyses = {
        unusedparams = true,
        unusedwrite = true,
        nilness = true,
      },
      staticcheck = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
