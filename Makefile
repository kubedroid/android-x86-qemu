docker: Dockerfile
	sudo docker build . -t quay.io/quamotion/android-x86-qemu:7.1-r2
	sudo docker image ls --format "{{.ID}}" quay.io/quamotion/android-x86-qemu:7.1-r2 > docker

gpu_id=a297db4a-f4c2-11e6-90f6-d3b88d6c9525
iommu_group=$(shell readlink -f /sys/bus/mdev/devices/$(gpu_id)/iommu_group)
vfio_id=$(shell basename $(iommu_group))

run: docker
	echo $(vfio_id)
	sudo docker run --rm \
	  --device /dev/kvm \
	  --device /dev/vfio/$(vfio_id) \
	  --device /dev/vfio/vfio \
	  --device /dev/dri/renderD128 \
	  -p 5000:5000 \
	  -p 5900:5900 \
	  -it $$(cat docker)
