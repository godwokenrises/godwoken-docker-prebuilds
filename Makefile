SHELL := /bin/bash

# components repos
GODWOKEN_REPO := https://github.com/nervosnetwork/godwoken.git
GODWOKEN_SCRIPTS_REPO := https://github.com/nervosnetwork/godwoken-scripts.git
POLYJUICE_REPO := https://github.com/nervosnetwork/godwoken-polyjuice.git
CLERKB_REPO := https://github.com/nervosnetwork/clerkb.git

# components tags
GODWOKEN_REF := v0.10.6 # https://github.com/nervosnetwork/godwoken/commit/d82015798c242c51c1ddb5270ef4b9e5dc6da200
GODWOKEN_SCRIPTS_REF := v0.9.0 # https://github.com/nervosnetwork/godwoken-scripts/releases/tag/v0.9.0
POLYJUICE_REF := v0.8.11
CLERKB_REF := v0.4.0

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
	$(call prepare_repo,$(CLERKB_REPO),$(CLERKB_REF),clerkb)
	echo "::set-output name=CLERKB_REF::$(CLERKB_REF) $$(cd build/clerkb && git rev-parse --short HEAD)" >> versions

build-components: prepare-repos
	cd build/godwoken-polyjuice && make dist && cd -
	cd build/godwoken-scripts && cd c && make && cd .. && capsule build --release --debug-output && cd ../..
	cd build/clerkb && yarn && make all-via-docker && cd ../..

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
	make test-clerkb-files
	make test-scripts-files
	make test-polyjuice-files
# compare bin files
	cd `pwd`/test-result/bin && ./godwoken --version && ./gw-tools --version
	[ -e "test-result" ] && rm -rf test-result

test-clerkb-files:
	source tool.sh && check_clerkb_files_exists

test-scripts-files:
	source tool.sh && check_scripts_files_exists

test-polyjuice-files:
	source tool.sh && check_polyjuice_files_exists 
