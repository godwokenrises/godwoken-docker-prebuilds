FROM rust:1 as builder
MAINTAINER Xuejie Xiao <x@nervos.org>

RUN apt-get update
RUN apt-get -y install --no-install-recommends llvm-dev clang libclang-dev libssl-dev

RUN cargo install moleculec --version 0.6.1

COPY ./godwoken /godwoken
WORKDIR /godwoken

RUN rustup component add rustfmt
RUN cargo build --release

FROM node:14-buster
MAINTAINER Xuejie Xiao <x@nervos.org>

COPY --from=builder /godwoken/target/release/godwoken /bin/godwoken
COPY --from=builder /godwoken/target/release/gw-tools /bin/gw-tools

COPY godwoken-web3/package.json /godwoken-web3/package.json
COPY godwoken-web3/yarn.lock /godwoken-web3/yarn.lock
RUN cd /godwoken-web3 && yarn
COPY godwoken-web3/. /godwoken-web3/.

EXPOSE 3000

CMD [ "godwoken", "--version" ]
