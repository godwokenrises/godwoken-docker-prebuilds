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

If your CPU/environment does not support AVX2, you can build Godwoken targeting your specific CPU/environment:
```sh
cd build/godwoken && rustup component add rustfmt && RUSTFLAGS="-C target-cpu=native" CARGO_PROFILE_RELEASE_LTO=true cargo build --release
```

## Check the reference of every component
```bash
docker inspect godwoken-prebuilds:[TAG] | egrep ref.component
```

## Scripts

All the scripts used by Godwoken can be found at `/scripts` folder:

```bash
$ docker run --rm godwoken-prebuilds find /scripts -type f -exec sha1sum {} \;

# Results
65556f1157bfa7819befe8cb1cf6af73924fdefa  /scripts/godwoken-scripts/eth-addr-reg-validator
678e163a475dd82c14f71fec189982643916c5ca  /scripts/godwoken-scripts/meta-contract-validator
56d24b532b9d790d24ca236782e8ed034b375399  /scripts/godwoken-scripts/sudt-validator
7716f9c629d1780129531929c21717050a8b20df  /scripts/godwoken-scripts/meta-contract-generator
df27b2036e747e07a8b9703262d17dc386736173  /scripts/godwoken-scripts/sudt-generator
e72547948d6028328bfc06a8caf5ccdbe2c4be19  /scripts/godwoken-scripts/eth-addr-reg-generator
502391a6bde1b5d6261fdd4f96204a69796adb38  /scripts/godwoken-scripts/deposit-lock
0f2d54a4b0c016404f8f6e80b5d538ee0f4411e8  /scripts/godwoken-scripts/withdrawal-lock
87586b3bf1117389cc0cc0785b0b3dfb74b9632b  /scripts/godwoken-scripts/custodian-lock
dfb6ad1ceda1dd19eb70bc0b3c01528134a7fe9b  /scripts/godwoken-scripts/stake-lock
677be9b2545c8d1b15aaeb039ac501b6a0f6244e  /scripts/godwoken-scripts/eth-account-lock
248c7d2d85749d163423f3477b12231de1a9b3cd  /scripts/godwoken-scripts/always-success
0f22b0f4249504a01d9eb615ae03176f5a1d5ac3  /scripts/godwoken-scripts/challenge-lock
cb92414b9d489115880bb09c8d0a2df60839d471  /scripts/godwoken-scripts/tron-account-lock
e1a2acd8764648a795fd8f513d39820baf0a00d0  /scripts/godwoken-scripts/state-validator
dab522b3b5a7c6fd179915f9059dac92891756eb  /scripts/godwoken-scripts/omni_lock
a1e5e6885d9c9fb465655e2c42a234b989ae1732  /scripts/godwoken-polyjuice/validator_log
5d4a374e797b8da741766a53bd2504528122d90b  /scripts/godwoken-polyjuice/validator.debug
cbd218999c11179ed5d6d3193abe7f9178d8d58f  /scripts/godwoken-polyjuice/validator
8db84dd427884bda3cfb8efe91651c1b44318eb5  /scripts/godwoken-polyjuice/validator_log.debug
e4a47d037cc6bd433b370e822ee6132b16dd9b0f  /scripts/godwoken-polyjuice/generator.aot
58dd869500d3a7ff21e973664fbe0647aad4afd2  /scripts/godwoken-polyjuice/generator_log.debug
3fcc5519ec1834934f9471002c346e499c242c3c  /scripts/godwoken-polyjuice/generator_log.asm
e4a47d037cc6bd433b370e822ee6132b16dd9b0f  /scripts/godwoken-polyjuice/generator
8fd6c431fd0c35eb3ddcbd0c187551c00807620c  /scripts/godwoken-polyjuice/generator_log.aot
3a8b3ce21d8f47fd6cc00b7469ce76c5c841f6a7  /scripts/godwoken-polyjuice/generator.asm
8fd6c431fd0c35eb3ddcbd0c187551c00807620c  /scripts/godwoken-polyjuice/generator_log
1ab4b82f61e10912789699a4281a9e70365a2ee6  /scripts/godwoken-polyjuice/generator.debug
e4a47d037cc6bd433b370e822ee6132b16dd9b0f  /scripts/godwoken-polyjuice-v1.3.0/generator.aot
58dd869500d3a7ff21e973664fbe0647aad4afd2  /scripts/godwoken-polyjuice-v1.3.0/generator_log.debug
3fcc5519ec1834934f9471002c346e499c242c3c  /scripts/godwoken-polyjuice-v1.3.0/generator_log.asm
e4a47d037cc6bd433b370e822ee6132b16dd9b0f  /scripts/godwoken-polyjuice-v1.3.0/generator
a1e5e6885d9c9fb465655e2c42a234b989ae1732  /scripts/godwoken-polyjuice-v1.3.0/validator_log
8fd6c431fd0c35eb3ddcbd0c187551c00807620c  /scripts/godwoken-polyjuice-v1.3.0/generator_log.aot
5d4a374e797b8da741766a53bd2504528122d90b  /scripts/godwoken-polyjuice-v1.3.0/validator.debug
3a8b3ce21d8f47fd6cc00b7469ce76c5c841f6a7  /scripts/godwoken-polyjuice-v1.3.0/generator.asm
cbd218999c11179ed5d6d3193abe7f9178d8d58f  /scripts/godwoken-polyjuice-v1.3.0/validator
8fd6c431fd0c35eb3ddcbd0c187551c00807620c  /scripts/godwoken-polyjuice-v1.3.0/generator_log
1ab4b82f61e10912789699a4281a9e70365a2ee6  /scripts/godwoken-polyjuice-v1.3.0/generator.debug
8db84dd427884bda3cfb8efe91651c1b44318eb5  /scripts/godwoken-polyjuice-v1.3.0/validator_log.debug
b237ed5461b22079c0ec54d6db6dc10d6519ac3a  /scripts/godwoken-polyjuice-v1.2.0/generator.aot
b287e270d518620592822f908aa24752613edd0d  /scripts/godwoken-polyjuice-v1.2.0/generator_log.debug
5faedf249944ef516780581bdab4fe307882c87d  /scripts/godwoken-polyjuice-v1.2.0/generator_log.asm
b237ed5461b22079c0ec54d6db6dc10d6519ac3a  /scripts/godwoken-polyjuice-v1.2.0/generator
41f24f61ea0b195245d6da8a98c02ae45efa35a6  /scripts/godwoken-polyjuice-v1.2.0/validator_log
d0059d518c764e034f30823283fed5cd6082e308  /scripts/godwoken-polyjuice-v1.2.0/generator_log.aot
50ff83099f174ff5c34d73e56c8eec04235e1352  /scripts/godwoken-polyjuice-v1.2.0/validator.debug
b8a17d45ccce7459e8e8da9e519dd5d9e1e320ab  /scripts/godwoken-polyjuice-v1.2.0/generator.asm
86e2b0ecf246584ada7e64e4b5ebbac6918d7551  /scripts/godwoken-polyjuice-v1.2.0/validator
d0059d518c764e034f30823283fed5cd6082e308  /scripts/godwoken-polyjuice-v1.2.0/generator_log
5b216531ea89d9da981937f4e0e9761243ff2bb0  /scripts/godwoken-polyjuice-v1.2.0/generator.debug
b7ab7425ffb17203d35f5dd2706c8161e4b70c25  /scripts/godwoken-polyjuice-v1.2.0/validator_log.debug
9f0188ce6a63728dc94866ef2afdd4a1be3f92d3  /scripts/godwoken-polyjuice-v1.1.5-beta/generator.aot
77d28b59cdd676c9f8e2f1a5e67d4e4e459964ff  /scripts/godwoken-polyjuice-v1.1.5-beta/generator_log.debug
b1ad76ebfd33d78dfe64eb83ccda48aa894eb1bf  /scripts/godwoken-polyjuice-v1.1.5-beta/generator_log.asm
9f0188ce6a63728dc94866ef2afdd4a1be3f92d3  /scripts/godwoken-polyjuice-v1.1.5-beta/generator
72c65857191fb3573082e575c4895198c4fc0847  /scripts/godwoken-polyjuice-v1.1.5-beta/validator_log
6a48d77057e5f0273979940f58df91c03059a84e  /scripts/godwoken-polyjuice-v1.1.5-beta/generator_log.aot
ac794559ba1ed447bbc4d981760dcdd5b206761b  /scripts/godwoken-polyjuice-v1.1.5-beta/validator.debug
1c420832bcecf00e9507679e8d978167f24ba6c8  /scripts/godwoken-polyjuice-v1.1.5-beta/generator.asm
d5cacaa93d92adc9748d4ed6e88259522b21161a  /scripts/godwoken-polyjuice-v1.1.5-beta/validator
6a48d77057e5f0273979940f58df91c03059a84e  /scripts/godwoken-polyjuice-v1.1.5-beta/generator_log
4af40a410c9c77ad70125c61d2b9fd5e01187a30  /scripts/godwoken-polyjuice-v1.1.5-beta/generator.debug
4f3f1e5fc557477fb1f9430771e8adacd1b384f2  /scripts/godwoken-polyjuice-v1.1.5-beta/validator_log.debug
```
