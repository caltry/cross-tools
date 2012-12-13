TARGET_ARCH ?= arm
TARGET ?= $(TARGET_ARCH)-none-eabi
PREFIX ?= $(PWD)/arm-prefix
LANGUAGES ?= c

BINUTILS_HOST := http://ftp.gnu.org/gnu/binutils/
BINUTILS_SRCDIR := binutils-2.23.1
BINUTILS_BUILDDIR := build-binutils
BINUTILS_FILENAME := binutils-2.23.1.tar.bz2

GCC_HOST := http://gcc.petsads.us/releases/gcc-4.7.2/
GCC_SRCDIR := gcc-4.7.2
GCC_BUILDDIR := build-gcc
GCC_FILENAME := gcc-4.7.2.tar.bz2
GCC_MD5 := cc308a0891e778cfda7a151ab8a6e762

all: gcc-all binutils-all

.PHONY: clean target-clean realclean distclean
clean:
	$(MAKE) -C $(GCC_BUILDDIR) clean
	$(MAKE) -C $(BINUTILS_BUILDDIR) clean

target-clean:
	rm -rf $(GCC_BUILDDIR) $(BINUTILS_BUILDDIR)

realclean: target-clean
	rm -rf $(GCC_SRCDIR) $(BINUTILS_SRCDIR)

distclean: realclean
	rm -f $(GCC_FILENAME) $(BINUTILS_FILENAME)

.PHONY: gcc-all
gcc-all: $(GCC_SRCDIR) binutils-all
	mkdir -p $(GCC_BUILDDIR) &&\
	cd $(GCC_BUILDDIR) &&\
	../$(GCC_SRCDIR)/configure \
		--target=$(TARGET) \
		--prefix=$(PREFIX) \
		--disable-nls \
		--enable-languages=$(LANGUAGES) \
		--without-headers \
		--disable-libssp \
		--with-gmp=/usr/local
	#LD_LIBRARY_PATH="/usr/local/lib"
	$(MAKE) -C $(GCC_BUILDDIR)
	$(MAKE) -C $(GCC_BUILDDIR) install

.PHONY: binutils-all
binutils-all: $(BINUTILS_SRCDIR)
	mkdir -p $(BINUTILS_BUILDDIR) &&\
	cd $(BINUTILS_BUILDDIR) &&\
	../$(BINUTILS_SRCDIR)/configure \
		--target=$(TARGET) \
		--prefix=$(PREFIX) \
		--disable-nls
	$(MAKE) -C $(BINUTILS_BUILDDIR)
	$(MAKE) -C $(BINUTILS_BUILDDIR) install

$(GCC_SRCDIR): $(GCC_FILENAME)
	tar xf $(GCC_FILENAME)

$(GCC_FILENAME): 
	wget $(GCC_HOST)/$(GCC_FILENAME)

$(BINUTILS_SRCDIR): $(BINUTILS_FILENAME)
	tar xf $(BINUTILS_FILENAME)

$(BINUTILS_FILENAME):
	wget $(BINUTILS_HOST)/$(BINUTILS_FILENAME)
