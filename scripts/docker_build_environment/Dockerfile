FROM ubuntu:12.04
RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y g++ make git fakeroot wget zlib1g-dev

# add 386 executable support, from:
# https://askubuntu.com/questions/454253/how-to-run-32-bit-app-in-ubuntu-64-bit
#RUN apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386
#RUN apt-get install -y multiarch-support
# RUN get https://github.com/Kitware/CMake/releases/download/v2.8.12.2/cmake-2.8.12.2-Linux-i386.tar.gz
#COPY cmake-2.8.12.2-Linux-i386.tar.gz /cmake.tar.gz

#RUN wget https://github.com/Kitware/CMake/releases/download/v3.25.1/cmake-3.25.1-linux-x86_64.tar.gz
COPY cmake-3.25.1-linux-x86_64.tar.gz /cmake.tar.gz

RUN tar xzf /cmake.tar.gz --directory=/usr/ --strip-components=1
