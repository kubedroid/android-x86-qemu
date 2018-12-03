FROM quay.io/quamotion/android-x86-disk:7.1-r2 AS disk

FROM quay.io/quamotion/qemu:latest

WORKDIR /disk
COPY --from=disk /disk /disk

EXPOSE 5000
EXPOSE 5900

ENTRYPOINT [ "/usr/local/bin/qemu-system-x86_64", \
 "-enable-kvm", \
 "-m", "4G", \
 "-smp", "2", \
 "-nodefaults", \
 "-M", "graphics=off", \
 "-serial", "stdio", \
 "-display", "egl-headless", \
 "-vnc", ":0", \
 "-device", "vfio-pci,sysfsdev=/sys/bus/mdev/devices/a297db4a-f4c2-11e6-90f6-d3b88d6c9525,display=on", \
 "-device", "e1000,netdev=net0", \
 "-netdev", "user,id=net0,hostfwd=tcp::5000-:5555", \
 "-hda", "/disk/android-x86.qcow2" ]
