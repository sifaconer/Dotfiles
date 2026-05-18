#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  DOTFILES INSTALLER — Hyprland on CachyOS/Arch              ║
# ║  Uso: ./install.sh | ./install.sh --yes --variant dev|macos ║
# ╚══════════════════════════════════════════════════════════════╝
set -Euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

readonly SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
readonly TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
readonly LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
readonly LOG_FILE="${LOG_DIR}/install-${TIMESTAMP}.log"
readonly BACKUP_DIR="$HOME/.config-backup-${TIMESTAMP}"

ASSUME_YES=0; INSTALL_PACKAGES=1; VARIANT=""; UNINSTALL=0; AUR=""; GPU="unknown"

CR=$'\e[0m'; CB=$'\e[1m'; CG=$'\e[32m'; CRD=$'\e[31m'; CY=$'\e[33m'
CBL=$'\e[34m'; CM=$'\e[35m'; CC=$'\e[36m'; CD=$'\e[2m'
info()  { printf '%s[INFO]%s %s\n'  "$CBL" "$CR" "$*" | tee -a "$LOG_FILE"; }
ok()    { printf '%s[ OK ]%s %s\n'  "$CG"  "$CR" "$*" | tee -a "$LOG_FILE"; }
warn()  { printf '%s[WARN]%s %s\n'  "$CY"  "$CR" "$*" | tee -a "$LOG_FILE" >&2; }
die()   { printf '%s[FAIL]%s %s\n'  "$CRD" "$CR" "$*" | tee -a "$LOG_FILE" >&2; exit 1; }

trap 'warn "Error at line ${BASH_LINENO[0]}: ${BASH_COMMAND}"' ERR
trap 'warn "Interrupted"; exit 130' INT TERM

have() { command -v "$1" &>/dev/null; }

ask() {
    local prompt="$1" default="${2:-n}" reply
    (( ASSUME_YES )) && return 0
    local hint="[y/N]"; [[ "$default" == "y" ]] && hint="[Y/n]"
    read -r -p "$(printf '%s%s%s %s ' "$CC" "$prompt" "$CR" "$hint")" reply || true
    reply="${reply:-$default}"; [[ "$reply" =~ ^[Yy]$ ]]
}

banner() {
    printf '\n%s' "$CM"
    cat << 'BANNER'
    ╔═══════════════════════════════════════════════════╗
    ║   ██╗  ██╗██╗   ██╗██████╗ ██████╗              ║
    ║   ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗             ║
    ║   ███████║ ╚████╔╝ ██████╔╝██████╔╝             ║
    ║   ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗             ║
    ║   ██║  ██║   ██║   ██║     ██║  ██║             ║
    ║   ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝             ║
    ║       Dotfiles — sifaconer/Dotfiles               ║
    ╚═══════════════════════════════════════════════════╝
BANNER
    printf '%s\n\n' "$CR"
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --yes|-y)        ASSUME_YES=1 ;;
            --skip-packages) INSTALL_PACKAGES=0 ;;
            --variant)       VARIANT="${2:-}"; shift ;;
            --uninstall)     UNINSTALL=1 ;;
            --help|-h)
                echo "Uso: ./install.sh [--yes] [--variant dev|macos] [--skip-packages] [--uninstall]"
                exit 0 ;;
            *) warn "Opción desconocida: $1" ;;
        esac; shift
    done
}

# ── Detección ─────────────────────────────────────────────────
detect_distro() {
    [[ -r /etc/os-release ]] || die "No se puede leer /etc/os-release"
    # shellcheck source=/dev/null
    . /etc/os-release
    [[ "$ID" == "arch" || "${ID_LIKE:-}" == *arch* || "$ID" == "cachyos" ]] \
        || die "Solo Arch/CachyOS soportado. Detectado: $ID"
    info "Distro: $PRETTY_NAME"
}

detect_gpu() {
    GPU="unknown"
    if lspci 2>/dev/null | grep -Eqi 'vga.*nvidia'; then GPU="nvidia"
    elif lspci 2>/dev/null | grep -Eqi 'vga.*(amd|radeon)'; then GPU="amd"
    elif lspci 2>/dev/null | grep -Eqi 'vga.*intel'; then GPU="intel"
    fi
    info "GPU: $GPU"
}

# ── Variante ──────────────────────────────────────────────────
select_variant() {
    if [[ -n "$VARIANT" ]]; then
        [[ "$VARIANT" == "dev" || "$VARIANT" == "macos" ]] || die "Variante inválida: $VARIANT"
        return
    fi
    (( ASSUME_YES )) && { VARIANT="dev"; return; }

    echo ""
    printf '%s╔══════════════════════════════════════════════════╗%s\n' "$CB" "$CR"
    printf '%s║  Elige tu estilo visual:                         ║%s\n' "$CB" "$CR"
    printf '%s╠══════════════════════════════════════════════════╣%s\n' "$CB" "$CR"
    printf '%s║  %s1) Dev Minimalista%s                              ║%s\n' "$CB" "$CG" "$CB" "$CR"
    printf '%s║     Catppuccin Mocha · blur sutil · mako          ║%s\n' "$CD" "$CR"
    printf '%s║     hyprpaper · fuzzel · gaps 4/8 · Maple Mono    ║%s\n' "$CD" "$CR"
    printf '%s║                                                  ║%s\n' "$CB" "$CR"
    printf '%s║  %s2) macOS-like%s                                   ║%s\n' "$CB" "$CC" "$CB" "$CR"
    printf '%s║     WhiteSur theme · blur vidrio · swaync          ║%s\n' "$CD" "$CR"
    printf '%s║     swww (animated) · rofi spotlight · dock        ║%s\n' "$CD" "$CR"
    printf '%s╚══════════════════════════════════════════════════╝%s\n' "$CB" "$CR"
    echo ""
    local choice
    read -r -p "$(printf '%sElige [1/2]: %s' "$CC" "$CR")" choice
    case "$choice" in
        1|dev)   VARIANT="dev" ;;
        2|macos) VARIANT="macos" ;;
        *)       VARIANT="dev"; warn "Opción inválida, usando 'dev'" ;;
    esac
    ok "Variante seleccionada: $VARIANT"
}

# ── Leer paquetes desde archivo ───────────────────────────────
read_pkglist() {
    local file="$1"
    local -n _out="$2"   # nameref al array destino
    _out=()
    [[ -r "$file" ]] || { warn "Lista no encontrada: $file"; return 0; }
    while IFS= read -r line; do
        line="${line%%#*}"                            # quitar comentarios
        line="${line#"${line%%[![:space:]]*}"}"        # ltrim
        line="${line%"${line##*[![:space:]]}"}"        # rtrim
        [[ -n "$line" ]] && _out+=("$line")
    done < "$file"
}

# ── Instalar paquetes (bulk + fallback 1-a-1) ────────────────
install_packages() {
    local kind="$1" file="$2"
    local -a pkgs=()
    read_pkglist "$file" pkgs
    (( ${#pkgs[@]} )) || return 0

    info "Instalando ${#pkgs[@]} paquetes ($kind)..."

    local cmd
    case "$kind" in
        pacman) cmd="sudo pacman -S --needed --noconfirm" ;;
        aur)
            [[ -n "$AUR" ]] || { warn "Sin AUR helper, saltando $file"; return 0; }
            cmd="$AUR -S --needed --noconfirm --sudoloop"
            ;;
        *) die "Tipo desconocido: $kind" ;;
    esac

    # Intento bulk — si falla, va paquete por paquete
    if $cmd "${pkgs[@]}" >> "$LOG_FILE" 2>&1; then
        ok "$kind: todos los paquetes instalados"
        return 0
    fi

    warn "$kind: fallo en bulk install, intentando uno a uno..."
    local -a failed=()
    for pkg in "${pkgs[@]}"; do
        if $cmd "$pkg" >> "$LOG_FILE" 2>&1; then
            ok "  ✓ $pkg"
        else
            warn "  ✗ $pkg (no encontrado o error)"
            failed+=("$pkg")
        fi
    done

    if (( ${#failed[@]} > 0 )); then
        warn "Paquetes que fallaron (${#failed[@]}): ${failed[*]}"
        warn "Revisa el log: $LOG_FILE"
    fi
}

# ── AUR helper ────────────────────────────────────────────────
ensure_aur_helper() {
    if have paru; then AUR=paru; info "AUR helper: paru"; return; fi
    if have yay;  then AUR=yay;  info "AUR helper: yay";  return; fi
    info "Instalando paru-bin..."
    sudo pacman -S --needed --noconfirm base-devel git
    local tmp; tmp="$(mktemp -d)"
    git clone --depth=1 https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
    (cd "$tmp/paru-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"; AUR=paru; ok "paru instalado"
}

install_all_packages() {
    (( INSTALL_PACKAGES )) || { info "Saltando instalación de paquetes (--skip-packages)"; return 0; }
    ask "¿Instalar paquetes?" y || return 0

    install_packages pacman "$SCRIPT_DIR/packages/pacman.txt"
    ensure_aur_helper
    install_packages aur "$SCRIPT_DIR/packages/aur.txt"
    [[ "$VARIANT" == "macos" ]] && install_packages aur "$SCRIPT_DIR/packages/aur-macos.txt"
    ok "Instalación de paquetes completa"
}

# ── Backup & Symlinks ─────────────────────────────────────────
backup_if_exists() {
    local target="$1"
    [[ -e "$target" || -L "$target" ]] || return 0
    local rel="${target#"$HOME/"}"
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    mv -v "$target" "$BACKUP_DIR/$rel" 2>&1 | tee -a "$LOG_FILE"
}

link_dotfiles() {
    ask "¿Hacer backup y crear symlinks?" y || return 0
    info "Enlazando dotfiles..."
    mkdir -p "$BACKUP_DIR"

    local configs=(hypr waybar ghostty fuzzel mako yazi wlogout gtk-3.0 gtk-4.0 fastfetch tmux)
    for cfg in "${configs[@]}"; do
        [[ -d "$SCRIPT_DIR/.config/$cfg" ]] || continue
        backup_if_exists "$HOME/.config/$cfg"
        mkdir -p "$HOME/.config"
        ln -snf "$SCRIPT_DIR/.config/$cfg" "$HOME/.config/$cfg"
        ok "  → .config/$cfg"
    done

    # Starship (archivo suelto)
    backup_if_exists "$HOME/.config/starship.toml"
    ln -snf "$SCRIPT_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
    ok "  → .config/starship.toml"

    # Zshrc
    backup_if_exists "$HOME/.zshrc"
    ln -snf "$SCRIPT_DIR/home/.zshrc" "$HOME/.zshrc"
    ok "  → .zshrc"

    # .local/bin scripts
    mkdir -p "$HOME/.local/bin"
    if [[ -d "$SCRIPT_DIR/.local/bin" ]] && compgen -G "$SCRIPT_DIR/.local/bin/*" > /dev/null 2>&1; then
        for script in "$SCRIPT_DIR/.local/bin"/*; do
            ln -snf "$script" "$HOME/.local/bin/$(basename "$script")"
            ok "  → .local/bin/$(basename "$script")"
        done
    fi

    ok "Dotfiles enlazados. Backup en: $BACKUP_DIR"
}

# ── Configurar variante ───────────────────────────────────────
configure_variant() {
    info "Configurando variante: $VARIANT"
    mkdir -p "$HOME/.config/hypr"
    echo "$VARIANT" > "$HOME/.config/hypr/.variant"

    if [[ "$VARIANT" == "macos" ]]; then
        for f in "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"; do
            [[ -f "$f" ]] || continue
            sed -i 's/gtk-theme-name=.*/gtk-theme-name=WhiteSur-Dark/' "$f"
            sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name=WhiteSur-dark/' "$f"
            sed -i 's/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=WhiteSur-cursors/' "$f"
        done
        ok "Variante macOS: WhiteSur + swww + swaync + dock"
    else
        ok "Variante dev: Catppuccin Mocha + hyprpaper + mako"
    fi
}

# ── NVIDIA ────────────────────────────────────────────────────
configure_nvidia() {
    [[ "$GPU" == "nvidia" ]] || return 0
    local conf="$HOME/.config/hypr/hyprland.lua"
    [[ -f "$conf" ]] || return 0
    if ! grep -q 'require.*nvidia' "$conf"; then
        sed -i '/require("conf\/autostart")/a require("conf/nvidia")  -- auto-agregado por installer' "$conf"
        ok "NVIDIA: nvidia.lua incluido en hyprland.lua"
    fi
}

# ── Servicios ─────────────────────────────────────────────────
enable_services() {
    ask "¿Habilitar servicios del sistema?" y || return 0

    for svc in NetworkManager bluetooth; do
        if ! systemctl is-enabled "$svc" &>/dev/null; then
            sudo systemctl enable --now "$svc" >> "$LOG_FILE" 2>&1 || warn "No se pudo habilitar $svc"
            ok "Habilitado: $svc"
        else
            info "$svc ya está habilitado"
        fi
    done

    systemctl --user enable --now pipewire pipewire-pulse wireplumber >> "$LOG_FILE" 2>&1 || true
    ok "PipeWire habilitado"

    if have tuigreet && ! systemctl is-enabled greetd &>/dev/null; then
        if ask "¿Habilitar greetd (login TUI)?"; then
            sudo systemctl enable greetd >> "$LOG_FILE" 2>&1 || warn "No se pudo habilitar greetd"
            ok "greetd habilitado"
        fi
    fi
}

# ── Shell ─────────────────────────────────────────────────────
setup_shell() {
    if [[ "$SHELL" == *zsh* ]]; then
        info "Zsh ya es el shell por defecto"
        return 0
    fi
    if have zsh && ask "¿Establecer zsh como shell por defecto?" y; then
        chsh -s "$(command -v zsh)" "$USER"
        ok "Shell cambiado a zsh (efectivo en próximo login)"
    fi
}

# ── Post-instalación ──────────────────────────────────────────
post_install() {
    have fc-cache && { info "Actualizando caché de fuentes..."; fc-cache -fv >> "$LOG_FILE" 2>&1; }
    mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Pictures/Wallpapers"

    echo ""
    printf '%s╔══════════════════════════════════════════════════╗%s\n' "$CG" "$CR"
    printf '%s║  ✅ Instalación completa!                        ║%s\n' "$CG" "$CR"
    printf '%s╠══════════════════════════════════════════════════╣%s\n' "$CG" "$CR"
    printf '%s║  Variante: %-37s ║%s\n' "$CG" "$VARIANT" "$CR"
    printf '%s║  GPU:      %-37s ║%s\n' "$CG" "$GPU" "$CR"
    printf '%s║  Log:      ~/.local/state/dotfiles/              ║%s\n' "$CG" "$CR"
    printf '%s╠══════════════════════════════════════════════════╣%s\n' "$CG" "$CR"
    printf '%s║  Siguientes pasos:                               ║%s\n' "$CG" "$CR"
    printf '%s║  1. Wallpaper:                                   ║%s\n' "$CD" "$CR"
    printf '%s║     ln -sf ~/Pictures/Wallpapers/foto.jpg \\     ║%s\n' "$CD" "$CR"
    printf '%s║          ~/Pictures/Wallpapers/current.jpg      ║%s\n' "$CD" "$CR"
    printf '%s║  2. Editar ~/.config/hypr/userprefs.lua          ║%s\n' "$CD" "$CR"
    printf '%s║     (monitores, keybinds extra)                  ║%s\n' "$CD" "$CR"
    printf '%s║  3. Reiniciar → seleccionar Hyprland en greetd   ║%s\n' "$CD" "$CR"
    printf '%s║  4. SUPER+Q=terminal  SUPER+R=launcher           ║%s\n' "$CD" "$CR"
    printf '%s╚══════════════════════════════════════════════════╝%s\n' "$CG" "$CR"
}

# ── Desinstalar ───────────────────────────────────────────────
do_uninstall() {
    info "Eliminando symlinks..."
    local configs=(hypr waybar ghostty fuzzel mako yazi wlogout gtk-3.0 gtk-4.0 fastfetch tmux)
    for cfg in "${configs[@]}"; do
        [[ -L "$HOME/.config/$cfg" ]] && rm -v "$HOME/.config/$cfg"
    done
    [[ -L "$HOME/.config/starship.toml" ]] && rm -v "$HOME/.config/starship.toml"
    [[ -L "$HOME/.zshrc" ]] && rm -v "$HOME/.zshrc"
    ok "Symlinks eliminados. Restaura desde ~/.config-backup-* si necesitas."
    exit 0
}

# ── Main ──────────────────────────────────────────────────────
main() {
    [[ $EUID -ne 0 ]] || die "No ejecutar como root. El script usa sudo cuando lo necesita."
    parse_args "$@"
    mkdir -p "$LOG_DIR"; : > "$LOG_FILE"
    banner
    (( UNINSTALL )) && do_uninstall
    detect_distro
    detect_gpu
    select_variant
    install_all_packages
    link_dotfiles
    configure_variant
    configure_nvidia
    enable_services
    setup_shell
    post_install
}

main "$@"
