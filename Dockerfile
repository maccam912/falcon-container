FROM ubuntu as build

WORKDIR /app
RUN apt-get update && apt-get install wget build-essential git ninja-build cmake pkg-config -y
RUN git clone https://github.com/cmp-nct/ggllm.cpp --recursive
WORKDIR /app/ggllm.cpp
RUN cmake -B build -G Ninja . && cmake --build build --config Release

FROM ubuntu as deploy
COPY --from=build /app/ggllm.cpp/build/bin/* /usr/local/bin/
CMD /usr/local/bin/falcon_main