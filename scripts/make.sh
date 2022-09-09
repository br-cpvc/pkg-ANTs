#!/usr/bin/env bash
set -e
#set -x

target=$1

n=`nproc`
make -j $n $target
#make install
