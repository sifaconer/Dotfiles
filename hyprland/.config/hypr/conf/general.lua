-- ╔══════════════════════════════════════════════════════════════╗
-- ║  GENERAL — Gaps, bordes, layout, misc, cursor               ║
-- ║  QUÉ EDITAR: gaps_in/out, border_size, layout               ║
-- ║  Layouts: "dwindle" | "master" | "scrolling" | "lua:X"      ║
-- ╚══════════════════════════════════════════════════════════════╝

hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 2,
        col = {
            active_border = {
                colors = { Theme.border_active_1, Theme.border_active_2 },
                angle  = Theme.border_angle,
            },
            inactive_border = Theme.border_inactive,
        },
        resize_on_border  = true,
        allow_tearing     = false,
        layout            = "dwindle",
    },

    misc = {
        disable_hyprland_logo   = true,
        force_default_wallpaper = 0,
        enable_swallow          = true,
        swallow_regex           = "^(kitty|Alacritty|foot)$",
        middle_click_paste      = true,
    },

    xwayland = { force_zero_scaling = true },

    cursor = {
        no_hardware_cursors  = 2,
        enable_hyprcursor    = true,
        sync_gsettings_theme = true,
    },

    dwindle = { preserve_split = true, smart_split = false },
    master  = { new_status = "master", mfact = 0.55 },
    scrolling = { fullscreen_on_one_column = true },
})
