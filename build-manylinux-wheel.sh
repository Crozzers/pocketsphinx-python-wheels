#!/bin/bash
#
# Script designed to build Pocketsphinx wheels.
# This should be run inside a [manylinux docker container](https://github.com/pypa/manylinux#docker-images),
# preferably on manylinux2014 (CentOS 7) or later
#


# update package lists and install required build tools
base_packages="wget swig make pulseaudio tk"
if [ $(command -v apt --version) ];
then
	apt update && apt install libasound2-dev libpulse-dev python3-dev $base_packages -y
elif [ $(command -v yum --version) ];
then
	yum update -y && yum install epel-release -y && yum install portaudio-devel pulseaudio-libs-devel python3-devel $base_packages -y
fi

# make build directory
mkdir pocketsphinx-build -p && cd pocketsphinx-build

# download and extract pocketsphinx
if [ ! -f "v5.0.0.zip" ];
then
	if [ -f "../v5.0.0.zip" ];
	then
		mv "../v5.0.0.zip" ./
	else
		wget https://github.com/cmusphinx/pocketsphinx/archive/refs/tags/v5.0.0.zip
	fi
fi
unzip -o v5.0.0.zip

# copy to seperate build dirs to allow for building in parallel
# otherwise auditwheel freaks out
for py_version in /opt/python/*
do
	$py_version/bin/python -m pip install -r pocketsphinx-5.0.0/requirements.dev.txt
	mkdir -p $(basename $py_version)
	cp -r pocketsphinx-5.0.0/* $(basename $py_version)/
done

# build wheels for each python version in parallel and then wait for each process to complete
for py_version in /opt/python/*
do
	build_dir=$(basename $py_version)
	(cd $build_dir && $py_version/bin/python -m pip wheel . -v && cd ..) &
done
wait

# run auditwheel across all build wheels
for py_version in /opt/python/*
do
	for file in $(basename $py_version)/*.whl
	do
		# auditwheel comes pre-installed on manylinux dockers
		auditwheel repair $file
	done
done

echo -e "\n\nFinished wheels in pocketsphinx-build/wheelhouse"
