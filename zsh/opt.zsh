bindkey -e
alias vim=nvim
export EDITOR=nvim
LANG=en_US.UTF-8

# use color in zsh
autoload -Uz colors
colors

# make it possible to display Japanese chars
setopt print_eight_bit

setopt no_beep

setopt nolistbeep

setopt auto_pushd

# ---------------------------
# History
# ---------------------------
setopt share_history

setopt hist_ignore_dups

setopt hist_ignore_space

# reduce blanks when saving a command to history
setopt hist_reduce_blanks

setopt pushd_ignore_dups

setopt hist_ignore_all_dups

HISTFILE=$ZSHHOME/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

zstyle ':completion:*:default' menu select=2
