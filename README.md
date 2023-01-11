# pocketsphinx-python-wheels
A collection of pre-built wheels for PocketSphinx.

All of the `pocketsphinx-0.1.15...` wheels are built from the [bambocher fork](https://github.com/bambocher/pocketsphinx-python),
which is now out of date. There is a [currently active fork](https://github.com/cmusphinx/pocketsphinx) but they have released a
limited number of wheels and only for the x86 architecture. I have compiled as many wheels from the active fork as I can.


### Why is this here?
When installing PocketSphinx it will often fail (using PIP) as the latest wheels provided are for Python 3.6 and to build the source code you need SWIG and GIT (and you need them on your PATH).  
So these pre-built wheels serve as a way to install PocketSphinx on newer versions of Python without having to build it yourself. After these are installed, pip can upgrade you to the latest version.

### Contents

#### Pocketsphinx 5.0.0 (active fork)

| Python Version | aarch64       | i686          | ppc64le       | s390x         | x86_64        |
|----------------|---------------|---------------|---------------|---------------|---------------|
| 3.6            | Yes           | Yes           | Yes           | No            | *Official*    |
| 3.7            | Yes           | Yes           | Yes           | No            | Yes           |
| PyPy 3.7       | Yes           | Yes           | No            | No            | Yes           |
| 3.8            | Yes           | Yes           | Yes           | No            | *Official*    |
| PyPy 3.8       | Yes           | Yes           | No            | No            | *Official*    |
| 3.9            | Yes           | Yes           | Yes           | No            | Yes           |
| PyPy 3.9       | Yes           | Yes           | No            | No            | Yes           |
| 3.10           | Yes           | Yes           | Yes           | No            | *Official*    |
| 3.11           | Yes           | Yes           | Yes           | No            | Yes           |

The coverage here is a bit patchy. Any version labelled "*Official*" can be found on the pocketsphinx [PyPI releases page](https://pypi.org/project/pocketsphinx/#files)
and so are not covered by this repo

#### Pocketsphinx 0.1.15 (bambocher fork)

| Python Version | aarch64       | i686          | ppc64le       | s390x         | x86_64        |
|----------------|---------------|---------------|---------------|---------------|---------------|
| 3.6            | Yes           | Yes           | Yes           | Yes           | Yes           |
| 3.7            | Yes           | Yes           | Yes           | Yes           | Yes           |
| PyPy 3.7       | Yes           | Yes           | No            | No            | Yes           |
| 3.8            | Yes           | Yes           | Yes           | Yes           | Yes           |
| PyPy 3.8       | Yes           | Yes           | No            | No            | Yes           |
| 3.9            | Yes           | Yes           | Yes           | Yes           | Yes           |
| PyPy 3.9       | Yes           | Yes           | No            | No            | Yes           |
| 3.10           | Yes           | Yes           | Yes           | Yes           | Yes           |
| 3.11           | Yes           | Yes           | Yes           | Yes           | Yes           |


### How to install
Download the .whl file corresponding to your OS and python version. They are usually named as such:  

    pocketsphinx-0.1.15-[python version]-[python version]-[OS]-[CPU Architecture].whl  


So the wheel for Python 3.8 on Windows 64 bit would be called `pocketsphinx-0.1.15-cp38-cp38-win_amd64.whl`  
Next run `pip3 install path/to/the/whl/file/file.whl`  
Run `pip3 install --upgrade pocketsphinx` to ensure you are on the latest version  
Profit!


### How to build manylinux wheels
Download docker and run the [pypa manylinux docker containers](https://github.com/pypa/manylinux#docker-images) for each arch you wish
to build for. Once inside the container, run this command:  
```
apt update && apt install wget -y && wget https://github.com/Crozzers/pocketsphinx-python-wheels/raw/master/build-manylinux-wheel.sh && bash build-manylinux-wheel.sh
```
If you are using a CentOS based container then swap `apt` for `yum`.
This will download the [build-manylinux-wheel.sh](https://github.com/Crozzers/pocketsphinx-python-wheels/raw/master/build-manylinux-wheel.sh)
script from this repo and run it. It should download all the required tools to build the wheels and automatically build wheels for every python version installed
on that container.

Alternatively, if you have docker installed and running, you can simply run the `build-docker.sh` script
to automatically build wheels for all manylinux_2_24 arches.
```
mkdir build && cd build
curl https://raw.githubusercontent.com/Crozzers/pocketsphinx-python-wheels/master/build-docker.sh > build-docker.sh
sudo bash build-docker.sh
```
You may need to run the following command to enable running different architectures from an x86 host (eg: aarch64)
```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```
See [multiarch/qemu-user-static for details](https://github.com/multiarch/qemu-user-static)
