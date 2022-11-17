FROM ubuntu:22.04
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y g++ make git fakeroot wget zlib1g-dev

# from: https://apt.kitware.com/
#RUN apt-get install -y gpg
#RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - > /usr/share/keyrings/kitware-archive-keyring.gpg
#RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ bionic main' > /etc/apt/sources.list.d/kitware.list
#RUN apt-get update

RUN apt-get install -y cmake
