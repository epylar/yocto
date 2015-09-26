SSTATESETUP ?= echo using default sstate

all: openjdk-7-jre

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

# Init poky from git cache
poky: cache
	rsync -a --delete cache/ poky/
	cd poky && git checkout -b fido origin/fido

# Clone remote poky/layers into git cache
cache:  
	rm -rf cache
	git clone http://git.yoctoproject.org/git/poky cache && \
		cd cache && \
		git clone https://git.yoctoproject.org/cgit/cgit.cgi/meta-java meta-java && \
		git clone http://git.openembedded.org/meta-openembedded meta-openembedded

# Build core-image-sato
openjdk-7-jre: poky dependencies
	cd poky && . ./oe-init-build-env && ${SSTATESETUP} &&  bitbake openjdk-7-jre

# Delete poky
clean:
	rm -rf poky
