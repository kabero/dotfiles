# dotfiles

alacritty, asdf, git, neovim, starship, tmux, vim, zsh, chezmoi, obsidian, fzf, navi, pet

## 🚀 Setup

### Prerequisites
- macOS
- [Homebrew](https://brew.sh/) installed

### Initial Setup Steps

1. **Install chezmoi**
   ```sh
   brew install chezmoi
   ```

2. **Set environment variables**

   Add the following to `~/.zshenv`etc.:
   ```sh
   export GIT_USER_NAME="your_name"
   export GIT_USER_EMAIL="your_email@example.com"
   ```

3. **Initialize and apply dotfiles**
   ```sh
   chezmoi init https://github.com/kabero/dotfiles.git
   chezmoi apply
   ```

4. **Install packages (option)**
   ```sh
   # Install packages using Brewfile
   brew bundle --file=~/.local/share/chezmoi/excludes/Brewfile
   ```

5. **Additional setup**
   ```sh
   # Setup Alacritty theme
   ~/.local/share/chezmoi/excludes/setup.sh

   # Setup bufpreview (Neovim)
   cd $LAZYDIR/bufpreview.vim && deno task prepare

   # Install tools with asdf
   asdf install
   ```

## ⚙️ Configuration

### Environment Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `GIT_USER_NAME` | Git user name | Required |
| `GIT_USER_EMAIL` | Git email address | Required |

### Aliases
```sh
alias vi='NVIM_APPNAME=nvim-light nvim'
```

### zsh-completions
`$HOME/.zsh/completions/`

## 🔧 Tools

### Neovim
- Measure startup time: `vim-startuptime -vimpath nvim`

### Key Bindings
#### fzf
- `Ctrl+S`: pet (command snippets)
- `Ctrl+R`: command history
- `Ctrl+G`: ghq (repository jump)
- `Ctrl+T`: file selection in current directory
