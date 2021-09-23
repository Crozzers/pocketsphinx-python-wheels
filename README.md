# pocketsphinx-python-wheels
A collection of pre-built wheels for PocketSphinx 


### Why is this here?
When installing PocketSphinx it will often fail (using PIP) as the latest wheels provided are for Python 3.6 and to build the source code you need SWIG and GIT (and you need them on your PATH).  
So these pre-built wheels serve as a way to install PocketSphinx on newer versions of Python without having to build it yourself. After these are installed, pip can upgrade you to the latest version.

### Contents

#### aarch64

| Python Version | manylinux2014 | manylinux2_24 |
|----------------|---------------|---------------|
| 3.6            | Yes           | Yes           |
| 3.7            | Yes           | Yes           |
| 3.8            | Yes           | Yes           |
| 3.9            | Yes           | Yes           |
| 3.10.0b1       | Yes           | Yes           |

#### i686 (Linux)

| Python Version | manylinux2014 | manylinux2_24 |
|----------------|---------------|---------------|
| 3.6            | Yes           | Yes           |
| 3.7            | Yes           | Yes           |
| 3.8            | Yes           | Yes           |
| 3.9            | Yes           | Yes           |
| 3.10.0b1       | Yes           | Yes           |

#### x86_64 (Linux)

| Python Version | manylinux2014 | manylinux2_24 |
|----------------|---------------|---------------|
| 3.6            | Yes           | Yes           |
| 3.7            | Yes           | Yes           |
| 3.8            | Yes           | Yes           |
| 3.9            | Yes           | Yes           |
| 3.10.0b1       | Yes           | Yes           |


### How to install
Download the .whl file corresponding to your OS and python version. They are usually named as such:  

    pocketsphinx-0.1.15-cp3[python minor version]-cp3[python minor version]-[OS]-[CPU Architecture].whl  


So the wheel for Python 3.8 on Windows 64 bit would be called `pocketsphinx-0.1.15-cp38-cp38-win_amd64.whl`  
Next run `pip3 install path/to/the/whl/file/file.whl`  
Run `pip3 install --upgrade pocketsphinx` to ensure you are on the latest version  
Profit!


### How to build manylinux wheels
Download docker and run the [pypa manylinux docker containers](https://github.com/pypa/manylinux#docker-images) for each arch you wish
to build for. One inside the container download the [build-manylinux-wheel.sh](https://github.com/Crozzers/pocketsphinx-python-wheels/raw/master/build-manylinux-wheel.sh)
script from this repo and run it. It should download all the required tools to build the wheels and build wheels for every python version installed
on that container.
