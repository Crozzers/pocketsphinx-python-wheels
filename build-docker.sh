declare -a all_containers;

function cleanup(){
    for c_id in "${all_containers}"; do
        docker stop $c_id;
    done;
    exit;
}

trap cleanup SIGINT;

required_files=("pocketsphinx-0.1.15.tar.gz" "build-manylinux-wheel.sh");
for file in "${required_files[@]}"; do
    if [ ! -f  ];
    then
        curl https://raw.githubusercontent.com/Crozzers/pocketsphinx-python-wheels/master/$file > $file;
    fi
done;

arches=("x86_64" "aarch64" "i686" "ppc64le" "s390x");
for arch in "${arches[@]}"; do
    # pull the image
    image="quay.io/pypa/manylinux_2_24_$arch"
    docker pull $image;
    # create the container and grab the ID
    container_id=`docker run --rm -it -d $image bash`;
    all_containers+=($container_id);
    # place all required files in the container
    for file in "${required_files[@]}"; do
        docker cp $file $container_id:/$file;
    done;
    # build wheels
    docker exec $container_id bash -c "bash build-manylinux-wheel.sh";
    # extract build wheels from docker container
    mkdir -p $arch;
    for wheel in `docker exec $container_id bash -c "ls /pocketsphinx-build/wheelhouse"`; do
        docker cp $container_id:/pocketsphinx-build/wheelhouse/$wheel $arch/;
    done;
    # stop and remove the container
    docker stop $container_id;
done;