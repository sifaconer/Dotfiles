-- ╔══════════════════════════════════════════════════════════════╗
-- ║  RUST-ANALYZER — Rust Language Server                        ║
-- ║                                                              ║
-- ║  LSP oficial de Rust. Soporta cargo, inlay hints,             ║
-- ║  expand macro, run/debug, hover con docs de rustdoc.          ║
-- ║                                                              ║
-- ║  Install: :MasonInstall rust-analyzer                        ║
-- ║  Docs: https://rust-analyzer.github.io/book/configuration.html║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },

  capabilities = {
    experimental = { serverStatusNotification = true },
  },

  -- No setear init_options — rust-analyzer lo popula automáticamente
  -- desde settings["rust-analyzer"] según su documentación.
  before_init = function(init_params, config)
    if config.settings and config.settings["rust-analyzer"] then
      init_params.initializationOptions = config.settings["rust-analyzer"]
    end
  end,

  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
      checkOnSave = true,
      -- procMacro = { enable = true },  -- descomentar si usás macros procedurales
      inlayHints = {
        bindingModeHints = false,
        chainingHints = true,
        closureReturnTypeHints = { enable = "always" },
        lifetimeElisionHints = { enable = "never" },
        parameterHints = true,
        typeHints = true,
      },
    },
  },
}
