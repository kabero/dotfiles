#!/bin/bash
while true; do
    read -p "Do you wish to uninstall your settings? (y/n)" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit 0;;
        * ) echo "Please answer yes or no.";;
    esac
done


# zsh
rm -rf ~/.zsh
rm -rf ~/.zshrc

# alacritty
rm -rf ~/.config/alacritty/

# vim
rm ~/.vimrc

# nvim & ultisnips
rm -rf ~/.config/nvim

# tmux
rm -rf ~/.tmux.conf

# git
rm -rf ~/.gitconfig

# ideavim
rm -rf ~/.ideavimrc

# broot
# rm -rf ~/.config/broot


echo Finished!
