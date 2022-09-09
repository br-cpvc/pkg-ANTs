#!/usr/bin/env bash
set -e
set -x
script_dir=$(dirname "$0")

itk_dir=$1

if [ -d $itk_dir ]; then
    sh ${script_dir}/patch_itk.sh $itk_dir

    cd $itk_dir
    mkdir -p build
    cd build
    cmake .. \
	-DCMAKE_INSTALL_PREFIX=../install \
	-DCMAKE_BUILD_TYPE=Release \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_SHARED_LIBS=OFF \
	-DBUILD_TESTING=OFF \
	-DITKV3_COMPATIBILITY=ON \
	-DITK_DYNAMIC_LOADING=OFF \
	-DModule_ITKReview=ON
    n=`nproc --ignore 1`
    make -j $n
    make install
    cd ../..
fi