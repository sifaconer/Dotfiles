-- ╔══════════════════════════════════════════════════════════════╗
-- ║  ELIXIR-LS — Elixir Language Server                           ║
-- ║                                                              ║
-- ║  LSP para Elixir + HEEX templates + Surface.                  ║
-- ║  Soporta Phoenix, LiveView, Nerves.                           ║
-- ║                                                              ║
-- ║  Install: :MasonInstall elixir-ls                            ║
-- ║  Docs: https://github.com/elixir-lsp/elixir-ls                ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  -- mason instala el binario como 'elixir-ls' en su PATH
  -- (PATH=prepend en mason.lua lo hace encontrable)
  cmd = { "elixir-ls" },
  filetypes = { "elixir", "eelixir", "heex", "surface" },
  root_markers = { "mix.exs", ".git" },

  settings = {
    elixirLS = {
      -- dialyzer: análisis estático (puede ser lento en proyectos grandes)
      dialyzerEnabled = true,
      -- fetch deps automáticamente al abrir proyecto
      fetchDeps = false,
      -- sugerir specs al escribir
      suggestSpecs = true,
    },
  },
}
