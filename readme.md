# Description

This is a collection of tools used to build and test embedded platforms.
Notably it:

* Is based on Rocky Linux 8
* Installs a collection of common embedded development tools
* Installs `cmake` from source
* Installs the following from source:
    * qemu-system-arm
    * qemu-system-aarch64
    * qemu-system-avr

# Usage

There is a `docker-compose.yaml` and `entrypoint.sh` which can be used to open
up a container instance with:
* `make container.start.remote` for a container pulled with `make container.pull.remote`
* `make container.start.local-arm64` or `make container.start.local-amd64`for a locally built container

# Limitations
Curently this only pushes `embedded_sdk` to the docker registry, instead of the
respective `embedded_sdk-amd64` `embedded_sdk-arm64`. [Per
github](https://github.com/orgs/community/discussions/19197#discussioncomment-10895290)
they do not (as of Octobery 16, 2024) support `arm64` bit runners, so there is
no way to build the `arm64` version.
