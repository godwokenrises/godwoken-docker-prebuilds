# Historical versions refer to checksum.txt
# https://github.com/godwokenrises/godwoken-docker-prebuilds/pkgs/container/godwoken-prebuilds/46466026?tag=1.6.2-rc2
FROM ghcr.io/godwokenrises/godwoken-prebuilds:1.6.2-rc2 as historical-versions

################################################################################

FROM ubuntu:focal
LABEL description="Docker image containing all binaries used by Godwoken, saving you the hassles of building them yourself."
LABEL maintainer="Nervos Core Dev <dev@nervos.org>"

RUN mkdir -p /scripts/godwoken-scripts \
 && mkdir -p /scripts/godwoken-polyjuice \
 && mkdir /ckb 

RUN apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install -y curl jq \
 && apt-get clean \
 && echo 'Finished installing OS updates'

# ckb
# TODO: update to https://github.com/nervosnetwork/ckb/releases/tag/v0.104.0
# https://github.com/nervosnetwork/ckb/releases/download/v0.104.0/ckb_v0.104.0_x86_64-unknown-linux-gnu.tar.gz
RUN cd /ckb \
 && curl -LO https://github.com/nervosnetwork/ckb/releases/download/v0.103.0/ckb_v0.103.0_x86_64-unknown-linux-gnu.tar.gz \
 && tar xzf ckb_v0.103.0_x86_64-unknown-linux-gnu.tar.gz \
 && cp ckb_v0.103.0_x86_64-unknown-linux-gnu/ckb /bin/ckb \
 && cp ckb_v0.103.0_x86_64-unknown-linux-gnu/ckb-cli /bin/ckb-cli \
 && rm -rf /ckb

# Copy Historical versions
COPY --from=historical-versions /scripts/godwoken-polyjuice-* /scripts/
COPY checksum.txt /scripts/

#################################### latest ####################################
# /scripts/omni-lock
COPY build/ckb-production-scripts/build/omni_lock /scripts/godwoken-scripts/

# /scripts/godwoken-scripts
COPY build/godwoken-scripts/build/release/* /scripts/godwoken-scripts/
COPY build/godwoken-scripts/c/build/*-generator /scripts/godwoken-scripts/
COPY build/godwoken-scripts/c/build/*-validator /scripts/godwoken-scripts/
COPY build/godwoken-scripts/c/build/account_locks/* /scripts/godwoken-scripts/

# /scripts/godwoken-polyjuice
COPY build/godwoken-polyjuice/build/*generator* /scripts/godwoken-polyjuice/
COPY build/godwoken-polyjuice/build/*validator* /scripts/godwoken-polyjuice/
################################################################################


# godwoken
COPY build/godwoken/target/release/godwoken /bin/godwoken
COPY build/godwoken/target/release/gw-tools /bin/gw-tools
COPY gw-healthcheck.sh /bin/gw-healthcheck.sh

CMD [ "godwoken", "--version" ]
