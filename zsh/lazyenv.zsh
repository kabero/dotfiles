# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

pyenv() {
  unfunction "$0"
  source <(pyenv init -)
  source <(pyenv virtualenv-init -)
  $0 "$@"
}



# goenv
export GOENV_ROOT=$HOME/.goenv
export PATH=$GOENV_ROOT/bin:$PATH

goenv() {
    unfunction "$0"
    source <(goenv init -)
    $0 "$@"
}
