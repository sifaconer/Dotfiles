# Dotfiles — Hyprland 0.55+ Lua on CachyOS/Arch

Configuración completa de Hyprland en **Lua** con dos variantes visuales, instalador interactivo, y stack CLI moderna. Font: **Maple Mono NF**.

## Variantes

| | Dev Minimalista | macOS-like |
|---|---|---|
| **Tema** | Catppuccin Mocha | WhiteSur Dark |
| **Blur** | Sutil (6, 2 passes) | Vidrio (10, 4 passes) |
| **Rounding** | 10px | 14px |
| **Gaps** | 4/8 | 5/12 |
| **Bordes** | Gradient mauve→blue, 2px | Blanco sutil, 1px |
| **Wallpaper** | hyprpaper (estático) | swww (transiciones) |
| **Notificaciones** | mako | swaync (notification center) |
| **Launcher** | fuzzel | rofi-wayland (Spotlight) |
| **Dock** | — | nwg-dock-hyprland |

## Instalación

```bash
git clone https://github.com/sifaconer/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles
chmod +x install.sh
./install.sh                          # interactivo
./install.sh --yes --variant dev      # sin preguntas, dev
./install.sh --yes --variant macos    # sin preguntas, macOS
./install.sh --skip-packages          # solo symlinks
./install.sh --uninstall              # remover symlinks
```

## Post-instalación

```bash
# 1. Wallpaper
ln -sf ~/Pictures/Wallpapers/mi-wall.jpg ~/Pictures/Wallpapers/current.jpg
# 2. Editar monitores/keybinds personales
nvim ~/.config/hypr/userprefs.lua
# 3. Reboot → seleccionar Hyprland en greetd
# 4. SUPER+Q = terminal, SUPER+R = launcher
```

---

## Mapa de archivos — Qué editar y dónde

### Hyprland (Lua 0.55+)

```
.config/hypr/
├── hyprland.lua          ← ENTRY POINT: solo require()s
├── conf/
│   ├── theme.lua         ← ⭐ COLORES: cambiar tema = editar SOLO esto
│   ├── env.lua           ← ENV VARS: Qt, GTK, Wayland, cursor
│   ├── monitors.lua      ← MONITORES: catch-all (tu setup → userprefs.lua)
│   ├── general.lua       ← LAYOUT/GAPS/BORDERS
│   ├── decoration.lua    ← BLUR/ROUNDING/SHADOWS (lee .variant auto)
│   ├── animations.lua    ← CURVAS BEZIER y transiciones
│   ├── input.lua         ← TECLADO/MOUSE/TOUCHPAD/GESTOS
│   ├── keybinds.lua      ← ⭐ ATAJOS (lo que más editarás)
│   ├── rules.lua         ← WINDOW/LAYER RULES
│   ├── autostart.lua     ← DAEMONS al iniciar (lee .variant auto)
│   └── nvidia.lua        ← NVIDIA (auto-incluido por installer)
├── userprefs.lua         ← ⭐ TUS OVERRIDES (nunca sobrescrito)
├── .variant              ← "dev" o "macos" (escrito por installer)
├── hyprlock.conf         ← Lock screen (hyprlang, no Lua)
├── hypridle.conf         ← Idle timeouts (hyprlang)
└── hyprpaper.conf        ← Wallpaper estático (hyprlang)
```

### Herramientas

```
.config/
├── waybar/
│   ├── config.jsonc      ← MÓDULOS de la barra
│   └── style.css         ← ESTILOS (@define-color para cambiar paleta)
├── ghostty/config        ← TERMINAL: font, theme, opacity
├── fuzzel/fuzzel.ini     ← LAUNCHER: font, colores
├── mako/config           ← NOTIFICACIONES (dev): colores, timeout
├── yazi/yazi.toml        ← FILE MANAGER TUI: sort, hidden, opener
├── wlogout/{layout,style.css} ← POWER MENU
├── gtk-3.0/settings.ini  ← GTK3 theme/icons/cursor
├── gtk-4.0/settings.ini  ← GTK4
├── fastfetch/config.jsonc← SYSTEM INFO
├── starship.toml         ← PROMPT: formato, módulos, paleta
└── tmux/tmux.conf        ← MULTIPLEXOR: prefix, splits, plugins
```

### Shell y sistema

```
home/.zshrc               ← SHELL: plugins zinit, aliases, exports
packages/
├── pacman.txt            ← Paquetes oficiales
├── aur.txt               ← Paquetes AUR (ambas variantes)
└── aur-macos.txt         ← Paquetes AUR extra (macOS)
install.sh                ← INSTALADOR
Makefile                  ← make install | stow | unstow | update
```

---

## Keybindings

| Keybind | Acción |
|---|---|
| `SUPER + Q` | Terminal (ghostty) |
| `SUPER + R` | Launcher (fuzzel) |
| `SUPER + B` | Browser (firefox) |
| `SUPER + E` | File manager (thunar) |
| `SUPER + W` | Cerrar ventana |
| `SUPER + F` | Fullscreen |
| `SUPER + T` | Toggle floating |
| `SUPER + h/j/k/l` | Focus vim-style |
| `SUPER + SHIFT + h/j/k/l` | Mover ventana |
| `SUPER + 1-0` | Workspace 1-10 |
| `SUPER + S` | Scratchpad |
| `SUPER + V` | Clipboard history |
| `SUPER + Tab` | Cycle windows |
| `Print` | Screenshot región |
| `SUPER + CTRL + L` | Lock screen |
| `SUPER + SHIFT + L` | Power menu |
| `SUPER + SHIFT + G` | Toggle gaps |
| `SUPER + SHIFT + B` | Toggle blur |

## Extender

**Nuevo keybind** → `.config/hypr/conf/keybinds.lua`:
```lua
hl.bind("SUPER + N", hl.dsp.exec_cmd("mi-app"))
```

**Nueva window rule** → `.config/hypr/conf/rules.lua`:
```lua
hl.window_rule({ match = { class = "^MiApp$" }, float = true })
```

**Cambiar colores** → `.config/hypr/conf/theme.lua` + waybar `style.css` + `fuzzel.ini` + `mako/config`

**Layout custom** →
```lua
hl.layout.register("cols", {
    recalculate = function(ctx)
        for i, t in ipairs(ctx.targets) do t:place(ctx:column(i, #ctx.targets)) end
    end,
})
```

## CLI Stack

| Reemplaza | Tool | Alias |
|---|---|---|
| ls | eza | `ls`, `ll`, `lt` |
| cat | bat | `cat` |
| grep | ripgrep | `grep` |
| find | fd | `find` |
| cd | zoxide | `cd` |
| htop | btop | `top` |
| du/df | dust/duf | `du`, `df` |
| git TUI | lazygit | `lg` |
| ranger | yazi | `y` |
| history | atuin | Ctrl+R |

## License

MIT
