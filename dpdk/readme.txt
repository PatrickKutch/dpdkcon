Instructions to build the containers

the build_vesions.sh script will build all the versions of DPDK specified in the script.

If you use 'ptp' as a parameter to this script, it will complile in PTP support.

to run the container you need to mount a lot of volumes

docker run --privileged --rm --cap-add=ALL -v /sys/bus/pci/devices:/sys/bus/pci/devices -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /sys/devices/system/node:/sys/devices/system/node -v /mnt/huge:/mnt/huge -v /lib/modules:/lib/modules --name dpdk-2105 -it patrickkutch/dpdk:v21.05 command and parameter

I create a helper script or an alias (I call it dpdkcon):
docker run --privileged --rm --cap-add=ALL  
-v /sys/bus/pci/devices:/sys/bus/pci/devices 
-v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages 
-v /sys/devices/system/node:/sys/devices/system/node 
-v /mnt/huge:/mnt/huge
-v /lib/modules:/lib/modules $@

the container has the ability to run anything, such as dpdk-devbind.py:
dpdkcon -it patrickkutch/dpdk:v21.11 dpdk-devbind.py -b vfio-pci 0000:18:11.1
or just a simple ls
dpdkcon -it patrickkutch/dpdk:v19.11 ls