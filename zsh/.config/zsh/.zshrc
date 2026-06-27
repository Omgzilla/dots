# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=2000000

setopt APPEND_HISTORY           # append, don’t overwrite
setopt INC_APPEND_HISTORY       # write incrementally
setopt SHARE_HISTORY            # share across shells
setopt HIST_EXPIRE_DUPS_FIRST   # expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS         # don't write duplicates
setopt HIST_IGNORE_ALL_DUPS     # remove older duplicate entries
setopt HIST_IGNORE_SPACE        # don't write spaces
setopt HIST_SAVE_NO_DUPS        # don’t write duplicates to file
setopt HIST_FIND_NO_DUPS        # don’t show dups when searching

# Shell behaviour
setopt AUTOCD             # jump directory by just typing directory name
setopt NOBEEP             # disable shell error beep sound
setopt NUMERIC_GLOB_SORT  # sort file10 after file9, not after file1

# Completions
autoload -Uz compinit && compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump" # initialize completion with cached metafile
zstyle ':completion:*' menu select  # enable interactive menu
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # non-case-sensitive search
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Git settings
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%r%f'
zstyle ':vcs_info:*' enable git

# FZF
eval "$(fzf --zsh)"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Zoxide
eval "$(zoxide init zsh)"

# Load colors
autoload -U colors && colors

# Prompt settings
PROMPT='%F{green}%B%~ %F{magenta}> %f'

export PATH="$PATH:$HOME/.local/bin"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
source $XDG_CONFIG_HOME/shell/aliasrc


