# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/)

**Included tools**: asdf, git, neovim, starship, wezterm, herdr, vim, zsh, chezmoi, fzf, delta

## Table of Contents

- [Setup](#-setup)
- [Configuration](#️-configuration)
- [Directory Structure](#-directory-structure)
- [Usage](#-usage)
- [Customization](#-customization)
- [Troubleshooting](#-troubleshooting)

## 🚀 Setup

### Prerequisites

- macOS (Linux support is partial)
- [Homebrew](https://brew.sh/) installed

### Initial Setup Steps

#### 1. Install chezmoi

```sh
brew install chezmoi
```

#### 2. Set environment variables

**Important**: You must configure the following environment variables before applying dotfiles.

Create or edit `~/.zshenv` or `~/.zprofile` and add:

```sh
# Git configuration (Required)
export GIT_USER_NAME="your_name"
export GIT_USER_EMAIL="your_email@example.com"

# ghq configuration (Optional)
export GHQ_ROOT="$HOME/ghq"  # default: ~/ghq
```

**Note**:
- `~/.zshenv` is loaded for all zsh sessions (recommended)
- `~/.zprofile` is loaded only for login shells
- Choose one location and add the variables there

#### 3. Initialize and apply dotfiles

```sh
chezmoi init https://github.com/kabero/dotfiles.git
chezmoi apply
```

#### 4. Install packages (Optional)

```sh
# Install packages using Brewfile
brew bundle --file=~/.local/share/chezmoi/excludes/Brewfile
```

#### 5. Additional setup

```sh
# Install language runtimes with asdf (per-project .tool-versions)
asdf install
```

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Default Value | Required |
|----------|-------------|---------------|----------|
| `GIT_USER_NAME` | Git user name | none | ✅ Required |
| `GIT_USER_EMAIL` | Git email address | none | ✅ Required |
| `GHQ_ROOT` | ghq root directory | `~/ghq` | Optional |

### Zsh Features

- **Shared history**: Command history is shared across all terminal sessions (`share_history`)
- **PATH management**: Prepends `~/scripts/bin`, `~/bin`, and `~/.local/bin` (among others) to PATH
- **fzf-powered widgets**:
  - `Ctrl+R` / `Ctrl+T` / `Ctrl+G`: history / file / ghq-repo pickers (see [Key Bindings](#-usage))
  - `zz`: interactive `cd` via zoxide + fzf
  - `ghq()` wrapper: invalidates the repo cache on clone/rm so new repos appear immediately

### Aliases

```sh
alias vim="nvim"
alias view="nvim -R"
```

### Zsh Completions

Custom completions are stored in `$HOME/.zsh/completions/`

## 📁 Directory Structure

```
~/.local/share/chezmoi/
├── dot_config/
│   ├── nvim/                 # Neovim configuration (Lua-based, has its own README.md)
│   ├── git/                  # Git configuration
│   │   └── config.tmpl       # Git config with template variables
│   ├── wezterm/              # WezTerm terminal configuration
│   ├── starship.toml         # Starship prompt configuration
│   └── ...
├── dot_zshrc.tmpl            # Zsh configuration (main)
├── dot_zshrc.d/              # Creates an empty ~/.zshrc.d on every machine (drop-ins live there, unmanaged)
├── dot_asdfrc                # asdf configuration
├── dot_vimrc                 # Vim configuration (lightweight, plugin-free)
├── dot_local/bin/            # Executable scripts (git-wt, herdr-repo-selector, ...)
├── dot_claude/               # Claude Code config (CLAUDE.md, agents, settings)
├── run_onchange_after_10-claude-mcp.sh  # Registers standard MCP servers (playwright)
├── excludes/                 # Kept in the repo, NOT applied to $HOME
│   ├── Brewfile              # Homebrew package list
│   ├── Dockerfile            # Container build reference
│   ├── scripts/              # Misc setup/helper scripts
│   └── vimium_config.txt     # Vimium key configuration
├── examples/
│   ├── .nvim.lua.template    # Project-specific Neovim config template
│   └── README.md             # Detailed usage guide
└── README.md                 # This file
```

## 🔧 Usage

### Chezmoi Basic Commands

```sh
# Apply changes to your system
chezmoi apply

# Check differences between source and target
chezmoi diff

# Edit a managed file
chezmoi edit ~/.zshrc

# Add a new file to chezmoi management
chezmoi add ~/.newconfig

# Check status of managed files
chezmoi status

# Navigate to chezmoi source directory
chezmoi cd
```

### Reviewing a diff (`git review`)

`git review` groups a diff into review-sized chunks with Claude and pages the result through delta.
It takes the same arguments as `git diff`:

```sh
git review                  # HEAD vs working tree (staged + unstaged)
git review --cached         # staged only
git review HEAD~3
git review master...HEAD    # PR-style diff
git review HEAD~3 -- src/   # limited to a pathspec
git rv HEAD~3               # alias
```

The diff is split into hunks, Claude assigns each hunk to one or more groups and writes a title,
an explanation, and concrete review points per group, and each group is re-assembled into its own
diff for delta. A file can appear in several groups, and so can a single hunk — one change often
deserves a second look from another angle.

Inside the pager, `n` / `N` jump between groups (`less` is started with the group heading as its
search pattern), `/` searches, `q` quits.

| Flag | Effect |
| --- | --- |
| `--refresh` | Ignore the cache and ask Claude again |
| `--no-cache` | Neither read nor write the cache |
| `--json` | Print the grouping as JSON instead of paging it |
| `--no-pager` | Write to stdout instead of a pager |
| `--model` | Model to use (default `sonnet`, or `$GIT_REVIEW_MODEL`) |

Results are cached in `.git/claude-review/`, keyed by the diff itself, so re-opening the same diff
is instant and any change to the diff re-runs the analysis. The 50 newest entries are kept. The
cache lives inside `.git`, so it is never committed and disappears with the clone.

Requires `delta` and the `claude` CLI on `PATH`. Untracked files are not part of a diff — `git add`
them first if they should be reviewed.

### Neovim

📖 **See [`dot_config/nvim/README.md`](./dot_config/nvim/README.md)** for the full configuration overview, distinctive settings, and the keybinding cheatsheet.

#### Basic Usage

- **Plugin manager**: lazy.nvim (specs under `dot_config/nvim/lua/plugins/`)
- **LSP**: mason + mason-lspconfig with native `vim.lsp` (Neovim 0.11+)
- **Measure startup time**: `nvim --startuptime /tmp/nvim.log` then inspect the log

#### Project-Specific Configuration (.nvim.lua)

You can configure project-specific LSP settings, formatters, and more using `.nvim.lua` files.

**How to use**:

1. Copy the template to your project root:
   ```sh
   cp ~/.local/share/chezmoi/examples/.nvim.lua.template .nvim.lua
   ```

2. Edit `.nvim.lua` according to your project needs

3. Open Neovim in the project directory - you'll be prompted to trust the file

**For more details**: See `~/.local/share/chezmoi/examples/README.md`

### Key Bindings

#### fzf

- `Ctrl+R`: command history search
- `Ctrl+G`: ghq (repository navigation)
- `Ctrl+T`: file selection in current directory

## 💡 Customization

### Editing Configuration Files

To edit chezmoi-managed configuration files:

```sh
# Method 1: Using chezmoi edit (recommended)
chezmoi edit ~/.zshrc

# Method 2: Edit directly in source directory
cd ~/.local/share/chezmoi
nvim dot_zshrc.tmpl

# After editing, apply changes
chezmoi apply
```

### Device-Specific Configuration

Anything that differs per machine goes outside the managed files:

| Location | Managed by chezmoi | Use for |
| --- | --- | --- |
| `~/.zshrc.d/*.zsh` | No | Settings for this machine only, secrets |
| `~/.zshenv` | No | `PATH`/env vars needed before `~/.zshrc` (e.g. before `compinit`) |

`~/.zshrc` sources `~/.zshrc.d/*.zsh` last, in name order, so drop-ins can override anything above
them. Prefix files with a number to control the order (`10-work.zsh`, `99-local.zsh`). Editing a
drop-in takes effect in the next shell — no `chezmoi apply`, nothing to commit.

`chezmoi apply` creates the empty `~/.zshrc.d` for you; only its contents are unmanaged, and apply
never touches the files you put there.

```sh
cat >> ~/.zshrc.d/99-local.zsh <<'EOS'
export PATH="$HOME/work/bin:$PATH"
alias k=kubectl
EOS
exec zsh
```

Differences that are common to a whole OS or architecture belong in `dot_zshrc.tmpl` instead, as
template conditionals — see [OS-Specific Configuration](#os-specific-configuration).

### Template Variables

Files with `.tmpl` extension can use chezmoi template features:

- `{{ .chezmoi.os }}` - OS name (darwin, linux)
- `{{ .chezmoi.arch }}` - Architecture (amd64, arm64)
- `{{ env "VAR_NAME" }}` - Environment variable reference
- `{{ env "VAR" | default "value" }}` - Environment variable with default value

**Example** (from `dot_config/git/config.tmpl`):

```toml
[user]
    name = {{ env "GIT_USER_NAME" }}
    email = {{ env "GIT_USER_EMAIL" }}

[ghq]
    root = {{ env "GHQ_ROOT" | default "~/ghq" }}
```

### OS-Specific Configuration

Use template conditionals for OS-specific settings:

```zsh
{{ if eq .chezmoi.os "darwin" }}
# macOS-specific configuration
export PATH="/opt/homebrew/bin:$PATH"
{{ else if eq .chezmoi.os "linux" }}
# Linux-specific configuration
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
{{ end }}
```

## 🐛 Troubleshooting

### Environment variables not set

**Symptoms**: Error when running `chezmoi apply`

**Solution**:
1. Add required environment variables to `~/.zshenv` or `~/.zprofile`
2. Open a new terminal session or run `source ~/.zshenv`
3. Run `chezmoi apply` again

### Git configuration not applied

**Check**:
```sh
# Verify environment variables are set
echo $GIT_USER_NAME
echo $GIT_USER_EMAIL

# Verify Git configuration
git config --global user.name
git config --global user.email
```

### ghq not working as expected

**Check**:
```sh
# Verify GHQ_ROOT environment variable
echo $GHQ_ROOT

# Verify ghq configuration
git config --global ghq.root
```

### Zsh configuration changes not reflected

**Solution**:
```sh
# Reload configuration
source ~/.zshrc

# Or open a new terminal session
```

### Accidentally edited a file outside chezmoi

**Solution**:
```sh
# Check differences
chezmoi diff

# Re-apply from chezmoi source
chezmoi apply --force
```

### Neovim plugins not working

**Solution**:
```sh
# Open Neovim and sync plugins
nvim
:Lazy sync
```

## 📚 Additional Resources

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [Neovim configuration & keybindings](./dot_config/nvim/README.md)
- [Project-specific Neovim settings](./examples/README.md)

## 🤝 Contributing

Feel free to fork this repository and customize it for your own use!

## 📝 License

This is personal configuration. Use at your own discretion.
