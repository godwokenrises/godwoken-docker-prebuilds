build-push:
	cd godwoken-polyjuice && make all-via-docker && cd ..
	cd godwoken-scripts && cd c && make && cd .. && capsule build --release --debug-output && cd ..
	@read -p "Tags: " VERSION ; \
	docker build . -t nervos/godwoken-prebuilds:$$VERSION
	docker push nervos/godwoken-prebuilds:$$VERSION

test:
	cd godwoken-polyjuice && make all-via-docker && cd ..
	cd godwoken-scripts && cd c && make && cd .. && capsule build --release --debug-output && cd ..
	docker build . -t nervos/godwoken-prebuilds	
