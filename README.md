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

#### armv7l

Has wheels for Python 3.7, 3.8 and 3.9. None of them are `manylinux` wheels.

#### i686 (Linux)

| Python Version | manylinux2014 | manylinux2_24 |
|----------------|---------------|---------------|
| 3.6            | Yes           | Yes           |
| 3.7            | Yes           | Yes           |
| 3.8            | Yes           | Yes           |
| 3.9            | Yes           | Yes           |
| 3.10.0b1       | Yes           | Yes           |

#### win_amd64

Has wheels for Python 3.6, 3.7, 3.8, 3.9 and 3.10.0b1.

#### win32

Has wheels for Python 3.6, 3.7, 3.8 and 3.9.

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

    pocketsphinx-[version number]-cp3[python minor version]-cp3[python minor version]-[OS]-[CPU Architecture].whl  


So the wheel for Python 3.8 on Windows 64 bit would be called:  


    pocketsphinx-0.1.15-cp38-cp38-win_amd64.whl
Next run `pip3 install path/to/the/whl/file/file.whl`  
Run `pip3 install --upgrade pocketsphinx` to ensure you are on the latest version  
Profit!


### Am I missing some wheels?
Yes. I am missing some wheels. I will add wheels as I go. However, [this website](https://www.lfd.uci.edu/~gohlke/pythonlibs/#pocketsphinx) has many Windows wheels, should you need them. 
