#!/bin/bash

#编译链 clang13.0.1 MAIN 分支 https://github.com/nzlnice/kernel_bulid.git
#下面是sh配置文件，使用Gcc+clang13 交叉编译 仅参考 需根据实际修改（可更换高版本clang尝试编译）
#我这里 clang13编译测试通过
# 清理编译环境
make clean
make mrproper
clear
# 设置工具链路径
OUT_DIR=/home/meaning/桌面/out
export PATH=$PATH:/home/meaning/桌面/clang/toolclang/clang-r428724/bin:/home/meaning/桌面/clang/toolgcc/bin:/home/meaning/桌面/clang/toolgcc/arm/bin
export ARCH=arm64
export CC=/home/meaning/桌面/clang/toolclang/clang-r428724/bin/clang
export SUBARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=/home/meaning/桌面/clang/toolgcc/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=/home/meaning/桌面/clang/toolgcc/arm/bin/arm-linux-androideabi-

# LLVM 配置
export LLVM=1
export LLVM_IAS=1

# 工具链配置
export AR=/home/meaning/桌面/clang/toolclang/clang-r428724/bin/llvm-ar
export HOSTCC=gcc
export HOSTCXX=/home/meaning/桌面/clang/toolclang/clang-r428724/bin/clang++
export NM=/home/meaning/桌面/clang/toolclang/clang-r428724/bin/llvm-nm
export OBJCOPY=/home/meaning/桌面/clang/toolclang/clang-r428724/bin/llvm-objcopy
export OBJDUMP=/home/meaning/桌面/clang/toolclang/clang-r428724/bin/llvm-objdump
export STRIP=/home/meaning/桌面/clang/toolclang/clang-r428724/bin/llvm-strip
export LD=/home/meaning/桌面/clang/toolclang/clang-r428724/bin/ld.lld
export DTC_EXT=/home/meaning/桌面/clang/dtc
# dtc这个需要如上单独声明设置，不然编译dtb会报错 若要更换高版本clang编译链需要注意这一步

# Android内核特定配置
export PLATFORM_VERSION=12
export ANDROID_MAJOR_VERSION=s

# 构建信息
export KBUILD_BUILD_HOST=Coolapk@遇梦晚忆
export KBUILD_BUILD_USER=$(whoami)

# 生成配置文件
make ARCH=arm64 O=$OUT_DIR CC=$CC vendor/arnoz_defconfig

ccache make ARCH=arm64 O=$OUT_DIR CC=$CC -j14 2>&1 | tee /home/meaning/桌面/out/kernel_log.log

#！！！！！！！！！！！！！在输出的out文件夹执行！！！！！！！！！！
#注意！联想的很多驱动依赖内核ko模块！！
#sudo make ARCH=arm64 O=$OUT_DIR CC=$CC modules_install INSTALL_MOD_PATH=vendor
#ko模块会在/home/meaning/桌面/out/vendor/lib/module路径
#最后在里面把ko后缀文件放vendor/lib/modules下即可否则无声音和旋转等重要功能
