#!/usr/bin/env bash
set -e
set -x
script_dir=$(dirname "$0")
cwd=`pwd`

itk_dir=$1

if [ -d $itk_dir ]; then
    source ${script_dir}/patch_itk.sh $itk_dir
    source ${script_dir}/patch_itk_tolerance.sh $itk_dir

    cd $itk_dir
    mkdir -p build
    cd build
    cmake .. \
	-DCMAKE_INSTALL_PREFIX=../install \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_C_COMPILER=/usr/bin/gcc-11 \
	-DCMAKE_CXX_COMPILER=/usr/bin/g++-11 \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_TESTING=OFF \
	-DITK_LEGACY_REMOVE:BOOL=OFF \
	-DBUILD_SHARED_LIBS=OFF \
	-DITK_DYNAMIC_LOADING=OFF \
	-DModule_GenericLabelInterpolator:BOOL=ON \
	-DModule_AdaptiveDenoising:BOOL=ON \
	-DModule_ITKReview=ON
    n=`nproc --ignore 1`
    make -j $n install
    cd $cwd
fi
