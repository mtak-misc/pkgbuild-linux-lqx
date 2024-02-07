#!/bin/sh
#USERID=$1
GITHUB_TOKEN=$1

pacman -Syu --noconfirm base-devel sudo schedtool jq unzip python
#pacman -Syu --noconfirm base-devel sudo git jq curl unzip schedtool python clang lld
curl -sLJO -H 'Accept: application/octet-stream' \
"https://${GITHUB_TOKEN}@api.github.com/repos/mtak-misc/pkgbuild-llvm-git/releases/assets/$( \
curl -sL https://${GITHUB_TOKEN}@api.github.com/repos/mtak-misc/pkgbuild-llvm-git/releases/tags/latest \
| jq '.assets[] | select(.name | contains("llvm")) | .id')" -o llvm-git.zip
unzip llvm-git.zip
pacman --noconfirm -U llvm-git*.pkg.tar.zst llvm-libs-git*.pkg.tar.zst
useradd builder -u ${USERID} -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --recv 38DBBDC86092693E"
cd ./linux-lqx ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
