# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
       . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Add npm bin to PATH
if [ -d "$HOME/.local/lib/npm/bin" ] ; then
  PATH="$HOME/.local/lib/npm/bin:$PATH"
fi

# XDG
export XDG_CACHE_HOME=${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:="$HOME/.config"}
export XDG_DATA_HOME=${XDG_DATA_HOME:="$HOME/.local/share"}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:="/tmp/xdg-runtime-$(id -u)"}
export XDG_STATE_HOME=${XDG_STATE_HOME:="$HOME/.local/state"}

# History
export HISTFILE="$XDG_STATE_HOME/bash/history"

# X11
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME"/x11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/x11/xserverrc

# Tools
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CODEX_HOME="$XDG_CONFIG_HOME/codex"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GOPATH="$XDG_DATA_HOME/go"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export KODI_DATA="$XDG_DATA_HOME/kodi"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

# Start Hyprland
#if uwsm check may-start; then
#    exec uwsm start hyprland.desktop
#fi

if command -v uwsm >/dev/null 2>&1 \
   && [ -z "$TMUX" ] \
   && [ -z "${WAYLAND_DISPLAY}${DISPLAY}" ] \
   && [ "${XDG_VTNR:-0}" -eq 1 ]; then
  if uwsm check may-start >/dev/null 2>&1; then
    exec uwsm start hyprland-uwsm.desktop
    #exec uswm start mango
  fi
fi

