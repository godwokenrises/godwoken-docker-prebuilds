FROM rust:1 as builder
MAINTAINER Xuejie Xiao <x@nervos.org>

RUN apt-get update
RUN apt-get -y install --no-install-recommends llvm-dev clang libclang-dev libssl-dev

RUN cargo install moleculec --version 0.6.1

COPY ./godwoken /godwoken
RUN cd /godwoken && rustup component add rustfmt && cargo build --release

FROM node:14-buster
MAINTAINER Xuejie Xiao <x@nervos.org>

COPY --from=builder /godwoken/target/release/godwoken /bin/godwoken
COPY --from=builder /godwoken/target/release/gw-tools /bin/gw-tools

RUN mkdir -p /scripts/godwoken-scripts
COPY godwoken-scripts/build/release/* /scripts/godwoken-scripts/
COPY godwoken-scripts/c/build/*-generator /scripts/godwoken-scripts/
COPY godwoken-scripts/c/build/*-validator /scripts/godwoken-scripts/
COPY godwoken-scripts/c/build/account_locks/* /scripts/godwoken-scripts/

RUN mkdir -p /scripts/godwoken-polyjuice
COPY godwoken-polyjuice/build/generator* /scripts/godwoken-polyjuice/
COPY godwoken-polyjuice/build/validator* /scripts/godwoken-polyjuice/

COPY godwoken-web3/package.json /godwoken-web3/package.json
COPY godwoken-web3/yarn.lock /godwoken-web3/yarn.lock
RUN cd /godwoken-web3 && yarn
COPY godwoken-web3/. /godwoken-web3/.

EXPOSE 3000

CMD [ "godwoken", "--version" ]
