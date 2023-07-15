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

There is a 'docker-compose.yaml' and `entrypoint.sh` which can be used to open
up a container instance with:
* `make container.start.remote` for a container pulled with `make container.pull.remote`
* `make container.start.local` for a locally built container
