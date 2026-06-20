# Dotfiles — Hyprland + quickshell on Arch

Configuración de Hyprland en **Lua** con **quickshell** como shell (barra, notificaciones, futuros launcher y power menu). Sin AUR — todo desde repos oficiales. Font: **JetBrains Mono** + Nerd Font symbols vía fallback.

> **Estructura:** el repo usa **paquetes stow** — cada app es un dir top-level que replica su destino en `$HOME` (`pkg/.config/<app>` → `~/.config/<app>`). Agregar una app = crear una carpeta, **cero cambios** en `install.sh` o `Makefile`. Paquetes actuales: `hyprland`, `quickshell`, `kitty`, `nvim`, `tmux`, `yazi`, `fuzzel`, `gtk`, `fastfetch`, `starship`, `zsh`.

## Instalación

```bash
git clone https://github.com/sifaconer/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles
chmod +x install.sh
./install.sh                          # interactivo
./install.sh --yes                    # sin preguntas
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
# 4. SUPER+Q = kitty, SUPER+R = fuzzel (TODO: migrar a quickshell)
# 5. Diseñar tu shell en ~/.config/quickshell/shell.qml
```

---

## Mapa de archivos — Qué editar y dónde

### Hyprland (Lua 0.55+)

```
hyprland/.config/hypr/
├── hyprland.lua          ← ENTRY POINT: solo require()s
├── conf/
│   ├── theme.lua         ← ⭐ COLORES: cambiar tema = editar SOLO esto
│   ├── env.lua           ← ENV VARS: Qt, GTK, Wayland, cursor
│   ├── monitors.lua      ← MONITORES: catch-all (tu setup → userprefs.lua)
│   ├── general.lua       ← LAYOUT/GAPS/BORDERS
│   ├── decoration.lua    ← BLUR/ROUNDING/SHADOWS
│   ├── animations.lua    ← CURVAS BEZIER y transiciones
│   ├── input.lua         ← TECLADO/MOUSE/TOUCHPAD/GESTOS
│   ├── keybinds.lua      ← ⭐ ATAJOS (lo que más editarás)
│   ├── rules.lua         ← WINDOW/LAYER RULES
│   ├── autostart.lua     ← DAEMONS al iniciar (quickshell, hyprpaper, etc.)
│   └── nvidia.lua        ← NVIDIA (auto-incluido por installer)
├── userprefs.lua         ← ⭐ TUS OVERRIDES (nunca sobrescrito)
├── hyprlock.conf         ← Lock screen (hyprlang, no Lua)
├── hypridle.conf         ← Idle timeouts (hyprlang)
└── hyprpaper.conf        ← Wallpaper estático (hyprlang)
```

### Shell (quickshell — reemplaza waybar + mako)

```
quickshell/.config/quickshell/
└── shell.qml             ← SHELL: barra, notificaciones, futuros launcher/power
                            Live-reload al guardar. Docs: quickshell.outfoxxed.me
```

### Terminal y editor

```
kitty/.config/kitty/
└── kitty.conf            ← TERMINAL: font, opacity, colores (JetBrains Mono)
nvim/.config/nvim/        ← EDITOR: NvChad + lazy.nvim
├── init.lua              ← ENTRY POINT: bootstrap lazy + tema
├── lua/chadrc.lua        ← TEMA y UI de NvChad
├── lua/options.lua       ← opciones de neovim
├── lua/mappings.lua      ← atajos
├── lua/autocmds.lua      ← autocmds
├── lua/plugins/init.lua  ← plugins extra
├── lua/configs/          ← lazy, lspconfig, conform
└── lazy-lock.json        ← versiones pinneadas de plugins
```

### Herramientas

```
fuzzel/.config/fuzzel/fuzzel.ini     ← LAUNCHER (temporal, TODO: migrar a quickshell)
yazi/.config/yazi/yazi.toml          ← FILE MANAGER TUI: sort, hidden, opener
gtk/.config/{gtk-3.0,gtk-4.0}/settings.ini ← GTK dark + Papirus icons
fastfetch/.config/fastfetch/config.jsonc   ← SYSTEM INFO
starship/.config/starship.toml       ← PROMPT: formato, módulos, paleta
tmux/.config/tmux/tmux.conf          ← MULTIPLEXOR: prefix, splits, plugins
```

### Shell y sistema

```
zsh/.zshrc                ← SHELL: plugins zinit, aliases, exports
packages/
└── pacman.txt            ← Paquetes oficiales (sin AUR)
install.sh                ← INSTALADOR (descubre paquetes dinámicamente)
Makefile                  ← make install | stow | unstow | update
```

---

## Keybindings

| Keybind | Acción |
|---|---|
| `SUPER + Q` | Terminal (kitty) |
| `SUPER + R` | Launcher (fuzzel — TODO: quickshell popup) |
| `SUPER + B` | Browser (firefox) |
| `SUPER + E` | File manager (thunar) |
| `SUPER + W` | Cerrar ventana |
| `SUPER + F` | Fullscreen |
| `SUPER + T` | Toggle floating |
| `SUPER + h/j/k/l` | Focus vim-style |
| `SUPER + SHIFT + h/j/k/l` | Mover ventana |
| `SUPER + 1-0` | Workspace 1-10 |
| `SUPER + S` | Scratchpad |
| `SUPER + V` | Clipboard history (fuzzel — TODO: quickshell) |
| `SUPER + Tab` | Cycle windows |
| `Print` | Screenshot región + anotar (swappy) |
| `SUPER + Print` | Screenshot pantalla completa al clipboard |
| `CTRL + Print` | Screenshot región al clipboard |
| `SUPER + CTRL + L` | Lock (hyprlock) |
| `SUPER + SHIFT + L` | Power menu (TODO: quickshell) |
| `SUPER + SHIFT + G` | Toggle gaps |
| `SUPER + SHIFT + B` | Toggle blur |

## Extender

**Nuevo keybind** → `hyprland/.config/hypr/conf/keybinds.lua`:
```lua
hl.bind("SUPER + N", hl.dsp.exec_cmd("mi-app"))
```

**Nueva window rule** → `hyprland/.config/hypr/conf/rules.lua`:
```lua
hl.window_rule({ match = { class = "^MiApp$" }, float = true })
```

**Cambiar colores** → `hyprland/.config/hypr/conf/theme.lua` (paleta centralizada) + `quickshell/.config/quickshell/shell.qml` (colores del bar inline)

**Extender quickshell** → `quickshell/.config/quickshell/shell.qml`:
- Workspaces: `Quickshell.Hyprland.Hyprland`
- System tray: `Quickshell.Services.SystemTray`
- Audio: `Quickshell.Services.Pipewire`
- Red/batería: `Quickshell.Networking` / `Quickshell.Services.UPower`
- Launcher popup: `PopupWindow` + `DesktopEntries`
- Power menu: `PopupWindow` + `hl.exec_cmd("systemctl ...")`

Docs: https://quickshell.outfoxxed.me/docs/v0.3.0/guide

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
