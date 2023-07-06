FROM ubuntu

RUN sed -n 's/^deb /deb-src /p' /etc/apt/sources.list > tmpsrc && cat tmpsrc >> /etc/apt/sources.list
WORKDIR /root
RUN apt-get update && apt-get install wget build-essential -y && apt-get build-dep -y libatlas-base-dev && apt-get source libatlas-base-dev

WORKDIR /root/atlas-3.10.3
RUN mkdir build && cd build && ../configure --cripple-atlas-performance && make --debug && make install