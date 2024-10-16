.PHONY: container.build.%
container.build.%:
	docker build --file Dockerfile \
		--build-arg platform=$* \
		--platform=linux/$* \
		--tag embedded_sdk-$* .

.PHONY: container.publish.%
container.publish.%:
	docker run ghcr.io/mitchellthompkins/embedded_sdk-$*:latest
	docker push ghcr.io/mitchellthompkins/embedded_sdk-$*:latest

.PHONY: container.pull.%
container.pull.%:
	docker pull ghcr.io/mitchellthompkins/embedded_sdk-$*:latest

.PHONY: container.start.%
container.start.%:
	docker-compose -f docker-compose.yaml run --rm $* 'sh -x'
