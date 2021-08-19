SHELL := /bin/bash

build-components:
	git submodule update --init --recursive
	cd godwoken-polyjuice && git submodule update --init --recursive && cd ..
	cd godwoken-polyjuice; make clean-via-docker; cd ..
	cd godwoken-polyjuice && make all-via-docker && cd ..
	cd godwoken-scripts && git submodule update --init --recursive && cd ..
	cd godwoken-scripts && cd c && make && cd .. && capsule build --release --debug-output && cd ..
	cd clerkb && yarn && make all-via-docker && cd ..

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

