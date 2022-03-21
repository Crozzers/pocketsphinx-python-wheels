#!/bin/bash
#
# Script designed to build Pocketsphinx wheels.
# This should be run inside a [manylinux docker container](https://github.com/pypa/manylinux#docker-images),
# preferably on manylinux2014 (CentOS 7) or later
#


# update package lists and install required build tools
base_packages="swig autoconf automake make pulseaudio tk"
if [ $(command -v apt --version) ];
then
	apt update && apt install libasound2-dev libpulse-dev python3-dev $base_packages -y
elif [ $(command -v yum --version) ];
then
	yum update -y && yum install portaudio-devel pulseaudio-libs-devel python3-devel $base_packages -y
fi

# make build directory
mkdir pocketsphinx-build -p && cd pocketsphinx-build

# install required building wheels on all python versions and find latest python version
latest_py_version=0
for py_version in /opt/python/*
do
	$py_version/bin/python -m pip install wheel
	# get version number and check if its bigger than current latest version
	version_num=$(basename $py_version | grep -o '[0-9]*' | head -n 1)
	if [[ latest_py_version -le $version_num ]];
	then
		latest_py_version=$version_num
	fi
done

# check that we have a suitable version
if [ $latest_py_version = 0 ];
then
	echo "No suitable python versions found"
	exit 1
elif [ $latest_py_version -le 36 ];
then
	echo "Earliest suported python is cp36, not cp$latest_py_version"
	exit 1
fi

latest_py_dir="/opt/python/cp${latest_py_version}-cp${latest_py_version}"
if [ ! -d $latest_py_dir ];
then
	# eg: /opt/python/cp36-cp36m
	latest_py_dir="${latest_py_dir}m"
fi

# download and extract pocketsphinx
if [ ! -f "pocketsphinx-0.1.15.tar.gz" ];
then
	if [ -f "../pocketsphinx-0.1.15.tar.gz" ];
	then
		mv ../pocketsphinx-0.1.15.tar.gz ./
	else
		curl https://files.pythonhosted.org/packages/cd/4a/adea55f189a81aed88efa0b0e1d25628e5ed22622ab9174bf696dd4f9474/pocketsphinx-0.1.15.tar.gz > pocketsphinx-0.1.15.tar.gz
	fi	
fi
tar -xvf pocketsphinx-0.1.15.tar.gz

# copy to seperate build dirs to allow for building in parallel
# otherwise auditwheel freaks out
for py_version in /opt/python/*
do
	mkdir -p $(basename $py_version)
	cp -r pocketsphinx-0.1.15/* $(basename $py_version)/
done
rm -r pocketsphinx-0.1.15

# build wheels for each python version in parallel and then wait for each process to complete
for py_version in /opt/python/*
do
	build_dir=$(basename $py_version)
	(cd $build_dir && $py_version/bin/python setup.py bdist_wheel && cd ..) &
done
wait

# run auditwheel across all build wheels
for py_version in /opt/python/*
do
	for file in $(basename $py_version)/dist/*
	do
		# auditwheel comes pre-installed on manylinux dockers
		auditwheel repair $file
	done
done

echo -e "\n\nFinished wheels in pocketsphinx-build/wheelhouse"
