#!/bin/sh
USERID=$1
GITHUB_TOKEN=$2

pacman -Syu --noconfirm base-devel sudo schedtool jq unzip python
#pacman -Syu --noconfirm base-devel sudo git jq curl unzip schedtool python clang lld
useradd builder -u ${USERID} -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

pacman -Syu --noconfirm git
git clone --depth 1 https://gitlab.archlinux.org/archlinux/packaging/packages/pahole.git
chown builder -R pahole
cd pahole
sed -i '/cd dwarves-/a \ \ patch -Np1 -i ../pahole.patch' PKGBUILD
sed -i '/cd dwarves-/a \ \ curl -L https://github.com/acmel/dwarves/commit/6a2b27c0f512619b0e7a769a18a0fb05bb3789a5.patch -o ../pahole.patch' PKGBUILD
su builder -c "gpg --recv B23CA2E9A4227E27"
su builder -c "yes '' | makepkg --noconfirm -sc"
pacman --noconfirm -U pahole-1:1.27-1-x86_64.pkg.tar.zst
cd ..

curl -sLJO -H 'Accept: application/octet-stream' \
"https://${GITHUB_TOKEN}@api.github.com/repos/mtak-misc/archive/releases/assets/$( \
curl -sL https://${GITHUB_TOKEN}@api.github.com/repos/mtak-misc/archive/releases/tags/latest \
| jq '.assets[] | select(.name | contains("llvm")) | .id')"
unzip llvm.zip
pacman --noconfirm -U *.pkg.tar.zst
su builder -c "gpg --recv 38DBBDC86092693E"
cd ./linux-lqx ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
