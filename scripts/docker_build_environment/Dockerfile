FROM ubuntu:12.04
RUN sed -i 's/archive.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y g++ cmake make git fakeroot wget
