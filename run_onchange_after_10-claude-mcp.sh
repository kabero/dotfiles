#!/bin/sh
# Standard-equipment MCP servers for Claude Code.
#
# Claude Code stores user-scope MCP servers in ~/.claude.json, a state file full
# of machine-local cruft (session history, caches), so it is not chezmoi-managed.
# This script re-creates the entries instead, and re-runs whenever its own
# contents change — add a server here to roll it out to every machine.
#
# playwright: microsoft/playwright-mcp — drives a real browser through the
# accessibility tree instead of screenshots. Needs Node 18+ (npx) and Chrome.
# https://github.com/microsoft/playwright-mcp

set -eu

if ! command -v claude >/dev/null 2>&1; then
    echo "claude not found; skipping MCP registration" >&2
    exit 0
fi

add_mcp() {
    name=$1
    shift
    if claude mcp get "$name" >/dev/null 2>&1; then
        echo "mcp: $name already registered"
    else
        claude mcp add --scope user "$name" -- "$@"
    fi
}

add_mcp playwright npx -y @playwright/mcp@latest
