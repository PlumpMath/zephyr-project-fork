MDEF_FILE = prj.mdef
KERNEL_TYPE = micro
BOARD ?= qemu_x86
CONF_FILE = prj_$(ARCH).conf
SOURCE_DIR := $(ZEPHYR_BASE)/tests/kernel/test_mail/src

# Enable testing for private microkernel mailboxes
CFLAGS = -DTEST_PRIV_MBX

include ${ZEPHYR_BASE}/Makefile.inc
