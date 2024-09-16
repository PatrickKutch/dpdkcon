To build:
make sure all the versions you want to use are properly set in the build_pktgen.sh file and run it! :-)
export Params="--build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --build-arg HTTP_
To test the image run: docker run --privileged  --cap-add=ALL -v /sys/bus/pci/devices:/sys/bus/pci/devices -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /sys/devices/system/node:/sys/devices/system/node -v /dev:/dev --name dpdk-pktgen -it patrickkutch/dpdk-pktgen:v24.07.1 pktgen

