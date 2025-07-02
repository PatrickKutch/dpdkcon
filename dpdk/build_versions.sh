#!/bin/bash

###################################################################
#Script Name	:  build_versions.sh                                                                                            
#Description	: builds containerized DPDK, with tags for different versions
#               : default container name will be dpdk, if you have ptp as either 1st or 2nd
#               : parameter then it will be dpdk-ptp.                                                                               
#Args           : [p] - build all versions in parallel [ptp] - build with ptp enabled                                                                                          
#Author       	: Patrick Kutch                                                
#Email         	: Patrick.G.Kutch@Intel.com                                           
###################################################################

#build a bunch of them
DPDK_VERSIONS=("19.11" "20.02" "20.05" "20.08" "20.11" "21.02" "21.05" "21.11" "22.03")
#if you only want to build a single image, then uncomment and do something like the following line
DPDK_VERSIONS=("24.11") 
#my repo, select your own
DOCKER_REPO="patrickkutch"
IMAGE_NAME="dpdk"

if [ "$1" = "ptp" ] || [ "$2" = "ptp" ]; then
    COMPILE_WITH_PTP="1"
else
    COMPILE_WITH_PTP="0"
fi

if [ "$COMPILE_WITH_PTP" = "1" ]; then
    IMAGE_NAME="dpdk-ptp"    
fi    

#pick up proxy settings
# I use no-cache to make sure I pick up latest repo
# probably a more efficient way of doing this, but this works for now
#export Params="--no-cache --build-arg CONFIG_RTE_LIBRTE_IEEE1588=$COMPILE_WITH_PTP --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$http_proxy --network=host"
export Params="--no-cache --build-arg CONFIG_RTE_LIBRTE_IEEE1588=$COMPILE_WITH_PTP --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$http_proxy --network=host"

buildIt() {
    # make sure the local version of the base image is built first
    # I have the base version to speed up subsequent builds
    docker build -f Dockerfile.base -t dpdk-base:ubuntu-24.04 .
    echo docker build -f Dockerfile.dpdk $Params --build-arg DPDK_VER=$dpdkVer --rm -t $DOCKER_REPO/$IMAGE_NAME:v$dpdkVer .
    docker build -f Dockerfile.dpdk $Params --build-arg DPDK_VER=$dpdkVer --rm -t $DOCKER_REPO/$IMAGE_NAME:v$dpdkVer .
}
 
pushIt() {
    echo "Pushing $DOCKER_REPO/$IMAGE_NAME:v$dpdkVer"
    docker push $DOCKER_REPO/$IMAGE_NAME:v$dpdkVer
}

printVersions() {
    for dpdkVer in "${DPDK_VERSIONS[@]}"
    do
        echo $dpdkVer 
    done
}

if [ "$1" == "p" ] || [ "$2" == "p" ]; then
    echo "Performing Parallel builds for"
    printVersions    
    doParallel='Y'
else
    echo "Performing Serial builds for"
    printVersions    
    doParallel='N'
fi    

for dpdkVer in "${DPDK_VERSIONS[@]}"
do
    if [ "$doParallel" == "Y" ]; then # puild in parallel
        nohup docker build $Params --build-arg DPDK_VER=$dpdkVer --rm -t $DOCKER_REPO/$IMAGE_NAME:v$dpdkVer . && docker push $DOCKER_REPO/$IMAGE_NAME:v$dpdkVer & 
        echo "Spawning process to build and push $DOCKER_REPO/IMAGE_NAME:v$dpdkVer"
    else
        buildIt
        pushIt
    fi
done
