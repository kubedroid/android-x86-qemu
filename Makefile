docker: android-x86_64-7.1-r4.iso
	sudo docker build . -t quay.io/quamotion/android-x86-qemu:7.1-r4

android-x86_64-7.1-r4.iso:
	wget -nc https://osdn.net/dl/android-x86/android-x86_64-7.1-r4.iso -O android-x86_64-7.1-r4.iso

run:
	sudo docker run --rm -it \
	  -p 5900:5900 \
	  -p 5555:5555 \
	  --ulimit memlock=-1:-1 \
	  --device /dev/kvm \
	  --device /dev/dri \
	  quay.io/quamotion/android-x86-qemu:7.1-r4

debug:
	sudo docker run --rm -it \
	  -p 5900:5900 \
	  -p 5555:5555 \
	  --ulimit memlock=-1:-1 \
	  --device /dev/kvm \
	  --device /dev/dri \
	  quay.io/quamotion/android-x86-qemu:7.1-r4 /bin/bash
