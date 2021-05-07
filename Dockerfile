FROM rust:1 as builder
MAINTAINER Xuejie Xiao <x@nervos.org>

RUN apt-get update
RUN apt-get -y install --no-install-recommends llvm-dev clang libclang-dev libssl-dev

RUN cargo install moleculec --version 0.6.1
COPY ./godwoken /godwoken
RUN cd /godwoken && cargo build --release

FROM node:14
MAINTAINER Xuejie Xiao <x@nervos.org>

COPY --from=builder /godwoken/target/release/godwoken /bin/godwoken
COPY --from=builder /godwoken/target/release/gw-tools /bin/gw-tools

RUN npm install --global yarn
WORKDIR /godwoken-web3
COPY package.json ./
COPY yarn.lock ./
RUN yarn
COPY . .

EXPOSE 3000

CMD [ "godwoken", "--version" ]
