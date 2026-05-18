-- ╔══════════════════════════════════════════════════════════════╗
-- ║  KEYBINDS — ⭐ Atajos de teclado (el archivo que más editarás)
-- ║                                                             ║
-- ║  SINTAXIS: hl.bind(keys, dispatcher, opts?)                 ║
-- ║  OPTS:   { locked, repeating, mouse, release, description } ║
-- ║  LAMBDA: hl.bind("K", function() ... end)                   ║
-- ║                                                             ║
-- ║  DISPATCHERS COMUNES:                                       ║
-- ║  hl.dsp.exec_cmd(cmd)           → ejecutar comando          ║
-- ║  hl.dsp.window.close()          → cerrar ventana            ║
-- ║  hl.dsp.window.float({action})  → toggle/set/unset          ║
-- ║  hl.dsp.window.fullscreen({mode}) → 0=real 1=max            ║
-- ║  hl.dsp.window.move({workspace/direction})                   ║
-- ║  hl.dsp.focus({direction/workspace})                         ║
-- ║  hl.dsp.layout(msg)             → comando al layout          ║
-- ║  hl.dsp.workspace.toggle_special(name) → scratchpad          ║
-- ╚══════════════════════════════════════════════════════════════╝

local mainMod = "SUPER"

-- ── Programas (cambiar aquí para usar tus apps) ──────────────
local terminal    = "ghostty"
local fileManager = "thunar"
local browser     = "firefox"
local menu        = "fuzzel"

-- ██ APPS ═════════════════════════════════════════════════════
hl.bind(mainMod .. " + Q",         hl.dsp.exec_cmd(terminal),    { description = "Terminal" })
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager), { description = "File Manager" })
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd(browser),     { description = "Browser" })
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(menu),        { description = "Launcher" })
hl.bind(mainMod .. " + V",         hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"),
    { description = "Clipboard history" })
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a -f hex"),
    { description = "Color picker" })

-- ██ WINDOW MANAGEMENT ════════════════════════════════════════
hl.bind(mainMod .. " + W",         hl.dsp.window.close(),                       { description = "Close" })
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = 0 }),      { description = "Fullscreen" })
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 1 }),      { description = "Maximize" })
hl.bind(mainMod .. " + T",         hl.dsp.window.float({ action = "toggle" }),  { description = "Toggle float" })
hl.bind(mainMod .. " + P",         hl.dsp.window.pseudo(),                      { description = "Pseudotile" })
hl.bind(mainMod .. " + J",         hl.dsp.layout("togglesplit"),                { description = "Toggle split" })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(
    "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
), { description = "Exit Hyprland" })

-- ██ FOCUS (vim h/j/k/l + flechas) ═══════════════════════════
hl.bind(mainMod .. " + h",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j",     hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- ██ MOVE WINDOWS (SUPER+SHIFT+vim) ══════════════════════════
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))

-- Ciclar ventanas (útil en floating)
hl.bind(mainMod .. " + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end, { description = "Cycle windows" })

-- ██ WORKSPACES 1-10 (loop Lua) ══════════════════════════════
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + CTRL + right",  hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + left",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down",    hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",      hl.dsp.focus({ workspace = "e-1" }))

-- ██ MOUSE ════════════════════════════════════════════════════
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ██ SCRATCHPAD ═══════════════════════════════════════════════
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- ██ SCREENSHOTS ══════════════════════════════════════════════
hl.bind("Print", hl.dsp.exec_cmd(
    'grim -g "$(slurp)" - | satty -f - --copy-command wl-copy -o ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png'
))
hl.bind(mainMod .. " + Print",  hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("CTRL + Print",         hl.dsp.exec_cmd("hyprshot -m output"))

-- ██ AUDIO / BRILLO / MEDIA ══════════════════════════════════
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),  { locked = true, repeating = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- ██ LOCK / POWER ═════════════════════════════════════════════
hl.bind(mainMod .. " + CTRL + L",  hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("wlogout"))
hl.bind("switch:on:Lid Switch",    hl.dsp.exec_cmd("hyprlock"), { locked = true })

-- ██ RESIZE (SUPER+CTRL+flechas, con repeat) ═════════════════
local step = 30
for _, d in ipairs({
    { key = "CTRL + right", delta = step .. " 0" },
    { key = "CTRL + left",  delta = "-" .. step .. " 0" },
    { key = "CTRL + up",    delta = "0 -" .. step },
    { key = "CTRL + down",  delta = "0 " .. step },
}) do
    hl.bind(mainMod .. " + " .. d.key, hl.dsp.window.resize({ delta = d.delta }), { repeating = true })
end

-- ██ FUNCIONES AVANZADAS (solo posibles en Lua) ═══════════════
hl.bind(mainMod .. " + SHIFT + G", function()
    local g = hl.get_config("general.gaps_in")
    if g.top == 4 then hl.config({ general = { gaps_in = 0, gaps_out = 0 } })
    else                hl.config({ general = { gaps_in = 4, gaps_out = 8 } }) end
end, { description = "Toggle gaps" })

hl.bind(mainMod .. " + SHIFT + B", function()
    local b = hl.get_config("decoration.blur.enabled")
    hl.config({ decoration = { blur = { enabled = not b } } })
end, { description = "Toggle blur" })
