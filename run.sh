#!/bin/bash

device_id=$(ls /sys/bus/mdev/devices/)

# Notable options:
# "-append" sets the kernel options.
# VIRT_WIFI disables virtual WiFi, and makes sure the device connects immediately to the network.
# This, in turn, makes sure adb is available
# For debugging purposes, you can consider adding DEBUG=2

# "-M graphics=off" disables built-in graphics
# "-display egl-graphics", together with "-device vfio-pci ...",
# which will allow us to run with a vGPU, or
# "-device virtio-vga,virgl=on" to use a host-based GL renderer.

# "-vnc :0" enables VNC for display 0, at port 5900.

# "-device e1000... "
# enables the default network, and forward TCP port 5555, over which adb connects

qemu-system-x86_64 \
     -enable-kvm \
     -kernel /android/kernel \
     -append "root=/dev/ram0 androidboot.selinux=permissive console=ttyS0 RAMDISK=vdb ${ANDROID_KERNEL_OPTIONS}" \
     -initrd /android/initrd.img \
     -boot menu=on \
     -drive index=0,if=virtio,id=system,file=/android/system.sfs,format=raw,readonly \
     -drive index=1,if=virtio,id=ramdisk,file=/android/ramdisk.img,format=raw,readonly \
     -m 4G \
     -smp 2 \
     -serial stdio \
     -nodefaults \
     -M graphics=off \
     -display egl-headless,gl=on \
     -device virtio-vga,virgl=on \
     -vnc :0 \
     -device e1000,netdev=net0 -netdev user,id=net0,hostfwd=tcp::5555-:5555 \
     -device virtio-tablet-pci
