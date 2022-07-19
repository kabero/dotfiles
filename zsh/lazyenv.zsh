# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

pyenv() {
  unfunction "$0"
  source <(pyenv init -)
  source <(pyenv virtualenv-init -)
  $0 "$@"
}

