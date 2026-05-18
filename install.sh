#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════╗
# ║  DOTFILES INSTALLER — Hyprland on CachyOS/Arch              ║
# ║  Uso: ./install.sh | ./install.sh --yes --variant dev|macos ║
# ║       ./install.sh --skip-packages | ./install.sh --uninstall║
# ╚══════════════════════════════════════════════════════════════╝
set -Eeuo pipefail
shopt -s inherit_errexit 2>/dev/null || true
IFS=$'\n\t'

readonly SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
readonly TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
readonly LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
readonly LOG_FILE="${LOG_DIR}/install-${TIMESTAMP}.log"
readonly BACKUP_DIR="$HOME/.config-backup-${TIMESTAMP}"

ASSUME_YES=0; INSTALL_PACKAGES=1; VARIANT=""; UNINSTALL=0; AUR=""; GPU="unknown"

# ── Colors & Logging ──────────────────────────────────────────
CR=$'\e[0m'; CB=$'\e[1m'; CG=$'\e[32m'; CRD=$'\e[31m'; CY=$'\e[33m'; CBL=$'\e[34m'; CM=$'\e[35m'; CC=$'\e[36m'; CD=$'\e[2m'
info()  { printf '%s[INFO]%s %s\n'  "$CBL" "$CR" "$*" | tee -a "$LOG_FILE"; }
ok()    { printf '%s[ OK ]%s %s\n'  "$CG"  "$CR" "$*" | tee -a "$LOG_FILE"; }
warn()  { printf '%s[WARN]%s %s\n'  "$CY"  "$CR" "$*" | tee -a "$LOG_FILE" >&2; }
die()   { printf '%s[FAIL]%s %s\n'  "$CRD" "$CR" "$*" | tee -a "$LOG_FILE" >&2; exit 1; }

trap 'warn "Failed at line ${BASH_LINENO[0]}: ${BASH_COMMAND}"' ERR
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

# ── Parse args ────────────────────────────────────────────────
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --yes|-y)        ASSUME_YES=1 ;;
            --skip-packages) INSTALL_PACKAGES=0 ;;
            --variant)       VARIANT="${2:-}"; shift ;;
            --uninstall)     UNINSTALL=1 ;;
            --help|-h)
                echo "Usage: ./install.sh [--yes] [--variant dev|macos] [--skip-packages] [--uninstall]"
                exit 0 ;;
            *) warn "Unknown: $1" ;;
        esac; shift
    done
}

# ── Detection ─────────────────────────────────────────────────
detect_distro() {
    [[ -r /etc/os-release ]] || die "Cannot read /etc/os-release"
    . /etc/os-release
    [[ "$ID" == "arch" || "${ID_LIKE:-}" == *arch* || "$ID" == "cachyos" ]] \
        || die "Only Arch/CachyOS supported. Detected: $ID"
    info "Distro: $PRETTY_NAME"
}

detect_gpu() {
    GPU="unknown"
    lspci 2>/dev/null | grep -Eqi 'vga.*nvidia' && GPU="nvidia"
    lspci 2>/dev/null | grep -Eqi 'vga.*(amd|radeon)' && GPU="amd"
    lspci 2>/dev/null | grep -Eqi 'vga.*intel' && GPU="intel"
    info "GPU: $GPU"
}

# ── Variant selection ─────────────────────────────────────────
select_variant() {
    if [[ -n "$VARIANT" ]]; then
        [[ "$VARIANT" == "dev" || "$VARIANT" == "macos" ]] || die "Invalid variant: $VARIANT"
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
        *)       VARIANT="dev"; warn "Defaulting to 'dev'" ;;
    esac
    ok "Variant: $VARIANT"
}

# ── Packages ──────────────────────────────────────────────────
ensure_aur_helper() {
    have paru && { AUR=paru; return; }
    have yay  && { AUR=yay;  return; }
    info "Installing paru-bin..."
    sudo pacman -S --needed --noconfirm base-devel git
    local tmp; tmp="$(mktemp -d)"
    git clone --depth=1 https://aur.archlinux.org/paru-bin.git "$tmp/paru-bin"
    (cd "$tmp/paru-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"; AUR=paru; ok "paru installed"
}

install_packages() {
    local kind="$1" file="$2"
    [[ -r "$file" ]] || { warn "Missing: $file"; return 0; }
    mapfile -t pkgs < <(grep -vE '^\s*(#|$)' "$file" | tr -d '[:space:]' | grep -v '^$')
    (( ${#pkgs[@]} )) || return 0
    info "Installing ${#pkgs[@]} $kind packages..."
    case "$kind" in
        pacman) sudo pacman -S --needed --noconfirm "${pkgs[@]}" 2>&1 | tee -a "$LOG_FILE" ;;
        aur)    [[ -n "$AUR" ]] && "$AUR" -S --needed --noconfirm "${pkgs[@]}" 2>&1 | tee -a "$LOG_FILE" ;;
    esac
}

install_all_packages() {
    (( INSTALL_PACKAGES )) || { info "Skipping packages"; return 0; }
    ask "Install packages?" y || return 0
    install_packages pacman "$SCRIPT_DIR/packages/pacman.txt"
    ensure_aur_helper
    install_packages aur "$SCRIPT_DIR/packages/aur.txt"
    [[ "$VARIANT" == "macos" ]] && install_packages aur "$SCRIPT_DIR/packages/aur-macos.txt"
    ok "All packages installed"
}

# ── Backup & Symlinks ────────────────────────────────────────
backup_if_exists() {
    local target="$1"
    [[ -e "$target" || -L "$target" ]] || return 0
    local rel="${target#$HOME/}"
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    mv -v "$target" "$BACKUP_DIR/$rel" 2>&1 | tee -a "$LOG_FILE"
}

link_dotfiles() {
    ask "Backup existing configs and link dotfiles?" y || return 0
    info "Linking dotfiles..."
    mkdir -p "$BACKUP_DIR"

    local configs=(hypr waybar ghostty fuzzel mako yazi wlogout gtk-3.0 gtk-4.0 fastfetch tmux)
    for cfg in "${configs[@]}"; do
        [[ -d "$SCRIPT_DIR/.config/$cfg" ]] || continue
        backup_if_exists "$HOME/.config/$cfg"
        mkdir -p "$HOME/.config"
        ln -snf "$SCRIPT_DIR/.config/$cfg" "$HOME/.config/$cfg"
        ok "Linked .config/$cfg"
    done

    # Starship
    backup_if_exists "$HOME/.config/starship.toml"
    ln -snf "$SCRIPT_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

    # Zshrc
    backup_if_exists "$HOME/.zshrc"
    ln -snf "$SCRIPT_DIR/home/.zshrc" "$HOME/.zshrc"

    # .local/bin
    mkdir -p "$HOME/.local/bin"
    if [[ -d "$SCRIPT_DIR/.local/bin" ]] && ls "$SCRIPT_DIR/.local/bin"/* &>/dev/null; then
        for script in "$SCRIPT_DIR/.local/bin"/*; do
            ln -snf "$script" "$HOME/.local/bin/$(basename "$script")"
        done
    fi

    ok "Dotfiles linked. Backups at: $BACKUP_DIR"
}

# ── Variant config ────────────────────────────────────────────
configure_variant() {
    info "Configuring variant: $VARIANT"
    echo "$VARIANT" > "$HOME/.config/hypr/.variant"

    if [[ "$VARIANT" == "macos" ]]; then
        for f in "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"; do
            [[ -f "$f" ]] || continue
            sed -i 's/gtk-theme-name=.*/gtk-theme-name=WhiteSur-Dark/' "$f"
            sed -i 's/gtk-icon-theme-name=.*/gtk-icon-theme-name=WhiteSur-dark/' "$f"
            sed -i 's/gtk-cursor-theme-name=.*/gtk-cursor-theme-name=WhiteSur-cursors/' "$f"
        done
        ok "macOS variant: WhiteSur + swww + swaync + dock"
    else
        ok "Dev variant: Catppuccin Mocha + hyprpaper + mako"
    fi
}

# ── NVIDIA ────────────────────────────────────────────────────
configure_nvidia() {
    [[ "$GPU" == "nvidia" ]] || return 0
    local conf="$HOME/.config/hypr/hyprland.lua"
    [[ -f "$conf" ]] || return 0
    if ! grep -q 'require.*nvidia' "$conf"; then
        sed -i '/require("conf\/autostart")/a require("conf/nvidia")  -- auto-added by installer' "$conf"
        ok "NVIDIA: added nvidia.lua to hyprland.lua"
    fi
}

# ── Services ──────────────────────────────────────────────────
enable_services() {
    ask "Enable system services?" y || return 0
    for svc in NetworkManager bluetooth; do
        systemctl is-enabled "$svc" &>/dev/null || sudo systemctl enable --now "$svc" 2>&1 | tee -a "$LOG_FILE" || true
    done
    systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
    if have tuigreet && ! systemctl is-enabled greetd &>/dev/null; then
        ask "Enable greetd (TUI login)?" && sudo systemctl enable greetd 2>&1 | tee -a "$LOG_FILE" || true
    fi
    ok "Services configured"
}

# ── Shell ─────────────────────────────────────────────────────
setup_shell() {
    [[ "$SHELL" == *zsh* ]] && { info "Zsh already default"; return 0; }
    have zsh && ask "Set zsh as default shell?" y && chsh -s "$(command -v zsh)" "$USER"
}

# ── Post-install ──────────────────────────────────────────────
post_install() {
    have fc-cache && { info "Refreshing fonts..."; fc-cache -fv >> "$LOG_FILE" 2>&1; }
    mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Pictures/Wallpapers"

    echo ""
    printf '%s╔══════════════════════════════════════════════════╗%s\n' "$CG" "$CR"
    printf '%s║  ✅ Installation complete!                       ║%s\n' "$CG" "$CR"
    printf '%s╠══════════════════════════════════════════════════╣%s\n' "$CG" "$CR"
    printf '%s║  Variant: %-38s ║%s\n' "$CG" "$VARIANT" "$CR"
    printf '%s║  GPU:     %-38s ║%s\n' "$CG" "$GPU" "$CR"
    printf '%s╠══════════════════════════════════════════════════╣%s\n' "$CG" "$CR"
    printf '%s║  Next steps:                                     ║%s\n' "$CG" "$CR"
    printf '%s║  1. Add wallpaper → ~/Pictures/Wallpapers/       ║%s\n' "$CD" "$CR"
    printf '%s║     ln -sf wall.jpg ~/Pictures/Wallpapers/current.jpg ║%s\n' "$CD" "$CR"
    printf '%s║  2. Edit ~/.config/hypr/userprefs.lua            ║%s\n' "$CD" "$CR"
    printf '%s║  3. Reboot → select Hyprland in greetd           ║%s\n' "$CD" "$CR"
    printf '%s║  4. SUPER+Q=terminal  SUPER+R=launcher           ║%s\n' "$CD" "$CR"
    printf '%s╚══════════════════════════════════════════════════╝%s\n' "$CG" "$CR"
}

# ── Uninstall ─────────────────────────────────────────────────
do_uninstall() {
    info "Removing symlinks..."
    local configs=(hypr waybar ghostty fuzzel mako yazi wlogout gtk-3.0 gtk-4.0 fastfetch tmux)
    for cfg in "${configs[@]}"; do
        [[ -L "$HOME/.config/$cfg" ]] && rm -v "$HOME/.config/$cfg"
    done
    [[ -L "$HOME/.config/starship.toml" ]] && rm -v "$HOME/.config/starship.toml"
    [[ -L "$HOME/.zshrc" ]] && rm -v "$HOME/.zshrc"
    ok "Symlinks removed."
    exit 0
}

# ── Main ──────────────────────────────────────────────────────
main() {
    [[ $EUID -ne 0 ]] || die "Don't run as root"
    parse_args "$@"
    mkdir -p "$LOG_DIR"; : > "$LOG_FILE"
    banner
    (( UNINSTALL )) && do_uninstall
    detect_distro; detect_gpu; select_variant
    install_all_packages; link_dotfiles; configure_variant
    configure_nvidia; enable_services; setup_shell; post_install
}

main "$@"
