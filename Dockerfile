FROM quay.io/kubedroid/android-x86-tools AS build

ENV ISO_URL=https://osdn.net/dl/android-x86/android-x86_64-7.1-r4.iso
ENV ISO_FILE=android-x86_64-7.1-r4.iso

WORKDIR /android

# Download the ISO file. You can cache this file locally, to save
# bandwidth
# We don't need the gitignore, but COPY fails if there are no files
# to copy (e.g. the iso file doesn't exist). Adding the gitignore
# to keep the command happy.
COPY android-*-7.1-r4.iso .gitignore ./
RUN if [ ! -f $ISO_FILE ]; then wget -nc $ISO_URL -O $ISO_FILE; fi \
#
# Extract the root file system
#
&& isoinfo -i $ISO_FILE -x /system.sfs > system.sfs \
#
# Extract the initrd image
#
&& isoinfo -i $ISO_FILE -x /initrd.img > initrd.img \
#
# Extract the ramdisk image
#
&& isoinfo -i $ISO_FILE -x /ramdisk.img > ramdisk.img \
#
# Extract the kernel
#
&& isoinfo -i $ISO_FILE -x /kernel > kernel \
#
# Remove the ISO file and Dockerfile
#
&& rm $ISO_FILE \
&& rm .gitignore

RUN mkdir ramdisk \
&& (cd ramdisk && zcat ../ramdisk.img | cpio -idv) \
&& rm ramdisk.img \
&& echo "ro.setupwizard.mode=EMULATOR\n" >> ./ramdisk/default.prop \
&& mkbootfs ./ramdisk | gzip > ramdisk.img \
&& rm -rf ./ramdisk

FROM ubuntu:20.04

WORKDIR /android

COPY --from=build /android/system.sfs /android
COPY --from=build /android/initrd.img /android
COPY --from=build /android/ramdisk.img /android
COPY --from=build /android/kernel /android

RUN apt-get update \
&& apt-get install -y --no-install-recommends nano qemu-system-x86 \
&& apt-get install -y --no-install-recommends libgl1 libegl1 libgl1-mesa-dri \
&& apt-get install -y --no-install-recommends adb \
&& rm -rf /var/lib/apt/lists/*

# You can pass additional kernel options by setting this environment variable.
# For example, DEBUG=2 will enable debug mode.
ENV ANDROID_KERNEL_OPTIONS="VIRT_WIFI=0"

COPY run.sh /android/
COPY healthcheck.sh /android/

CMD [ "/android/run.sh" ]

HEALTHCHECK CMD /android/healthcheck.sh
