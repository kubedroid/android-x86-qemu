docker: android-x86_64-9.0-r2.iso
	sudo docker build . -t quay.io/quamotion/android-x86-qemu:9.0-r2

android-x86_64-9.0-r2.iso:
	wget -nc https://osdn.net/dl/android-x86/android-x86_64-9.0-r2.iso -O android-x86_64-9.0-r2.iso

run:
	sudo docker run --rm -it \
	  -p 5900:5900 \
	  -p 5555:5555 \
	  --ulimit memlock=-1:-1 \
	  --device /dev/kvm \
	  --device /dev/dri \
	  --device /dev/vfio/vfio \
	  --device /dev/vfio/12 \
	  quay.io/quamotion/android-x86-qemu:9.0-r2

debug:
	sudo docker run --rm -it \
	  -p 5900:5900 \
	  -p 5555:5555 \
	  --ulimit memlock=-1:-1 \
	  --device /dev/kvm \
	  --device /dev/dri \
	  --device /dev/vfio/vfio \
	  --device /dev/vfio/12 \
	  quay.io/quamotion/android-x86-qemu:9.0-r2 /bin/bash
