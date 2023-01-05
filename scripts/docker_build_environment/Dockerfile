FROM ubuntu:12.04
RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y make fakeroot wget zlib1g-dev

# https://wiki.ubuntu.com/ToolChain
# https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test

# https://rbgeek.wordpress.com/2012/11/18/sudo-add-apt-repository-command-not-found-on-ubuntu-12-04/
RUN apt-get install python-software-properties -y
# https://gist.github.com/application2000/73fd6f4bf1be6600a2cf9f56315a2d91
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get update
RUN apt-get install -y g++-5

# get newer git version, should be higher than 1.7.10 for the ITKDownloadSetup.cmake
# script to be able to use https to download the needed modules.
# https://unix.stackexchange.com/questions/33617/how-can-i-update-to-a-newer-version-of-git-using-apt-get
# https://launchpad.net/~git-core/+archive/ubuntu/ppa
RUN add-apt-repository ppa:git-core/ppa -y
RUN apt-get update
RUN apt-get install git -y

# add 386 executable support, from:
# https://askubuntu.com/questions/454253/how-to-run-32-bit-app-in-ubuntu-64-bit
#RUN apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386
#RUN apt-get install -y multiarch-support
# RUN get https://github.com/Kitware/CMake/releases/download/v2.8.12.2/cmake-2.8.12.2-Linux-i386.tar.gz
#COPY cmake-2.8.12.2-Linux-i386.tar.gz /cmake.tar.gz

#RUN wget https://github.com/Kitware/CMake/releases/download/v3.25.1/cmake-3.25.1-linux-x86_64.tar.gz
COPY cmake-3.25.1-linux-x86_64.tar.gz /cmake.tar.gz

RUN tar xzf /cmake.tar.gz --directory=/usr/ --strip-components=1
