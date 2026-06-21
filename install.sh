#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  DOTFILES INSTALLER — Hyprland + quickshell on Arch          ║
# ║  Uso: ./install.sh | ./install.sh --yes | ./install.sh -h    ║
# ║  Sin AUR. Sin variantes. Todo desde repos oficiales.         ║
# ╚══════════════════════════════════════════════════════════════╝
set -Euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

readonly SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
readonly TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
readonly LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
readonly LOG_FILE="${LOG_DIR}/install-${TIMESTAMP}.log"
readonly BACKUP_DIR="$HOME/.config-backup-${TIMESTAMP}"

ASSUME_YES=0; INSTALL_PACKAGES=1; UNINSTALL=0; GPU="unknown"

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
            --uninstall)     UNINSTALL=1 ;;
            --help|-h)
                echo "Uso: ./install.sh [--yes] [--skip-packages] [--uninstall]"
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
    local file="$1"
    local -a pkgs=()
    read_pkglist "$file" pkgs
    (( ${#pkgs[@]} )) || return 0

    info "Instalando ${#pkgs[@]} paquetes (pacman)..."

    local cmd="sudo pacman -S --needed --noconfirm"

    # Intento bulk — si falla, va paquete por paquete
    if $cmd "${pkgs[@]}" >> "$LOG_FILE" 2>&1; then
        ok "pacman: todos los paquetes instalados"
        return 0
    fi

    warn "pacman: fallo en bulk install, intentando uno a uno..."
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

# ── Instalar flatpaks (apps fuera de repos oficiales) ────────
install_flatpaks() {
    local file="$1"
    local -a apps=()
    read_pkglist "$file" apps
    (( ${#apps[@]} )) || return 0

    if ! command -v flatpak >/dev/null 2>&1; then
        warn "flatpak no está instalado; saltando ${#apps[@]} apps de $file"
        return 0
    fi

    info "Instalando ${#apps[@]} flatpaks (flathub)..."
    for app in "${apps[@]}"; do
        if flatpak install -y flathub "$app" >> "$LOG_FILE" 2>&1; then
            ok "  ✓ $app"
        else
            warn "  ✗ $app (no encontrado o error)"
        fi
    done
}

install_all_packages() {
    (( INSTALL_PACKAGES )) || { info "Saltando instalación de paquetes (--skip-packages)"; return 0; }
    ask "¿Instalar paquetes?" y || return 0

    install_packages "$SCRIPT_DIR/packages/pacman.txt"
    install_flatpaks "$SCRIPT_DIR/packages/flatpak.txt"
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

# ── Descubrimiento de paquetes (stow-native) ──────────────────
# Cada dir top-level es un "paquete" que replica parte de $HOME:
#   pkg/.config/<app>/  → $HOME/.config/<app>   (symlink del dir completo)
#   pkg/.config/<file>  → $HOME/.config/<file>  (archivo suelto, ej: starship.toml)
#   pkg/.zshrc          → $HOME/.zshrc          (dotfile en raíz del paquete)
#   pkg/.local/bin/*    → $HOME/.local/bin/*    (mirror archivo a archivo)
# Agregar una app = crear un dir top-level. Cero cambios de código.
package_dirs() {
    local d name
    for d in "$SCRIPT_DIR"/*/; do
        d="${d%/}"
        name="$(basename "$d")"
        [[ "$name" == "packages" ]] && continue
        printf '%s\n' "$d"
    done
}

# Enlaza (mode=link) o desenlaza (mode=unlink) un destino individual.
apply_target() {
    local mode="$1" src="$2" tgt="$3" rel="$4" name="$5"
    case "$mode" in
        link)
            mkdir -p "$(dirname "$tgt")"
            backup_if_exists "$tgt"
            ln -snf "$src" "$tgt"
            ok "  → $rel  [$name]"
            ;;
        unlink)
            if [[ -L "$tgt" ]]; then rm -v "$tgt" 2>&1 | tee -a "$LOG_FILE"; fi
            ;;
    esac
}

# Mirror de un dir raíz del paquete (ej: .local/bin) archivo a archivo.
# No hace folding: útil para dirs compartidos con estado del sistema.
apply_dir() {
    local mode="$1" src="$2" tgt="$3" rel="$4" name="$5"
    [[ -d "$src" ]] || return 0
    local entry base
    for entry in "$src"/* "$src"/.[!.]*; do
        [[ -e "$entry" ]] || continue
        base="$(basename "$entry")"
        if [[ -d "$entry" ]]; then
            apply_dir "$mode" "$entry" "$tgt/$base" "$rel/$base" "$name"
        else
            apply_target "$mode" "$entry" "$tgt/$base" "$rel/$base" "$name"
        fi
    done
}

# Aplica un paquete completo: .config/* + dotfiles en raíz.
apply_package() {
    local pkg="$1" mode="$2" name; name="$(basename "$pkg")"
    local entry base

    # .config/<app> dirs y .config/<file> sueltos
    if [[ -d "$pkg/.config" ]]; then
        for entry in "$pkg/.config"/*; do
            [[ -e "$entry" ]] || continue
            base="$(basename "$entry")"
            apply_target "$mode" "$entry" "$HOME/.config/$base" ".config/$base" "$name"
        done
    fi

    # dotfiles en la raíz del paquete (ej: .zshrc, .local/bin)
    # .config ya se manejó arriba; .git nunca se toca.
    for entry in "$pkg"/.[!.]*; do
        [[ -e "$entry" ]] || continue
        base="$(basename "$entry")"
        [[ "$base" == ".git" || "$base" == ".config" ]] && continue
        if [[ -d "$entry" ]]; then
            apply_dir "$mode" "$entry" "$HOME/$base" "$base" "$name"
        else
            apply_target "$mode" "$entry" "$HOME/$base" "$base" "$name"
        fi
    done
}

link_dotfiles() {
    ask "¿Hacer backup y crear symlinks?" y || return 0
    info "Enlazando dotfiles..."
    mkdir -p "$BACKUP_DIR"
    local pkg
    while IFS= read -r pkg; do
        apply_package "$pkg" link
    done < <(package_dirs)
    ok "Dotfiles enlazados. Backup en: $BACKUP_DIR"
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
    printf '%s║  4. SUPER+Q=kitty  SUPER+R=fuzzel (TODO: qs)     ║%s\n' "$CD" "$CR"
    printf '%s║  5. Diseñar tu shell en quickshell/shell.qml     ║%s\n' "$CD" "$CR"
    printf '%s╚══════════════════════════════════════════════════╝%s\n' "$CG" "$CR"
}

# ── Desinstalar ───────────────────────────────────────────────
do_uninstall() {
    info "Eliminando symlinks..."
    local pkg
    while IFS= read -r pkg; do
        apply_package "$pkg" unlink
    done < <(package_dirs)
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
    install_all_packages
    link_dotfiles
    configure_nvidia
    enable_services
    setup_shell
    post_install
}

main "$@"
