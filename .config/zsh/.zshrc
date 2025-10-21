# General
export EDITOR="nvim"
export PATH="$PATH:/home/marcus/.local/bin"
source ~/.config/zsh/.zprofile
source ~/.config/shell/aliasrc

# Load colors
autoload -U colors && colors

# Automatically cd into typed directory:
setopt autocd

# History in cache directory:
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.local/state/zsh/history

# Prompt settings
PROMPT='%F{green}%B%~ %F{magenta}> %f'

# FZF
eval "$(fzf --zsh)"

# Homebrew path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Git settings
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%r%f'
zstyle ':vcs_info:*' enable git

# Zoxide
eval "$(zoxide init zsh)"

# ZSH Completions
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
