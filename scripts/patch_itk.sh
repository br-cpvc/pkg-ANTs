#!/usr/bin/env bash
set -e

itk_dir=$1
#backupdir="backup"
#mkdir -p $backupdir

# version 4.8.2 requires cmake 2.8.9 by default, ubuntu 12.04 only have 2.8.7, this seems to fix the problem without errors
f="$itk_dir/CMakeLists.txt"
#cp $f $backupdir
sed -i 's/cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)/cmake_minimum_required(VERSION 2.8.7 FATAL_ERROR)/g' $f

# avoids warning by disabling functionality: SystemTools.cxx:(.text+0x1b6a): warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
f="$itk_dir/Modules/ThirdParty/KWSys/src/KWSys/SystemTools.cxx"
#cp $f $backupdir
sed -i 's/define HAVE_GETPWNAM 1/undef HAVE_GETPWNAM/' $f
