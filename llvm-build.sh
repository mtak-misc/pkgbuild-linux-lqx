#!/bin/sh
USERID=$1

pacman -Syu --noconfirm base-devel sudo schedtool unzip python
# pacman -Syu --noconfirm base-devel sudo git jq curl unzip schedtool python clang lld
useradd builder -u ${USERID} -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst

su builder -c "gpg --recv 38DBBDC86092693E"
cd ./linux-lqx ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
