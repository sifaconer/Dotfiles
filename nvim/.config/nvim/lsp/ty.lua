-- ╔══════════════════════════════════════════════════════════════╗
-- ║  TY — Python Language Server (Astral, Rust)                  ║
-- ║                                                              ║
-- ║  Type checker y LSP extremadamente rápido, escrito en Rust    ║
-- ║  por el equipo de ruff/uv (Astral). Reemplaza basedpyright.   ║
-- ║                                                              ║
-- ║  Binario: ~/.local/bin/ty (instalado por Astral, NO mason)    ║
-- ║  Docs: https://docs.astral.sh/ty/                             ║
-- ║  Config: https://docs.astral.sh/ty/configuration/             ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },

  -- Settings opcionales (ver https://docs.astral.sh/ty/reference/configuration/)
  settings = {
    ty = {
      -- pythonVersion = "3.12",  -- descomentar para fijar versión target
      -- extendExclude = {},      -- paths adicionales a excluir
    },
  },
}
