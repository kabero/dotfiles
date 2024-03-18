FROM --platform=linux/x86_64 archlinux:base
RUN echo 'Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
RUN pacman -Sy
RUN pacman -S --noconfirm neovim chezmoi zsh git
RUN pacman -S --noconfirm deno base-devel ripgrep

RUN mkdir /workspace
RUN chsh -s /bin/zsh
RUN chezmoi init https://github.com/kabero/dotfiles
RUN chezmoi apply
WORKDIR /workspace
