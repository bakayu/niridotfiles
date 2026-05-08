# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=2 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza --tree --level=2 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'eza --tree --level=2 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias kt='kitty +kitten icat'
alias run='./run.sh'
alias rj='./run_java.sh'
alias go24='go1.24.5'
alias gt='zen-browser https://github.com/bakayu'
alias kys='poweroff'
alias vm1='ssh -i .ssh/azureVM1_key.pem bakucl@13.71.31.172'
alias vm2='ssh bakuwn@74.225.178.87'
alias pf="fzf --preview='bat --color=always --theme=gruvbox-dark {}' --bind shift-up:preview-page-up,shift-down:preview-page-down"
alias l='eza -l --icons'
alias la='ls -la'
alias ll='eza -la --icons --tree --level=2'
alias lll='eza -la --icons --tree --level=3'
alias lt='eza --icons --tree --level=2'
alias llt='eza --icons --tree --level=3'
alias c='clear'
alias cl='clear'
alias q='exit'
alias nixa='nvim ~/nixfiles/modules/packages/system-packages.nix'
alias nv='nvim'
alias zj='zellij'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias tt='kitten icat ~/data/media/tt.png'
alias py='python3'
alias open='nautilus'
alias bat='bat --theme=gruvbox-dark'

# PATH
typeset -U path PATH
path=(
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/go/bin"
  "/usr/local/go/bin"
  "$HOME/.pyenv/bin"
  "$HOME/.local/share/solana/install/active_release/bin"
  $path
)
export PATH
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8



# Cargo env, same idea as source ~/.cargo/env.nu
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bun completions
[ -s "/home/bakayu/.bun/_bun" ] && source "/home/bakayu/.bun/_bun"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# eval "$(starship init zsh)"


# Force block cursor in zsh
_set_block_cursor() {
  printf '\e[2 q'
}

zle-line-init() {
  _set_block_cursor
}
zle -N zle-line-init

precmd() {
  _set_block_cursor
}

