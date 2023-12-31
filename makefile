.PHONY: container.build
container.build:
	docker build --file Dockerfile --tag embedded_sdk .

.PHONY: container.pull.remote
container.pull.remote:
	docker pull ghcr.io/mitchellthompkins/embedded_sdk:latest

.PHONY: container.start.%
container.start.%:
	docker-compose -f docker-compose.yaml run --rm $* 'sh -x'
