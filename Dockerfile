# Historical versions
# https://github.com/nervosnetwork/godwoken-docker-prebuilds/pkgs/container/godwoken-prebuilds/41603509?tag=1.6.0
# > "ref.component.godwoken-polyjuice": "1.4.0  5626a05"
FROM ghcr.io/nervosnetwork/godwoken-prebuilds:1.6.1 as polyjuice-v1.4.1

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

############################ polyjuice-v1.1.5-beta #############################
# Godwoken testnet_v1 blocks[0..110000) use polyjuice-v1.1.5-beta
# https://github.com/nervosnetwork/godwoken-polyjuice/releases/tag/v1.1.5-beta
COPY --from=polyjuice-v1.4.1 /scripts/godwoken-polyjuice-v1.1.5-beta \
                             /scripts/godwoken-polyjuice-v1.1.5-beta


############################## polyjuice-v1.2.0 ################################
# Godwoken testnet_v1 blocks[110000..180000) use godwoken-polyjuice-v1.2.0
# https://github.com/nervosnetwork/godwoken-polyjuice/releases/tag/1.2.0
COPY --from=polyjuice-v1.4.1 /scripts/godwoken-polyjuice-v1.2.0 \
                             /scripts/godwoken-polyjuice-v1.2.0


############################## polyjuice-v1.3.0 ################################
# Godwoken testnet_v1 blocks[180000..] use godwoken-polyjuice-v1.3.0
# https://github.com/nervosnetwork/godwoken-polyjuice/releases/tag/1.3.0
RUN mkdir -p /scripts/godwoken-polyjuice-v1.3.0
COPY --from=polyjuice-v1.4.1 /scripts/godwoken-polyjuice/* \
                             /scripts/godwoken-polyjuice-v1.3.0/


############################## polyjuice-v1.4.0 ################################
# https://github.com/nervosnetwork/godwoken-polyjuice/releases/tag/1.4.0
RUN mkdir -p /scripts/godwoken-polyjuice-v1.4.0
COPY --from=polyjuice-v1.4.1 /scripts/godwoken-polyjuice/* \
                             /scripts/godwoken-polyjuice-v1.4.0/

############################## polyjuice-v1.4.1 ################################
RUN mkdir -p /scripts/godwoken-polyjuice-v1.4.1
# https://github.com/nervosnetwork/godwoken-polyjuice/releases/tag/1.4.1
COPY --from=polyjuice-v1.4.1 /scripts/godwoken-polyjuice/* \
                             /scripts/godwoken-polyjuice-v1.4.1/

############################## polyjuice-v1.4.2 ################################
# The latest version of Polyjuice is 1.4.2


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
