FROM ubuntu:latest

ARG uid=1000
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
ENV PATH=/home/devuser/.cargo/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && \
    apt-get install -y nodejs locales npm build-essential cmake curl git clang gdb llvm && \
    locale-gen en_US.UTF-8 && \
    adduser --quiet --disabled-password --home /home/devuser --uid $uid --gecos "User" devuser && \
    echo "devuser:p@ssword1" | chpasswd &&  usermod -aG sudo devuser


# install rust +wasm as devuser
RUN su devuser &&  \ 
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | HOME=/home/devuser sh -s - -y &&\
    HOME=/home/devuser rustup target add wasm32-unknown-unknown

RUN apt-get update && \
    apt-get install -y openssl libssl-dev libssl1.1 pkg-config

RUN su devuser &&  \ 
    HOME=/home/devuser cargo install cargo-generate

RUN su devuser &&  \ 
    HOME=/home/devuser cargo install wasm-bindgen-cli
RUN su devuser &&  \ 
    HOME=/home/devuser cargo install wasm-pack

#install wabt
RUN su devuser \
    && cd /home/devuser \
    && git clone --recursive https://github.com/WebAssembly/wabt \
    && cd wabt && make
RUN cd /home/devuser/wabt && make install

#install binaryen
RUN su devuser \
    && cd /home/devuser \
    && git clone https://github.com/WebAssembly/binaryen.git \
    && cd binaryen \
    && cmake . && make
RUN cd /home/devuser/binaryen && make install

RUN su devuser \
    && mkdir -p /home/devuser/w
 
WORKDIR /home/devuser/w

USER devuser

CMD ["bash"]
