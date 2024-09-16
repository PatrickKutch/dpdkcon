# Declare the build arguments 
ARG DOCKER_REPO
ARG DPDK_IMAGE_NAME
ARG DPDK_VERSION

# Base image
FROM ${DOCKER_REPO}/${DPDK_IMAGE_NAME}:v${DPDK_VERSION}


# Set environment variables
LABEL RUN docker run -it --name dpdk-pktgen-build
ENV RTE_SDK /root/dpdk

# Install dependencies and clone pktgen
WORKDIR /root
RUN apt-get update && apt-get install -y libpcap-dev libnuma-dev libbsd-dev git meson ninja-build

# Clone and build pktgen
RUN git clone https://github.com/pktgen/Pktgen-DPDK.git

WORKDIR /root/Pktgen-DPDK 
# Declare the build arguments Need to redeclare
ARG PKTGEN_VERSION
RUN echo "Building pktgen version pktgen-${PKTGEN_VERSION}" && \
    git checkout pktgen-${PKTGEN_VERSION} && \
    meson build && \
    cd build && \
    ninja && \
    ninja install

# Optional: ensure the correct working directory at the end
WORKDIR /root/

