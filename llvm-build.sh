#!/bin/sh
USERID=$1
GITHUB_TOKEN=$2

pacman -Syu --noconfirm base-devel sudo schedtool jq unzip python
#pacman -Syu --noconfirm base-devel sudo git jq curl unzip schedtool python clang lld
#curl -sLJO -H 'Accept: application/octet-stream' \
#"https://${GITHUB_TOKEN}@api.github.com/repos/mtak-misc/archive/releases/assets/$( \
#curl -sL https://${GITHUB_TOKEN}@api.github.com/repos/mtak-misc/archive/releases/tags/latest \
#| jq '.assets[] | select(.name | contains("llvm")) | .id')"
#unzip llvm.zip
#pacman --noconfirm -U *.pkg.tar.zst
useradd builder -u ${USERID} -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --recv 38DBBDC86092693E"
cd ./linux-lqx ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
