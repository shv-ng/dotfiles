# Set directory where we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit if it doesn't exist
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load Zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Load completions
autoload -U compinit && compinit

# Keybindings
bindkey '^ ' autosuggest-accept
bindkey '^R' history-incremental-search-backward
bindkey '^T' history-incremental-search-forward

bindkey -s "^f" 'tmux-sessionizer\n'

# Vim mode configuration
bindkey -v
export KEYTIMEOUT=1

# ─── History Options ───────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
HISTDUP=erase

setopt APPENDHISTORY
setopt BANG_HIST
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_BEEP
setopt SHAREHISTORY
setopt HIST_NO_STORE

# ─── Shell Options ─────────────────────────────────────────────────────
setopt CORRECT              # auto correct mistakes
setopt INTERACTIVECOMMENTS  # allow comments in interactive mode
setopt MAGICEQUALSUBST      # enable filename expansion for arguments of the form 'anything=expression'
setopt NONOMATCH            # hide error message if there is no match for the pattern
setopt NOTIFY               # report the status of background jobs immediately
setopt NUMERICGLOBSORT      # sort filenames numerically when it makes sense
setopt PROMPTSUBST          # enable command substitution in prompt


export SPROMPT="zsh: correct '%R' to '%r'? [y/N/a/e] "

# ─── Custom Prompt ─────────────────────────────────────────────────────
# Git integration
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats ' %F{cyan}⎇ %b%f'
zstyle ':vcs_info:git*' actionformats ' %F{cyan}⎇ %b%f %F{red}⚡ %a%f'

# Vim mode indicators
vim_ins_mode="%F{green}❯%f"
vim_cmd_mode="%F{yellow}❮%f"
vim_mode=$vim_ins_mode

# Function to update vim mode
function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

# Function to reset to insert mode on new line
function zle-line-init {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-init

# Function to update git info before each prompt
precmd() {
    vcs_info
}

# Enhanced prompt with vim mode
PROMPT='%F{magenta}╭─%f %F{cyan}%n%f %F{white}at%f %F{blue}%m%f %F{white}in%f %F{yellow}%2~%f${vcs_info_msg_0_}
%F{magenta}╰─%f ${vim_mode} '

# Optional: Right prompt with time and exit status
RPROMPT='%(?..%F{red}✘ %?%f) %F{244}%T%f'

# ─── Custom Functions ──────────────────────────────────────────────────

# Quick directory navigation
..() { cd .. }
...() { cd ../.. }
....() { cd ../../.. }

# ─── Tmux Reload ───────────────────────────────────────────────────────
if [ -n "$TMUX" ]; then
  tmux source-file "$TMUX_CONF"
fi


# ─── Completion Configuration ──────────────────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true                              # automatically find new executables in path
zstyle ':completion:*' accept-exact '*(N)'                     # speed up completions
zstyle ':completion:*' use-cache on                            # use cache for better performance
zstyle ':completion:*' cache-path ~/.zsh/cache

# ─── Aliases ────────────────────────────────────────────────────────────
alias todo='nvim /home/shivang/todo.md'
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Shell integrations
# eval "$(fzf --zsh)"

# ─── Environment Variables ─────────────────────────────────────────────
export GOPATH="$HOME/go"
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"
export PERSONAL="$HOME/personal"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH:$MY_BIN"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$GOPATH/bin"
export EDITOR="nvim"
export PAGER="less"
export LESS="-R"                           # raw control characters
export LESSHISTFILE=-                      # disable less history
#
# XDG Base Directory Specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# disable beeps
setopt NO_BEEP
