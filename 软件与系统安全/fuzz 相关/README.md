# libfuzzer

根据教程 [Dor1s/libfuzzer-workshop](https://github.com/Dor1s/libfuzzer-workshop) 进行学习

## 环境配置（待更改）

Ubuntu 18.04

LLVM 8.0
- [Download LLVM 8.0.0](http://releases.llvm.org/download.html#8.0.0)

```bash
# Pre-Built Binaries
wget http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
tar xf clang*
cd clang*
sudo cp -R * /usr/local/
```

```bash
# apt source
# Bionic (18.04) 8
deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main
deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main

# To retrieve the archive signature:
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
# Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421

# To install just clang, lld and lldb (8 release):
apt-get install clang-8 lldb-8 lld-8

# To install all key packages:
# LLVM
apt-get install libllvm-8-ocaml-dev libllvm8 llvm-8 llvm-8-dev llvm-8-doc llvm-8-examples llvm-8-runtime
# Clang and co
apt-get install clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 python-clang-8
# libfuzzer
apt-get install libfuzzer-8-dev
# lldb
apt-get install lldb-8
# lld (linker)
apt-get install lld-8
# libc++
apt-get install libc++-8-dev libc++abi-8-dev
# OpenMP
apt-get install libomp-8-dev
```

```bash
sudo apt install gcc make autoconf automake pkg-config zlib1g-dev curl

# environmrnt
export LDFLAGS="-L/usr/local/zlib/lib"
export CPPFLAGS="-I /usr/local/zlib/include"
```

## 参考链接
- [LLVM Debian/Ubuntu nightly packages](http://apt.llvm.org/)
- [libfuzzer-workshop](https://github.com/Dor1s/libfuzzer-workshop)
- [libFuzzer Tutorial](https://github.com/google/fuzzer-test-suite/blob/master/tutorial/libFuzzerTutorial.md)
- [Finding security vulnerabilities with modern fuzzing techniques](http://archive.hack.lu/2018/Slides_Fuzzing_Workshop_Hack.lu_v1.0.pdf)