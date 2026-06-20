-- ╔══════════════════════════════════════════════════════════════╗
-- ║  CLANGD — C/C++ Language Server                              ║
-- ║                                                              ║
-- ║  LSP oficial de LLVM para C, C++, Objective-C.               ║
-- ║  Install: :MasonInstall clangd                               ║
-- ║                                                              ║ ║  Requiere compile_commands.json para proyectos reales:       ║
-- ║    ln -s build/compile_commands.json .                       ║
-- ║  Docs: https://clangd.llvm.org/                               ║
-- ╚══════════════════════════════════════════════════════════════╝
return {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git" },

  -- clangd soporta offset encoding utf-8 (nvim default) y utf-16
  capabilities = {
    textDocument = { completion = { editsNearCursor = true } },
    offsetEncoding = { "utf-8", "utf-16" },
  },

  on_init = function(client, init_result)
    -- Respetar el offset encoding que reporta clangd
    if init_result.offsetEncoding then
      client.offset_encoding = init_result.offsetEncoding
    end
  end,
}
