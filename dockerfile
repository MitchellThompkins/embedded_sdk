FROM rockylinux:9

RUN dnf install -y epel-release && \
    dnf install --enablerepo=crb -y \
    ninja-build \
    clang \
    make \
    automake \
    autoconf \
    libtool \
    gcc \
    libncurses* \
    bzip2 \
    glib2-devel \
    zlib-devel \
    flex-devel \
    flex \
    pixman-devel \
    bison \
    python3 \
    gdb \
    wget \
    which \
    git \
    xz \
    diffutils \
    python3-tomli \
    python3-pip

WORKDIR /opt/


############################
# Install cmake ############
############################
ARG cmake_version="3.30.5"
ARG cmake_release="cmake-${cmake_version}-linux-x86_64"
ARG cmake_url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/${cmake_release}.tar.gz"

RUN wget -O cmake.tar.gz ${cmake_url} \
    && tar -xvf cmake.tar.gz -C /opt/ \
    && rm -rf cmake.tar.gz


############################
# Install arm toolchain ####
############################
ARG arm_toolchain="arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi"
ARG arm_toolchain_url="https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/${arm_toolchain}.tar.xz"

RUN wget -O arm_none_eabi.tar.xz ${arm_toolchain_url} \
    && tar -xvf arm_none_eabi.tar.xz -C /opt/ \
    && rm -rf arm_none_eabi.tar.xz


############################
# Install avr toolchain ####
############################
ARG avr_toolchain_version="7.3.0-atmel3.6.1-arduino7"
ARG avr_toolchain="avr-gcc-${avr_toolchain_version}-x86_64-pc-linux-gnu"
ARG avr_toolchain_url="https://downloads.arduino.cc/tools/${avr_toolchain}.tar.bz2"

RUN wget -O avr_gcc.tar.bz2 ${avr_toolchain_url} \
    && tar -xvf avr_gcc.tar.bz2 -C /opt/ \
    && rm -rf avr_gcc.tar.bz2


############################
# Install qemu #############
############################
ARG qemu_version="9.2.0"
ARG qemu_release="qemu-${qemu_version}"
ARG qemu_url="https://download.qemu.org/${qemu_release}.tar.xz"

ARG targets="aarch64-softmmu,arm-softmmu,avr-softmmu"

RUN wget -O qemu.tar.xz ${qemu_url} \
    && tar -xvf qemu.tar.xz \
    && cd ${qemu_release} && mkdir build && cd build && ../configure --target-list=${targets} && make -j$(nproc) && make install && cd ../ \
    && rm -rf qemu.tar.xz \
    && rm -rf ${qemu_release}

############################
# Python ###################
############################
COPY requirements.txt .
RUN python3 -m pip install -r requirements.txt

############################
# Set path #################
############################
ENV PATH="${PATH}:/opt/${arm_toolchain}/bin:/opt/${cmake_release}/bin:/opt/avr/bin"

RUN arm-none-eabi-gcc --version && \
    arm-none-eabi-g++ --version && \
    gcc --version && \
    clang --version && \
    cmake --version && \
    qemu-system-arm --version && \
    avr-gcc --version && \
    python3 --version
