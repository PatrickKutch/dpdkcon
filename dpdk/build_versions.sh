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

DPDK_VERSIONS=("v19.11" "v20.02" "v20.05" "v20.08" "v20.11" "v21.02" "v21.05" "v21.11" "v22.03")
#if you only want to build a single image, then uncomment and do something like the following line
#DPDK_VERSIONS=("v22.03")
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
export Params="--no-cache --build-arg CONFIG_RTE_LIBRTE_IEEE1588=$COMPILE_WITH_PTP --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --build-arg HTTP_PROXY=$http_proxy --build-arg HTTPS_PROXY=$http_proxy --network=host"

buildIt() {
    #echo docker build $Params --build-arg DPDK_VER=$dpdkVer --rm -t $DOCKER_REPO/$IMAGE_NAME:$dpdkVer .
    docker build $Params --build-arg DPDK_VER=$dpdkVer --rm -t $DOCKER_REPO/$IMAGE_NAME:$dpdkVer .
}
 
pushIt() {
    docker push $DOCKER_REPO/$IMAGE_NAME:$dpdkVer
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
        nohup docker build $Params --build-arg DPDK_VER=$dpdkVer --rm -t $DOCKER_REPO/$IMAGE_NAME:$dpdkVer . && docker push $DOCKER_REPO/$IMAGE_NAME:$dpdkVer & 
        echo "Spawning process to build and push $DOCKER_REPO/IMAGE_NAME:$dpdkVer"
    else
        buildIt
        pushIt
    fi
done
