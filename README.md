# Qemu Windows 10
Botstrap to run Windows 10 on your Linux machine using Qemu (with QXL driver and external bridged network).

## Get started
1. Create Windows 10 folder and put there virtual drive. It's recommended 50G and more for Windows 10.
```sh
mkdir -p ~/qemu/win10
cd ~/qemu/win10
qemu-img create win10.img 50G
```
2. Download Windows 10 ISO image at [https://www.microsoft.com/en-us/software-download/windows10ISO](https://www.microsoft.com/en-us/software-download/windows10ISO)
For a better perfomance use VitIO drivers for Windows from Fedora Project. Download ISO image at [https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/).

## Install Windows 10
```sh
win10.sh -cdrom /path/to/windows10/Win10_English_x64.iso -drive file=/path/to/VirtIO_Win_Drivers/virtio-win-0.1.149.iso,index=3,media=cdrom
```
## SPICE
This project use SPICE and QXl. Install QXl Driver and SPICE Agent on the guest to provide enhanced SPICE integration and performance. Download it at [https://www.spice-space.org/download.html](https://www.spice-space.org/download.html).

Use `spicy` to connect to virtual machine.
```sh
spicy -h 127.0.0.1 -p 5900
```

## Networking
Is uses "external networking" scheme with bridged network. Configure bridge on your host.
```sh
sudo ip add name br0 type bridge
sudo ip set eth0 master br0
```
Do not forget to disable dhcp on `eth0` intarface and release existing address. You can use `iproute2` or `netctl` to create bridge and manage network connections. Read mare at [Arch Wiki](https://wiki.archlinux.org/index.php/Network_bridge).

This project use QEMU [HelperNetworking](https://wiki.qemu.org/Features/HelperNetworking). It creates a tap file descriptor, attaches it to a bridge, and passes it back to QEMU. This helper runs with higher privileges and allows QEMU to be invoked as a non-privileged user.

Configure it according recomendations.
```sh
sudo chmod u+s /usr/lib/qemu/qemu-bridge-helper
```
At /etc/qemu/bridge.conf
```sh
allow br0
```

Accept forward traffict at bridge by adding iptables rule:
```sh
sudo iptables -I FORWARD -m physdev --physdev-is-bridged -j ACCEPT
```

You can manage tap interfaces using shell scripts `qemu-ifup` and `qemu-ifdown`. More at [Arch Wiki](https://wiki.archlinux.org/index.php/QEMU#Creating_bridge_manually).
