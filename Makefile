docker: Dockerfile
	sudo docker build . -t quay.io/quamotion/android-x86-qemu:7.1-r2
	sudo docker image ls --format "{{.ID}}" quay.io/quamotion/android-x86-qemu:7.1-r2 > docker

run: docker
	sudo docker run --rm --device /dev/kvm -it $$(cat docker)
