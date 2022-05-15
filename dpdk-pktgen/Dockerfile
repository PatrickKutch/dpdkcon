# get base ubuntu image
FROM ubuntu-base

# run docker image
LABEL RUN docker run -it --name ubuntu-dpdk-pktgen-build
ENV RTE_SDK /root/dpdk

# clone and install dpdk
WORKDIR /root
RUN git clone http://dpdk.org/git/dpdk 

WORKDIR /root/dpdk
RUN git checkout v21.11 \
    && meson build \
    && cd build \
    && ninja \
    && ninja install \
    && ldconfig

# clone and install dpdk-pktgen
WORKDIR /root
RUN apt-get install libpcap-dev -y \
    && git clone http://dpdk.org/git/apps/pktgen-dpdk

WORKDIR /root/pktgen-dpdk 
RUN meson build \
    && cd build \
    && ninja \
    && ninja install 

WORKDIR /root/pktgen-dpdk
