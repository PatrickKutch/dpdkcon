# get ubuntu image, from my other stuff, no reason to duplicate effort
# change to get differnt version of dpdk, and change the version of pktgen
FROM patrickkutch/dpdk:v21.11 

# run docker image
LABEL RUN docker run -it --name dpdk-pktgen-build
ENV RTE_SDK /root/dpdk

# clone and install dpdk-pktgen
WORKDIR /root
RUN apt-get install libpcap-dev -y \
    && git clone https://github.com/pktgen/Pktgen-DPDK.git

WORKDIR /root/Pktgen-DPDK 
RUN git checkout pktgen-22.07.0 \
    && meson build \
    && cd build \
    && ninja \
    && ninja install 

WORKDIR /root/pktgen-dpdk
