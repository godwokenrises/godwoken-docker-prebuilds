FROM rust:1 as builder
MAINTAINER Xuejie Xiao <x@nervos.org>

RUN apt-get update
RUN apt-get -y install --no-install-recommends llvm-dev clang libclang-dev libssl-dev

RUN cargo install moleculec --version 0.7.2

COPY ./build/godwoken /godwoken
RUN cd /godwoken && rustup component add rustfmt && cargo build --release

RUN mkdir /ckb
RUN cd /ckb && curl -LO https://github.com/nervosnetwork/ckb/releases/download/v0.100.0/ckb_v0.100.0_x86_64-unknown-linux-gnu.tar.gz
RUN cd /ckb && tar xzf ckb_v0.100.0_x86_64-unknown-linux-gnu.tar.gz

RUN mkdir /ckb-indexer
RUN cd /ckb-indexer && curl -LO https://github.com/nervosnetwork/ckb-indexer/releases/download/v0.3.0/ckb-indexer-0.3.0-linux.zip
RUN cd /ckb-indexer && unzip ckb-indexer-0.3.0-linux.zip && tar xzf ckb-indexer-linux-x86_64.tar.gz

FROM ubuntu:21.04
MAINTAINER Xuejie Xiao <x@nervos.org>

RUN mkdir -p /scripts/godwoken-scripts \
 && mkdir -p /scripts/godwoken-polyjuice \
 && mkdir -p /scripts/clerkb

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y curl \
 && apt-get clean \
 && echo 'Finished installing OS updates'

# ckb
COPY --from=builder /ckb/ckb_v0.100.0_x86_64-unknown-linux-gnu/ckb /bin/ckb
COPY --from=builder /ckb/ckb_v0.100.0_x86_64-unknown-linux-gnu/ckb-cli /bin/ckb-cli
COPY --from=builder /ckb-indexer/ckb-indexer /bin/ckb-indexer

# godwoken
COPY --from=builder /godwoken/target/release/godwoken /bin/godwoken
COPY --from=builder /godwoken/target/release/gw-tools /bin/gw-tools

# /scripts/godwoken-scripts
COPY build/godwoken-scripts/build/release/* /scripts/godwoken-scripts/
COPY build/godwoken-scripts/c/build/*-generator /scripts/godwoken-scripts/
COPY build/godwoken-scripts/c/build/*-validator /scripts/godwoken-scripts/
COPY build/godwoken-scripts/c/build/account_locks/* /scripts/godwoken-scripts/

# /scripts/godwoken-polyjuice
COPY build/godwoken-polyjuice/build/generator* /scripts/godwoken-polyjuice/
COPY build/godwoken-polyjuice/build/validator* /scripts/godwoken-polyjuice/

# /scripts/clerkb
COPY build/clerkb/build/debug/poa /scripts/clerkb/
COPY build/clerkb/build/debug/state /scripts/clerkb/

CMD [ "godwoken", "--version" ]
