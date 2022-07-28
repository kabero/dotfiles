#!/bin/bash
curdir=$(cd $(dirname $0); pwd)

# make directories where config files are saved
mkdir -p ~/.config 2>/dev/null
mkdir -p ~/.config/alacritty 2>/dev/null
mkdir -p ~/.config/nvim 2>/dev/null
mkdir -p ~/.config/nvim/lua 2>/dev/null
mkdir -p ~/.zsh 2>/dev/null
mkdir -p ~/.config/broot
mkdir -p ~/.config/alacritty/colorthemes

# make a directory for ultisnips
mkdir -p ~/.config/nvim/UltiSnips

# zsh
ln -sf $curdir/zsh/.zshrc ~/.zshrc
ln -sf $curdir/zsh/alias.zsh ~/.zsh/alias.zsh
ln -sf $curdir/zsh/opt.zsh ~/.zsh/opt.zsh
ln -sf $curdir/zsh/prompt.zsh ~/.zsh/prompt.zsh
ln -sf $curdir/zsh/lazyenv.zsh ~/.zsh/lazyenv.zsh
ln -sf $curdir/zsh/comp.zsh ~/.zsh/comp.zsh
ln -sf $curdir/zsh/fzf.zsh ~/.zsh/fzf.zsh
echo "zsh"

# Alacritty
ln -sf $curdir/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
for file in `\find ./alacritty/colorthemes/dracula.yml -maxdepth 1 -type f`; do
    base=$(basename $file)
    echo "Alacritty/colortheme: $base"
    ln -sf $curdir/alacritty/colorthemes/$base ~/.config/alacritty/colorthemes/$base
done
echo "Alacritty"

# nvim
ln -sf $curdir/nvim/init.lua ~/.config/nvim/init.lua
ln -sf $curdir/nvim/lua/options.lua ~/.config/nvim/lua/options.lua
ln -sf $curdir/nvim/lua/keymaps.lua ~/.config/nvim/lua/keymaps.lua
ln -sf $curdir/nvim/lua/commands.lua ~/.config/nvim/lua/commands.lua
ln -sf $curdir/nvim/lua/plugins.lua ~/.config/nvim/lua/plugins.lua
ln -sf $curdir/nvim/lua/color.lua ~/.config/nvim/lua/color.lua
echo "NeoVim"

# ultisnips
# If a snippet file already exists in your nvim config directory (not this dotfiles directory),
# this script will be stopped and exited with 1
for file in `\find ./nvim/ultisnips -maxdepth 1 -type f`; do
    base=$(basename $file)
    echo "Ultisnips: $base"
    tmppath=~/.config/nvim/ultisnips/$base
    if [ -e $tmppath ] && [ ! -L $tmppath ] && [ $base != ".DS_Store" ]; then
        echo "$base (not symbolic link) already exists."
        exit 1
    fi
    ln -sf $curdir/nvim/ultisnips/$base ~/.config/nvim/UltiSnips/$base
done

# tmux
ln -sf $curdir/tmux/.tmux.conf ~/.tmux.conf
echo "tmux"

# git
ln -sf $curdir/git/.gitconfig ~/.gitconfig
echo "git"

# ideavim
ln -sf $curdir/ideavim/.ideavimrc ~/.ideavimrc

# broot
# ln -sf $curdir/broot/verbs.hjson ~/.config/broot/
# echo "broot"
