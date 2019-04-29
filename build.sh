#!/bin/bash

set -o errexit

[[ $# -eq 0 ]] || exit 1

TOP=$(realpath ../../..)

export KBUILD_BUILD_USER=grapheneos
export KBUILD_BUILD_HOST=grapheneos

PATH="$TOP/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin:$PATH"
PATH="$TOP/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9/bin:$PATH"
PATH="$TOP/prebuilts/misc/linux-x86/lz4:$PATH"
PATH="$TOP/prebuilts/misc/linux-x86/dtc:$PATH"
PATH="$TOP/prebuilts/misc/linux-x86/libufdt:$PATH"

make O=out ARCH=arm64 marlin_defconfig

make -j$(nproc) \
    O=out \
    ARCH=arm64 \
    CROSS_COMPILE=aarch64-linux-android- \
    CROSS_COMPILE_ARM32=arm-linux-androideabi-

rm -rf "$TOP/device/google/marlin-kernel"
mkdir -p "$TOP/device/google/marlin-kernel"
cp out/arch/arm64/boot/Image.lz4-dtb "$TOP/device/google/marlin-kernel"
