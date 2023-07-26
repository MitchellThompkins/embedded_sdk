FROM rockylinux:8

# Install necessary packages
RUN dnf install --enablerepo=powertools  -y\
    ninja-build\
    clang\
    make\
    automake\
    autoconf\
    libtool\
    gcc\
    libncurses*\
    bzip2\
    glib2-devel\
    zlib-devel\
    flex-devel\
    flex\
    pixman-devel\
    bison\
    python39\
    python27\
    gdb\
    wget\
    which\
    git\
    xz

WORKDIR /opt/


############################
# Install cmake ############
############################
# From compiled release b/c the rocky linux repo resolves to version 3.20
ARG cmake_version="3.27.0-rc4"
ARG cmake_release="cmake-${cmake_version}-linux-x86_64"
ARG cmake_url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/${cmake_release}.tar.gz"

RUN wget -O cmake.tar.gz ${cmake_url} \
    && tar -xvf cmake.tar.gz -C /opt/ \
    && rm -rf cmake.tar.gz


############################
# Install arm toolchain ####
############################
ARG arm_toolchain_url="https://developer.arm.com/-/media/Files/downloads/gnu-rm/6_1-2017q1/gcc-arm-none-eabi-6-2017-q1-update-linux.tar.bz2?rev=6799a2bcea254e118a363f4bce1c06f7&revision=6799a2bc-ea25-4e11-8a36-3f4bce1c06f7?product=Downloads,64-bit,,Linux,6-2017-q1-update"

RUN wget -O arm_none_eabi.tar.xz ${arm_toolchain_url} \
    && tar -xvf arm_none_eabi.tar.xz -C /opt/ \
    && rm -rf arm_toolchain.tar.xz


############################
# Install qemu #############
############################
ARG qemu_version="8.0.2"
ARG qemu_release="qemu-${qemu_version}"
ARG qemu_url="https://download.qemu.org/${qemu_release}.tar.xz"

ARG targets="aarch64-softmmu,arm-softmmu,avr-softmmu"

RUN wget -O qemu.tar.xz ${qemu_url} \
    && tar -xvf qemu.tar.xz \
    && cd ${qemu_release} && mkdir build && cd build && ../configure --target-list=${targets} && make -j$(nproc) && make install && cd ../ \
    && rm -rf qemu.tar.xz \
    && rm -rf ${qemu_release}


############################
# Set path #################
############################
ENV PATH="${PATH}:/opt/${arm_toolchain}/bin:/opt/${cmake_release}/bin"
