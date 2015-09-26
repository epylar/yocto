SSTATESETUP ?= echo using default sstate

all: core-image-sato

# Set up Ubuntu 14.04 or later for building.
dependencies:
	@echo WARNING: installing dependencies. Sleeping 3 seconds.
	@echo Hit ^C to abort.
	sleep 3
	sudo apt-get install gawk wget git-core diffstat unzip texinfo \
    gcc-multilib build-essential chrpath socat libsdl1.2-dev \
    xterm
	sudo apt-get build-dep qemu
	touch dependencies

# Init poky from cache
poky: cache
	rsync -a --delete cache/ poky/
	cd poky && git checkout -b fido origin/fido

# Clone remote poky into cache
cache: 
	git clone http://git.yoctoproject.org/git/poky cache && cd cache && git clone https://git.yoctoproject.org/cgit/cgit.cgi/meta-java meta-java

# Build core-image-sato
core-image-sato: poky dependencies
	cd poky && . ./oe-init-build-env && ${SSTATESETUP} &&  bitbake core-image-sato

# Delete cache
wipe-cache:
	rm -rf cache	

# Delete poky
wipe-poky:
	rm -rf poky

# Delete cache and poky
wipe: wipe-cache wipe-poky
