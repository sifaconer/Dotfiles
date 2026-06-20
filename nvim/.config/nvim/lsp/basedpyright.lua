-- ╔══════════════════════════════════════════════════════════════╗
-- ║  BASEDPYRIGHT — Python Language Server                       ║
-- ║                                                              ║
-- ║  Fork de pyright con mejores defaults y más features.         ║
-- ║  Auto-cargado por nvim desde lsp/basedpyright.lua.            ║
-- ║  Install: :MasonInstall basedpyright                         ║
-- ║  Docs: https://github.com/DetachHead/basedpyright             ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },

  settings = {
    basedpyright = {
      -- Modo de analysis: "openFilesOnly" (rápido) o "all" (proyecto completo)
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "standard",  -- "off", "basic", "standard", "strict"
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          functionReturnTypes = true,
          parameterNames = true,
        },
      },
    },
  },
}
