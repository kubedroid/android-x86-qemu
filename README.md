# Android-x86 images for KubeVirt

This repository contains scripts which are used to create Android-x86 images
for use with qemu/KVM.

The output is a docker image, quay.io/kubedroid/android-x86-qemu:9.0-r2, which
you can run in Docker.

You can use this command to run this Docker image. It requires access to KVM and
a vGPU. There's more information on how to create a vGPU at the end of this document.

```
sudo docker run --rm -it \
    -p 5900:5900 \
    -p 5555:5555 \
    --ulimit memlock=-1:-1 \
    --device /dev/kvm \
    --device /dev/dri \
    --device /dev/vfio/vfio \
    --device /dev/vfio/12 \
    quay.io/quamotion/android-x86-qemu:9.0-r2
```

## Accessing your Android VM

You can connect to your VM using `adb` or VNC.

`adb` is enabled by default, so you can `adb connect [docker IP]:5555` to get a connection to your
Android VM.

VNC is enabled by default, so you can connect to `[docker IP]:5900` to get a VNC connection to
your Android VM.

## Initializing your Android VM

You may want to configure your VM over adb. For example, you may want to:

- Enable *unknown sources*: `adb shell settings put secure install_non_market_apps 1`
- Disable package verifiers: `adb shell settings put global package_verifier_enable 0`
- Disable the non-standard launcher (from a root shell): `pm disable com.farmerbb.taskbar.androidx86`

## Hardware acceleration

Your Android-x86 VM works better with has hardware acceleration. [You can use Android-x86 with
virtio (virglrenderer)](https://groups.google.com/forum/#!msg/android-x86/enPcst6oQ_w/8Etr0aEZAAAJ).

The images in this repository assume you have an Intel GPU, and a vGPU enabled. You'll need a reasonable
recent (let's assume 5.0 or later) Linux kernel for this to work.

To enable hardware acceleration:

1. Add the following lines to ` /etc/initramfs-tools/modules`:
   ```
   kvmgt
   vfio-iommu-type1
   vfio-mdev
   ```
2. Add `i915.enable_gvt=1 intel_iommu=on` to the kernel boot parameter in `/etc/default/grub` and run `update-grub`
3. Reboot
4. Make sure the `/sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/` file exists
5. Add a vGPU: 
   ```
   echo "a297db4a-f4c2-11e6-90f6-d3b88d6c9525" > "/sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_4/create"
   ```

## Project Sponsor

This project is sponsored by [Quamotion](http://quamotion.mobi).
