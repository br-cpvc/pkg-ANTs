FROM ubuntu:22.04
#RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y make fakeroot wget zlib1g-dev g++ git

COPY cmake-3.25.1-linux-x86_64.tar.gz /cmake.tar.gz

RUN tar xzf /cmake.tar.gz --directory=/usr/ --strip-components=1
