SHELL := /bin/bash

# components repos
GODWOKEN_REPO := https://github.com/godwokenrises/godwoken.git
GODWOKEN_SCRIPTS_REPO := https://github.com/godwokenrises/godwoken-scripts.git
POLYJUICE_REPO := https://github.com/godwokenrises/godwoken-polyjuice.git
OMNI_LOCK_REPO := https://github.com/nervosnetwork/ckb-production-scripts.git

# components tags
GODWOKEN_REF := v1.7.0 # https://github.com/godwokenrises/godwoken/compare/v1.7.0-rc2...v1.7.0
GODWOKEN_SCRIPTS_REF := v1.3.0-rc1 # https://github.com/godwokenrises/godwoken-scripts/compare/v1.1.0-beta...v1.3.0-rc1
POLYJUICE_REF := 1.4.5 # https://github.com/godwokenrises/godwoken-polyjuice/compare/1.4.1...1.4.5
OMNI_LOCK_REF := rc_lock

define prepare_repo
	if [ ! -d "build/$(3)" ]; then\
		git clone --depth=1 $(1) build/$(3);\
	fi
	cd build/$(3);\
	git fetch origin $(2);\
	git checkout FETCH_HEAD;\
	git submodule update --init --recursive --depth=1;\
	echo "::set-output name=$(3)-sha1::$$(git rev-parse HEAD)" >> ../../versions
endef

prepare-repos:
	mkdir -p build
	$(call prepare_repo,$(GODWOKEN_REPO),$(GODWOKEN_REF),godwoken)
	echo "::set-output name=GODWOKEN_REF::$(GODWOKEN_REF) $$(cd build/godwoken && git rev-parse --short HEAD)" >> versions
	$(call prepare_repo,$(GODWOKEN_SCRIPTS_REPO),$(GODWOKEN_SCRIPTS_REF),godwoken-scripts)
	echo "::set-output name=GODWOKEN_SCRIPTS_REF::$(GODWOKEN_SCRIPTS_REF) $$(cd build/godwoken-scripts && git rev-parse --short HEAD)" >> versions
	$(call prepare_repo,$(POLYJUICE_REPO),$(POLYJUICE_REF),godwoken-polyjuice)
	echo "::set-output name=POLYJUICE_REF::$(POLYJUICE_REF) $$(cd build/godwoken-polyjuice && git rev-parse --short HEAD)" >> versions
	$(call prepare_repo,$(OMNI_LOCK_REPO),$(OMNI_LOCK_REF),ckb-production-scripts)
	echo "::set-output name=OMNI_LOCK_REF::$(OMNI_LOCK_REF) $$(cd build/ckb-production-scripts && git rev-parse --short HEAD)" >> versions

build-components: prepare-repos
	cd build/godwoken-polyjuice && make dist && cd -
	cd build/godwoken-scripts && cd c && make && cd .. && capsule build --release --debug-output && cd ../..
	cd build/ckb-production-scripts && make all-via-docker
	cd build/godwoken && rustup component add rustfmt && RUSTFLAGS="-C target-cpu=native" CARGO_PROFILE_RELEASE_LTO=true cargo build --release

build-push:
	make build-components
	@read -p "Please Enter New Image Tag: " VERSION ; \
	docker build . -t nervos/godwoken-prebuilds:$$VERSION ; \
	docker push nervos/godwoken-prebuilds:$$VERSION

test:
	make build-components
	docker build . -t nervos/godwoken-prebuilds:latest-test
	mkdir -p `pwd`/test-result/scripts
	mkdir -p `pwd`/test-result/bin
	docker run -it -d --name dummy nervos/godwoken-prebuilds:latest-test
	docker cp dummy:/scripts/. `pwd`/test-result/scripts
	docker cp dummy:/bin/godwoken `pwd`/test-result/bin
	docker cp dummy:/bin/gw-tools `pwd`/test-result/bin
	docker rm -f dummy
	make test-files

test-files:
	echo "start checking build result..."
# compare scripts files
	make test-scripts-files
	make test-polyjuice-files
# compare bin files
	cd `pwd`/test-result/bin && ./godwoken --version && ./gw-tools --version
	[ -e "test-result" ] && rm -rf test-result

test-scripts-files:
	source tool.sh && check_scripts_files_exists

test-polyjuice-files:
	source tool.sh && check_polyjuice_files_exists 
