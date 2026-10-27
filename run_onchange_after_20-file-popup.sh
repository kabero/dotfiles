#!/bin/sh
# Register the argv-backed editor entrypoint used by WezTerm file links.
set -eu
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"
if command -v herdr >/dev/null 2>&1; then
  herdr plugin link "$HOME/.config/herdr/plugins/file-popup" --enabled
fi
