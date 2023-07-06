FROM ubuntu

RUN sed -n 's/^deb /deb-src /p' /etc/apt/sources.list > /etc/apt/sources.list.d/sources.list && cat /etc/apt/sources.list.d/sources.list >> /etc/apt/sources.list
WORKDIR /root
RUN apt-get update && apt-get build-dep -y libatlas-base-dev && apt-get source libatlas-base-dev

WORKDIR /root/atlas-3.10.3
RUN mkdir build && cd build && ../configure --cripple-atlas-performance && make -j 24 && make install