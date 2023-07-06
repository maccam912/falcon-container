FROM ubuntu

WORKDIR /root
RUN apt-get update && apt-get build-dep -y libatlas-base-dev && apt-get source libatlas-base-dev

WORKDIR /root/atlas-3.10.3
RUN mkdir build && cd build && ../configure && make -j 24 && make install