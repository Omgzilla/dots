# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;31m\]$(__git_ps1)\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Sourece aliasrc
if [ -f ~/.config/shell/aliasrc ]; then
    . ~/.config/shell/aliasrc
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
  if [ -f /usr/share/git/completion/git-completion.bash ]; then
    . /usr/share/git/completion/git-completion.bash
  fi
  if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh
  fi
fi

# Add .local bin to PATH
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Default applicaitons:
export EDITOR="nvim"
export TERMINAL="terminator"
#export TERMINAL="alacritty"
export MANPAGER="nvim +Man!"
export COLORTERM="truecolor"
export PAGER="less"
export BROWSER="firefox"

# Source FZF bindings
#source /usr/share/doc/fzf/examples/key-bindings.bash # Ubuntu
source /usr/share/fzf/key-bindings.bash # Arch

# Preserve bash history in multiple terminal windows
## Avoid duplicates and coreutils
HISTCONTROL=ignoredups:erasedups
HISTIGNORE="cd:ls:ll:pwd:exit:clear:.."
## for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=1000000
## When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
## Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# XDG
#export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
#export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
#export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
#export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:="/tmp/xdg-runtime-$(id -u)"}
#export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

# History
#export HISTFILE="$XDG_DATA_HOME"/bash/history

# X11
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
#export XINITRC="$XDG_CONFIG_HOME"/x11/xinitrc
#export XSERVERRC="$XDG_CONFIG_HOME"/x11/xserverrc

# Tools
#export CARGO_HOME="$XDG_DATA_HOME/cargo"
#export CODEX_HOME="$XDG_CONFIG_HOME/codex"
#export GNUPGHOME="$XDG_DATA_HOME/gnupg"
#export GOPATH="$XDG_DATA_HOME/go"
#export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
#export KODI_DATA="$XDG_DATA_HOME/kodi"
#export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
#export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
#export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
#export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
#export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

export OPENCODE_CONFIG="$XDG_CONFIG_HOME/opencode/custom-config.json"

# Languages for neovim
#export NODE_PATH=$HOME/.local/share/nvim/node_modules/lib/node_modules

# Initialize zoxide
eval "$(zoxide init bash)"

# Source Cargo
#. "/home/marcus/.local/share/cargo/env"

#export NVM_DIR="$HOME/.config/nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
