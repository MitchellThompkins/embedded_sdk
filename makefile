.PHONY: container.build
container.build:
	docker build --file Dockerfile --tag embedded_sdk .

.PHONY: container.pull.remote
container.pull.remote:
	docker pull ghcr.io/mitchellthompkins/embedded_sdk:latest

.PHONY: container.start.%
container.start.%:
	docker-compose -f docker-compose.yml run --rm $* 'sh -x'

.PHONY: foo
foo:
	wget -O qemu.tar.xz ${qemu_url} \
    && tar -xvf qemu.tar.xz \
    && cd ${qemu_release} && mkdir build && cd build && ../configure --target-list=${qemu_soft_mmu} && make -j$(nproc) && make install && cd ../ \
