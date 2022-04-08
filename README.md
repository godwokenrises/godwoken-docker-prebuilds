godwoken-docker-prebuilds
=========================

Docker image containing all binaries used by godwoken, saving you the hassles of building them yourself.

How to build:

```bash
$ git clone --recursive https://github.com/xxuejie/godwoken-docker-prebuilds
$ cd godwoken-docker-prebuilds
$ cd godwoken-polyjuice && make all-via-docker && cd ..
$ cd godwoken-scripts && cd c && make && cd .. && capsule build --release --debug-output && cd ..
$ cd clerkb && yarn && make all-via-docker && cd ..
$ docker build . -t godwoken-prebuilds
```

How to upgrade:

```bash
$ # make sure it pass test..
$ make test
$ # build and push to docker-hub, will ask you to enter image tag
$ make build-push
```

# Usage

`godwoken` binary resides in `/bin/godwoken`, this is already in PATH so you can do this:

```bash
$ docker run --rm godwoken-prebuilds godwoken --version
```

`gw-tools` can be used in the same way:

```bash
$ docker run --rm godwoken-prebuilds gw-tools --version
```

CKB, ckb-cli, and ckb-indexer are also available this way:

```bash
$ docker run --rm godwoken-prebuilds ckb --version
$ docker run --rm godwoken-prebuilds ckb-cli --version
$ docker run --rm godwoken-prebuilds ckb-indexer --version
```

All the scripts used by godwoken can be found at `/scripts` folder:

```bash
$ docker run --rm godwoken-prebuilds find /scripts
/scripts
/scripts/godwoken-scripts
/scripts/godwoken-scripts/eth-account-lock
/scripts/godwoken-scripts/.keep
/scripts/godwoken-scripts/sudt-validator
/scripts/godwoken-scripts/meta-contract-validator
/scripts/godwoken-scripts/meta-contract-generator
/scripts/godwoken-scripts/sudt-generator
/scripts/godwoken-scripts/withdrawal-lock
/scripts/godwoken-scripts/stake-lock
/scripts/godwoken-scripts/state-validator
/scripts/godwoken-scripts/challenge-lock
/scripts/godwoken-scripts/always-success
/scripts/godwoken-scripts/custodian-lock
/scripts/godwoken-scripts/deposit-lock
/scripts/godwoken-polyjuice
/scripts/godwoken-polyjuice/validator_log.debug
/scripts/godwoken-polyjuice/validator
/scripts/godwoken-polyjuice/validator.debug
/scripts/godwoken-polyjuice/validator_log
/scripts/godwoken-polyjuice/generator.debug
/scripts/godwoken-polyjuice/generator_log
/scripts/godwoken-polyjuice/generator_log.debug
/scripts/godwoken-polyjuice/generator
/scripts/clerkb
/scripts/clerkb/state
/scripts/clerkb/poa
```
