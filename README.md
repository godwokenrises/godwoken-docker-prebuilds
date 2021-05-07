godwoken-docker-prebuilds
=========================

Docker image containing all binaries used by godwoken, saving you the hassles of building them yourself.

How to build:

```bash
$ git clone --recursive https://github.com/xxuejie/godwoken-docker-prebuilds
$ cd godwoken-docker-prebuilds
$ cd godwoken-polyjuice && make all-via-docker && cd ..
$ cd godwoken-scripts && cd c && make && cd .. && capsule build --release --debug-output && cd ..
$ docker build . -t godwoken-prebuilds
```
