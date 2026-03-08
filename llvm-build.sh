#!/bin/sh
USERID=$1
GITHUB_TOKEN=$2

pacman -Syu --noconfirm base-devel sudo schedtool jq unzip python
# pacman -Syu --noconfirm base-devel sudo git jq curl unzip schedtool python clang lld
useradd builder -u ${USERID} -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# curl -sLJO -H 'Accept: application/octet-stream' \
# "https://${GITHUB_TOKEN}@api.github.com/repos/mtak-misc/archive/releases/assets/$( \
# curl -sL https://${GITHUB_TOKEN}@api.github.com/repos/mtak-misc/archive/releases/tags/latest \
# | jq '.assets[] | select(.name | contains("llvm")) | .id')"
# unzip llvm.zip
curl -LO curl -L https://archlinux.org/packages/extra-staging/x86_64/llvm/download/ -o llvm-x86_64.pkg.tar.zst
curl -LO curl -L https://archlinux.org/packages/extra-staging/x86_64/lld/download/ -o lld-x86_64.pkg.tar.zst
curl -LO curl -L https://archlinux.org/packages/extra-staging/x86_64/compiler-rt/download/ -o compiler-rt-x86_64.pkg.tar.zst
curl -LO curl -L https://archlinux.org/packages/extra-staging/x86_64/clang/download/ -o clang-x86_64.pkg.tar.zst

pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst

su builder -c "gpg --recv 38DBBDC86092693E"
cd ./linux-lqx ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
