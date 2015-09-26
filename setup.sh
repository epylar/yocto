#!/bin/bash
set -e
set -x

sudo apt-get install gawk wget git-core diffstat unzip texinfo \
  gcc-multilib build-essential chrpath socat libsdl1.2-dev \
  xterm
sudo apt-get build-dep qemu

if [ ! -d cache ]
then
  git clone http://git.yoctoproject.org/git/poky cache
fi

rsync -a --delete cache/ poky/

cd poky
git checkout -b fido origin/fido
source oe-init-build-env
