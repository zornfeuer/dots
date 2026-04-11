[[ $- != *i* ]] && return

export XDG_STATE_HOME="$HOME/.local/state"
mkdir -p "$XDG_STATE_HOME/bash"
export HISTFILE="$XDG_STATE_HOME/bash/history"
export PATH="$PATH:$HOME/.local/bin"
export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
exec fish;
