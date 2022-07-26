godwoken-docker-prebuilds
=========================

Docker image containing all binaries used by Godwoken, saving you the hassles of building them yourself.

How to build:

```bash
$ make build-components
$ docker build . -t godwoken-prebuilds
```

How to upgrade:

```bash
$ # make sure it pass test..
$ make test
$ # build and push to docker-hub, will ask you to enter image tag
$ make build-push
```

## Usage

`Godwoken` binary resides in `/bin/godwoken`, this is already in PATH so you can do this:

```bash
$ docker run --rm godwoken-prebuilds godwoken --version
```

`gw-tools` can be used in the same way:

```bash
$ docker run --rm godwoken-prebuilds gw-tools --version
```

CKB and ckb-cli are also available this way:

```bash
$ docker run --rm godwoken-prebuilds ckb --version
$ docker run --rm godwoken-prebuilds ckb-cli --version
```

## CPU Feature Requirement

Starting from version 1.3.0-rc3, the published images require [AVX2](https://en.wikipedia.org/wiki/Advanced_Vector_Extensions). Most recent x86-64 CPUs support AVX2. On linux, you can check for AVX2 support by inspecting `/proc/cpuinfo` or running `lscpu`.

If your CPU/environment does not support AVX2, you can build an image that does not require AVX2 by running the build steps above on the specific CPU/environment.

## Check the reference of every component
```bash
docker inspect godwoken-prebuilds:[TAG] | egrep ref.component
```

## Scripts

All the scripts used by Godwoken can be found at `/scripts` folder:

```bash
$ docker run --rm godwoken-prebuilds find /scripts -type f -exec sha1sum {} \;
dab522b3b5a7c6fd179915f9059dac92891756eb  /scripts/godwoken-scripts/omni_lock
da39a3ee5e6b4b0d3255bfef95601890afd80709  /scripts/godwoken-scripts/.keep
2f711f767372f08fcf774afd2c891ca7870de4d5  /scripts/godwoken-scripts/sudt-validator
575647193885e5e89966de64c18f3a4578eec6e2  /scripts/godwoken-scripts/meta-contract-validator
c06ebbbb2a5e16c70478bd1f8f167eaa480648f8  /scripts/godwoken-scripts/sudt-generator
0a1546315e655c9eceb12d57b5de33a45e146bf3  /scripts/godwoken-scripts/meta-contract-generator
4f0acafcb7fb6aa126e69563ddf3a5e90d4399cf  /scripts/godwoken-scripts/eth-account-lock
8a514513ce6eddff2307f0181fb9a89b0eddb0f5  /scripts/godwoken-scripts/custodian-lock
b505dbd3995475a7505941f1ec126eb3f1e2680d  /scripts/godwoken-scripts/stake-lock
248c7d2d85749d163423f3477b12231de1a9b3cd  /scripts/godwoken-scripts/always-success
8454d9dd82d2e3d6f983b368b10bc5440a381087  /scripts/godwoken-scripts/state-validator
f56582b1f3cc429e4694d2ca22b56a20774115af  /scripts/godwoken-scripts/withdrawal-lock
c0cb07bb8c9fb65e9bbcebae565fe6f65a8ebd80  /scripts/godwoken-scripts/tron-account-lock
ace3a0c5724f822aec9798bd742a82a328795189  /scripts/godwoken-scripts/challenge-lock
3d2391764cec321b34cd3ac9e4bab62fd45dc5fb  /scripts/godwoken-scripts/deposit-lock
b614a1b2897d137349ad8ff8e411e240b36bdc2a  /scripts/godwoken-polyjuice/validator_log
2fc1642bb0afc71482c268baf6135d691f1d210f  /scripts/godwoken-polyjuice/eth_addr_reg_validator
263977a6a096941fa895029d63ba110aa3ec83ca  /scripts/godwoken-polyjuice/validator_log.debug
075bb4a93b3d6464d13da85fd4ce7cd417a0f714  /scripts/godwoken-polyjuice/validator.debug
1a9c0273eccb5c915f6b087d403d704fff44205e  /scripts/godwoken-polyjuice/eth_addr_reg_validator.debug
6afd7bdae13ded9ace8e5930b954ca2e95e571d0  /scripts/godwoken-polyjuice/validator
2552480a0679257e74d704bdf410f6c598358cae  /scripts/godwoken-polyjuice/generator_log
2552480a0679257e74d704bdf410f6c598358cae  /scripts/godwoken-polyjuice/generator_log.aot
4c8a3c99a43a89d9ffb1cec544d5e69f69331b89  /scripts/godwoken-polyjuice/generator.aot
b5a2367a86c8a1410e872a49f72814d9c7fd5ffa  /scripts/godwoken-polyjuice/eth_addr_reg_generator
3944d769ddf21ee69b62bebed3785182b1dbaff7  /scripts/godwoken-polyjuice/generator_log.asm
4c8a3c99a43a89d9ffb1cec544d5e69f69331b89  /scripts/godwoken-polyjuice/generator
a28eba886f31fb2cc4c48bb384c76f76a6fb42fb  /scripts/godwoken-polyjuice/generator_log.debug
2758574e0ed7bb129b2122a5c8e7d7dda1d99a1b  /scripts/godwoken-polyjuice/eth_addr_reg_generator.debug
ac157afe645de69ccceb8ce56521495caf58180e  /scripts/godwoken-polyjuice/generator.debug
488ebe2fc3d825b55518a580e0946200308ea81c  /scripts/godwoken-polyjuice/generator.asm
```
