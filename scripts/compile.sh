#!/usr/bin/env bash
set -e
#set -x
script_dir=$(dirname "$0")
cwd=`pwd`

#itk_version="4.5.0"
#itk_version="4.7.2"
itk_version=4.9rc03
itk_dir_prefix="InsightToolkit"
outputdir=$2
source ${script_dir}/dwn_itk.sh $itk_dir_prefix $itk_version $outputdir

itk_dir="$outputdir/$itk_dir_prefix-$itk_version"

# build dependencies
build_script=$1
source $build_script $itk_dir

# only build the subset of Example binaries needed
sed -i 's/foreach(ANTS_APP ${BASE_ANTS_APPS})/foreach(ANTS_APP ImageMath N3BiasFieldCorrection N4BiasFieldCorrection Atropos)/g' deps/ANTs/Examples/CMakeLists.txt

sed -i 's/VERSION 2.8.9/VERSION 2.8.7/g' deps/ANTs/CMakeLists.txt

# make
mkdir -p $outputdir/build
cd $outputdir/build
cmake $cwd/deps/ANTs/ \
-DCMAKE_INSTALL_PREFIX=../install \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=/usr/bin/gcc-4.8 \
-DCMAKE_CXX_COMPILER=/usr/bin/g++-4.8 \
-DITK_DIR=$cwd/$itk_dir/build \
-DRUN_LONG_TESTS=OFF \
-DRUN_SHORT_TESTS=OFF \
-DBUILD_EXTERNAL_APPLICATIONS=OFF \
-DBUILD_TESTING=OFF \
-DCMAKE_CXX_FLAGS="-fopenmp" \
-DCMAKE_EXE_LINKER_FLAGS="-static"

sh ${script_dir}/make.sh
cd $cwd
