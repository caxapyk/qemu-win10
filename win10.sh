#!/bin/sh

QEMU="/usr/bin/qemu-system-x86_64"
HDD=~/qemu/win10/win10.img

${QEMU} --enable-kvm \
-m 2048  \
-vga qxl \
-cpu host  \
-smp cores=4,threads=8 \
-drive driver=raw,file=${HDD},if=virtio \
-netdev tap,helper=/usr/lib/qemu/qemu-bridge-helper,id=nh0 \
-device virtio-net-pci,netdev=nh0,id=nic1 \
-device virtio-serial-pci \
-usb \
-device usb-tablet \
-rtc base=localtime,clock=host \
-spice port=5900,addr=127.0.0.1,disable-ticketing \
-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
-chardev spicevmc,id=spicechannel0,name=vdagent
