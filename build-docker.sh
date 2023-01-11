#!/bin/bash
declare -a all_containers;

function cleanup(){
    for c_id in "${all_containers}"; do
        echo "Stop container: $c_id"
        docker stop $c_id;
    done;
    exit;
}

trap cleanup SIGINT;


required_files=(
    "https://raw.githubusercontent.com/Crozzers/pocketsphinx-python-wheels/master/build-manylinux-wheel.sh"
    "https://github.com/cmusphinx/pocketsphinx/archive/refs/tags/v5.0.0.zip"
);
mkdir -p required-files
for file in "${required_files[@]}"; do
    if [ ! -f "required-files/$(basename $file)" ];
    then
        if [ -f "./$(basename $file)" ];
        then
            cp "./$(basename $file)" required-files/
        else
            wget $file -O "required-files/$(basename $file)";
        fi
    fi
done;

arches=("x86_64" "aarch64" "i686" "ppc64le" "s390x");
platforms=("amd64" "arm64" "386" "ppc64le" "s390x")
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
for index in ${!arches[*]}; do
    arch=${arches[$index]};
    platform=${platforms[$index]};
    # pull the image
    image="quay.io/pypa/manylinux2014_$arch"
    docker pull $image;
    # create the container and grab the ID
    container_id=`docker run --rm -it -d --platform linux/$platform $image bash`;
    all_containers+=($container_id);
    # place all required files in the container
    for file in `ls required-files`; do
        docker cp required-files/$file $container_id:/$file;
    done;
    # build wheels
    docker exec $container_id bash -c "bash build-manylinux-wheel.sh";
    # extract build wheels from docker container
    mkdir -p wheels;
    for wheel in `docker exec $container_id bash -c "ls /pocketsphinx-build/wheelhouse"`; do
        docker cp $container_id:/pocketsphinx-build/wheelhouse/$wheel wheels/;
    done;
    # stop and remove the container
    docker stop $container_id;
done;