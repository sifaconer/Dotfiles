-- ╔══════════════════════════════════════════════════════════════╗
-- ║  NVIDIA — Auto-incluido por installer si detecta NVIDIA     ║
-- ║  Para incluir manualmente: añadir require("conf/nvidia")    ║
-- ║  en hyprland.lua después de require("conf/autostart")       ║
-- ╚══════════════════════════════════════════════════════════════╝

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("__GL_GSYNC_ALLOWED", "1")

hl.config({ cursor = { no_hardware_cursors = 2 } })
