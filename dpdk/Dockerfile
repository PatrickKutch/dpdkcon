# get base ubuntu image
# I like ubuntu, easy to get packages
FROM ubuntu:20.04


# update repos and install required packages
RUN chsh -s /usr/bin/bash \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get install -y -q \
    && chmod 777 /var/cache/debconf/ \
    && chmod 777 /var/cache/debconf/passwords.dat \
    && apt-get update \
    && apt-get install apt-utils dialog -y \
    && apt-get upgrade -y \
    && echo "apt-get install linux-image-$(uname -r) -y" \
    && apt-get autoremove -y 

RUN packages="build-essential git python python3 pciutils meson libnuma-dev vim netperf sudo htop ethtool bash-completion libtool iproute2 python3-pyelftools iputils-ping net-tools pkg-config cmake libpcap-dev" \
    && for i in $packages; do apt-get install --ignore-missing -y "$i"; done

#Default DPDK Version to build, override with --build-arg DPDK_VERSION=20.04 or other
ARG DPDK_VER=v19.11
# My projects may want PTP, so I pass this as a potential ARG
ARG CONFIG_RTE_LIBRTE_IEEE1588='0'

# run docker image
LABEL DPDK_VERSION=${DPDK_VER}
ENV RTE_SDK /root/dpdk

# clone and install dpdk
WORKDIR /root
RUN git clone http://dpdk.org/git/dpdk

WORKDIR /root/dpdk
RUN git checkout ${DPDK_VER} \
    # I might want PTP to be optionally compiled, so insert based on ARG
    && sed -i "/i40e/a #define CONFIG_RTE_LIBRTE_IEEE1588 $CONFIG_RTE_LIBRTE_IEEE1588" /root/dpdk/config/rte_config.h \
    && meson build \
    && cd build \
    && ninja \
    && ninja install \
    && ldconfig

WORKDIR /root
COPY launcher.py /launcher.py
RUN chmod +x /launcher.py

ENTRYPOINT ["/launcher.py"]
