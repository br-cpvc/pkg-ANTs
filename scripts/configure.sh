#!/usr/bin/env bash
set -e
#set -x
script_dir=$(dirname "$0")
cwd=`pwd`

build_dir=$1

# only build the subset of Example binaries needed
sed -i 's/foreach(ANTS_APP ${CORE_ANTS_APPS})/foreach(ANTS_APP ImageMath N3BiasFieldCorrection N4BiasFieldCorrection Atropos)/g' $cwd/deps/ANTs/Examples/CMakeLists.txt
# TODO: replace with these:
#-DBUILD_ALL_ANTS_APPS:BOOL=OFF \
#-DANTS_BUILD_ImageMath:BOOL=ON \

# make
mkdir -p ${build_dir}
cd ${build_dir}
cmake $cwd/deps/ANTs/ \
-DCMAKE_INSTALL_PREFIX=${build_dir}/../install \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=/usr/bin/gcc-7 \
-DCMAKE_CXX_COMPILER=/usr/bin/g++-7 \
-DRUN_LONG_TESTS=OFF \
-DRUN_SHORT_TESTS=OFF \
-DBUILD_TESTING=OFF \
-DBUILD_SHARED_LIBS:BOOL=OFF \
-DBUILD_ALL_ANTS_APPS:BOOL=OFF \
-DCMAKE_CXX_FLAGS:STRING="-fopenmp" \
-DCMAKE_EXE_LINKER_FLAGS="-static"
cd $cwd
