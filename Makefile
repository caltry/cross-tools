TARGET := arm-none-eabi
PREFIX := $(PWD)/local-prefix
LANGUAGES := c

BINUTILS_HOST := http://ftp.gnu.org/gnu/binutils/
BINUTILS_SRCDIR := binutils-2.23.1
BINUTILS_BUILDDIR := build-binutils
BINUTILS_FILENAME := binutils-2.23.1.tar.bz2

GCC_HOST := http://gcc.petsads.us/releases/gcc-4.7.2/
GCC_SRCDIR := gcc-4.7.2
GCC_BUILDDIR := build-gcc
GCC_FILENAME := gcc-4.7.2.tar.bz2
GCC_MD5 := cc308a0891e778cfda7a151ab8a6e762

GDB_HOST := ftp://sourceware.org/pub/gdb/releases/
GDB_SRCDIR := gdb-7.5.1
GDB_BUILDDIR := build-gdb
GDB_FILENAME := gdb-7.5.1.tar.bz2

all: gcc-all binutils-all gdb-all

.PHONY: clean target-clean realclean distclean
clean:
	$(MAKE) -C $(GCC_BUILDDIR) clean
	$(MAKE) -C $(BINUTILS_BUILDDIR) clean
	$(MAKE) -C $(GDB_BUILDDIR) clean

target-clean:
	rm -rf $(GCC_BUILDDIR) $(BINUTILS_BUILDDIR) $(GDB_BUILDDIR)

realclean: target-clean
	rm -rf $(GCC_SRCDIR) $(BINUTILS_SRCDIR) $(GDB_SRCDIR)

distclean: realclean
	rm -f $(GCC_FILENAME) $(BINUTILS_FILENAME) $(GDB_FILENAME)

.PHONY: gcc-all
gcc-all: $(GCC_SRCDIR) binutils-all
	mkdir -p $(GCC_BUILDDIR) &&\
	cd $(GCC_BUILDDIR) &&\
	../$(GCC_SRCDIR)/configure \
		--target=$(TARGET) \
		--prefix=$(PREFIX) \
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
		--prefix=$(PREFIX)
	$(MAKE) -C $(BINUTILS_BUILDDIR)
	$(MAKE) -C $(BINUTILS_BUILDDIR) install

.PHONY: gdb-all
gdb-all: $(GDB_SRCDIR)
	mkdir -p $(GDB_BUILDDIR) &&\
	cd $(GDB_BUILDDIR) &&\
	../$(GDB_SRCDIR)/configure \
		--target=$(TARGET) \
		--prefix=$(PREFIX)
	$(MAKE) -C $(GDB_BUILDDIR)
	$(MAKE) -C $(GDB_BUILDDIR) install

$(GCC_SRCDIR): $(GCC_FILENAME)
	tar xf $(GCC_FILENAME)

$(GCC_FILENAME): 
	wget $(GCC_HOST)/$(GCC_FILENAME)

$(BINUTILS_SRCDIR): $(BINUTILS_FILENAME)
	tar xf $(BINUTILS_FILENAME)

$(BINUTILS_FILENAME):
	wget $(BINUTILS_HOST)/$(BINUTILS_FILENAME)

$(GDB_SRCDIR): $(GDB_FILENAME)
	tar xf $(GDB_FILENAME)

$(GDB_FILENAME):
	wget $(GDB_HOST)/$(GDB_FILENAME)
