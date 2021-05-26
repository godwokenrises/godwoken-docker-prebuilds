FROM rust:1 as builder
MAINTAINER Xuejie Xiao <x@nervos.org>

RUN apt-get update
RUN apt-get -y install --no-install-recommends llvm-dev clang libclang-dev libssl-dev

RUN cargo install moleculec --version 0.6.1

COPY ./godwoken /godwoken
RUN cd /godwoken && rustup component add rustfmt && cargo build --release

RUN mkdir /ckb
RUN cd /ckb && curl -LO https://github.com/nervosnetwork/ckb/releases/download/v0.41.0/ckb_v0.41.0_x86_64-unknown-linux-gnu.tar.gz
RUN cd /ckb && tar xzf ckb_v0.41.0_x86_64-unknown-linux-gnu.tar.gz

RUN mkdir /ckb-indexer
RUN cd /ckb-indexer && curl -LO https://github.com/nervosnetwork/ckb-indexer/releases/download/v0.2.0/ckb-indexer-0.2.0-linux.zip
RUN cd /ckb-indexer && unzip ckb-indexer-0.2.0-linux.zip && tar xzf ckb-indexer-linux-x86_64.tar.gz

FROM node:14-buster
MAINTAINER Xuejie Xiao <x@nervos.org>

COPY --from=builder /ckb/ckb_v0.41.0_x86_64-unknown-linux-gnu/ckb /bin/ckb
COPY --from=builder /ckb/ckb_v0.41.0_x86_64-unknown-linux-gnu/ckb-cli /bin/ckb-cli
COPY --from=builder /ckb-indexer/ckb-indexer /bin/ckb-indexer

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

RUN mkdir -p /scripts/clerkb
COPY clerkb/build/debug/poa /scripts/clerkb/
COPY clerkb/build/debug/state /scripts/clerkb/

COPY godwoken-web3/package.json /godwoken-web3/package.json
COPY godwoken-web3/yarn.lock /godwoken-web3/yarn.lock
RUN cd /godwoken-web3 && yarn
COPY godwoken-web3/. /godwoken-web3/.

EXPOSE 3000

CMD [ "godwoken", "--version" ]
