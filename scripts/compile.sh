#!/usr/bin/env bash
set -e
#set -x
script_dir=$(dirname "$0")

cwd=`pwd`
#itk_version="4.5.0"
#itk_version="4.7.2"
itk_version=4.8.2
sh ${script_dir}/dwn_itk.sh $itk_version

itk="InsightToolkit-$itk_version"

# build dependencies
sh ${script_dir}/build_itk.sh $itk_version

# only build the subset of Example binaries needed
sed -i 's/foreach(ANTS_APP ${BASE_ANTS_APPS})/foreach(ANTS_APP ImageMath N3BiasFieldCorrection N4BiasFieldCorrection Atropos)/g' deps/ANTs/Examples/CMakeLists.txt

# make
mkdir -p build
cd build
cmake ../deps/ANTs/ \
-DCMAKE_INSTALL_PREFIX=../install \
-DCMAKE_BUILD_TYPE=Release \
-DITK_DIR=$cwd/$itk/build \
-DRUN_LONG_TESTS=OFF \
-DRUN_SHORT_TESTS=OFF \
-DBUILD_EXTERNAL_APPLICATIONS=OFF \
-DBUILD_TESTING=OFF \
-DCMAKE_CXX_FLAGS="-fopenmp" \
-DCMAKE_EXE_LINKER_FLAGS="-static"
n=`nproc`
make -j $n
#make install
cd ..
