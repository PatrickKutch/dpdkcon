#!/bin/bash

###################################################################
#Script Name	:  build_pkggen.sh                                                                                            
#Description	: builds containerized DPDK-pktgen
#Author       	: Patrick Kutch                                                  
#Email         	: Patrick.G.Kutch@Intel.com                                           
###################################################################

# which DPDK version to use as the 'base' - requires that version be up on  $DOCKER_REPO/dpdk:$DPDK_VERSION
DPDK_VERSION="24.07"
PKTGEN_VERSION="24.07.1"
DOCKER_REPO="patrickkutch"
DPDK_IMAGE_NAME="dpdk"
IMAGE_NAME="dpdk-pktgen"

#pick up proxy settings
# I use no-cache to make sure I pick up latest repo
VER_INFO="--build-arg DOCKER_REPO=$DOCKER_REPO --build-arg DPDK_IMAGE_NAME=$DPDK_IMAGE_NAME --build-arg DPDK_VERSION=$DPDK_VERSION --build-arg PKTGEN_VERSION=$PKTGEN_VERSION"
Params="--no-cache --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$http_proxy $VER_INFO --network=host"

echo "Params: $Params"

buildIt() {
    echo "Running Docker build..."
    echo "docker build $Params --rm -t $DOCKER_REPO/$IMAGE_NAME:v$PKTGEN_VERSION ."
    docker build $Params --rm -t $DOCKER_REPO/$IMAGE_NAME:v$PKTGEN_VERSION .
}

pushIt() {
    echo "Pushing Docker image to repository..."
    docker push $DOCKER_REPO/$IMAGE_NAME:v$PKTGEN_VERSION
}

buildIt
pushIt
