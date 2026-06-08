# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/)

**Included tools**: alacritty, asdf, git, neovim, starship, tmux, vim, zsh, chezmoi, obsidian, fzf, navi, pet

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
# Setup Alacritty theme
~/.local/share/chezmoi/excludes/setup.sh

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
- **PATH management**: Automatically adds `~/scripts/bin` and `~/.local/bin` to PATH
- **Custom functions**:
  - `ccommit`: AI-assisted commit message generation
  - `v()`: Note management with fzf integration
  - And more productivity-enhancing functions

### Aliases

```sh
alias vi='NVIM_APPNAME=nvim-light nvim'
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
│   ├── alacritty/            # Alacritty terminal configuration
│   ├── starship.toml         # Starship prompt configuration
│   └── ...
├── dot_zshrc.tmpl            # Zsh configuration (main)
├── dot_tmux.conf             # tmux configuration
├── dot_asdfrc                # asdf configuration
├── dot_vimrc                 # Vim configuration (lightweight, plugin-free)
├── excludes/
│   ├── Brewfile              # Homebrew package list
│   └── setup.sh              # Additional setup scripts
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

- `Ctrl+S`: pet (command snippets)
- `Ctrl+R`: command history search
- `Ctrl+G`: ghq (repository navigation)
- `Ctrl+T`: file selection in current directory

#### tmux

- `Ctrl-g`: navi integration - popup window for searching and selecting command snippets, selected text is loaded into tmux buffer

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
