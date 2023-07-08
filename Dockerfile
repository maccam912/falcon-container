FROM ubuntu as build

WORKDIR /app
RUN apt-get update && apt-get install wget build-essential git ninja-build cmake pkg-config -y
RUN git clone https://github.com/cmp-nct/ggllm.cpp --recursive
WORKDIR /app/ggllm.cpp
RUN cmake -B build -G Ninja -DLLAMA_AVX2=OFF -DLLAMA_FMA=OFF -DLLAMA_CUBLAS=OFF . && cmake --build build --config Release

FROM ubuntu as deploy
WORKDIR /app
COPY --from=build /app/ggllm.cpp/build/bin/* /usr/local/bin/
COPY startup.sh .
RUN apt-get update && apt-get install wget python3 python3-pip -y
RUN pip install -U litestar uvicorn pydantic
COPY server.py .
CMD bash startup.sh