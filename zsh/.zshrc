# ╔══════════════════════════════════════════════════════════════╗
# ║  ZSHRC — QUÉ EDITAR: plugins zinit, aliases, exports        ║
# ║  DEPENDENCIAS: zinit, starship, zoxide, fzf, atuin          ║
# ╚══════════════════════════════════════════════════════════════╝

# ── Zinit ─────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)" && \
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# ── Plugins ───────────────────────────────────────────────────
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# ── Completions ───────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --icons $realpath'

# ── Shell integrations ────────────────────────────────────────
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)" 2>/dev/null
command -v mise &>/dev/null && eval "$(mise activate zsh)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

# ── History ───────────────────────────────────────────────────
HISTSIZE=10000; SAVEHIST=10000; HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS

# ── Exports ───────────────────────────────────────────────────
export EDITOR=nvim VISUAL=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export ELECTRON_OZONE_PLATFORM_HINT=auto
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always {}'"

# ── Aliases ───────────────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --git --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias ps='procs'
alias top='btop'
alias du='dust'
alias df='duf'
alias http='xh'
alias cd='z'
alias g='git'
alias lg='lazygit'
alias gs='git status -sb'
alias gd='git diff'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph -20'
alias vim='nvim'
alias v='nvim'
alias ff='fastfetch'
alias hypr='nvim ~/.config/hypr/'
alias dots='cd ~/Dotfiles'

# ── Yazi CD-on-exit wrapper ───────────────────────────────────
function y() {
    local tmp; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}
