To build:
export Params="--build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$http_proxy --network=host"
# build docker image with latest DPDK using ubuntu-base image
docker build $Params --no-cache --rm -t patrickkutch/dpdk-pktgen:21.11 .

To test the image run: docker run --privileged  --cap-add=ALL -v /sys/bus/pci/devices:/sys/bus/pci/devices -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /sys/devices/system/node:/sys/devices/system/node -v /dev:/dev --name ubuntu-dpdk-pktgen -it patrickkutch/dpdk-pktgen:21.11 bash

There may be different versions as DPDK and pktgen progress.  Going to start with 21.11
