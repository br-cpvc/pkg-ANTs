#!/usr/bin/env bash
set -e
#set -x
script_dir=$(dirname "$0")
cwd=`pwd`

old_method=true
if [[ "$old_method" == true ]]; then
    # use a hardcoded version of itk, downloaded
    # as a tar ball and compiled from source
    #itk_version="4.5.0"
    #itk_version="4.7.2"
    itk_version=4.8.2
    itk_version=5.2.1
    itk_version=5.0rc02
    #itk_version=5.3rc04
    itk_dir_prefix="InsightToolkit"
    outputdir=$2
    source ${script_dir}/dwn_itk.sh $itk_dir_prefix $itk_version $outputdir

    itk_dir="$outputdir/$itk_dir_prefix-$itk_version"
else
    # use git submodule checkout version of itk,
    # needs to have added itk as git submodule deps/ITK
    #itk_dir="deps/ITK"

    # git clone and checkout the itk version specified in
    # the ANTs SuperBuild/External_ITKv5.cmake script, then
    # patch it.
    itk_dir="$outputdir/ITKv5_git_checkout"
    source ${script_dir}/checkout_itk_from_git.sh $itk_dir
fi

# build dependencies
build_script=$1
source $build_script $itk_dir

# only build the subset of Example binaries needed
sed -i 's/foreach(ANTS_APP ${CORE_ANTS_APPS})/foreach(ANTS_APP ImageMath N3BiasFieldCorrection N4BiasFieldCorrection Atropos)/g' deps/ANTs/Examples/CMakeLists.txt
# TODO: replace with these:
#-DBUILD_ALL_ANTS_APPS:BOOL=OFF \
#-DANTS_BUILD_ImageMath:BOOL=ON \

# make
mkdir -p $outputdir/build
cd $outputdir/build
cmake $cwd/deps/ANTs/ \
-DCMAKE_INSTALL_PREFIX=../install \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_C_COMPILER=/usr/bin/gcc-5 \
-DCMAKE_CXX_COMPILER=/usr/bin/g++-5 \
-DITK_DIR=$cwd/$itk_dir/build \
-DRUN_LONG_TESTS=OFF \
-DRUN_SHORT_TESTS=OFF \
-DBUILD_TESTING=OFF \
-DBUILD_ALL_ANTS_APPS:BOOL=OFF \
-DCMAKE_CXX_FLAGS="-fopenmp"
#-DCMAKE_EXE_LINKER_FLAGS="-static" \
#-DCMAKE_FIND_LIBRARY_SUFFIXES=".a"
#-DBUILD_SHARED_LIBS:BOOL=OFF \

# see: https://www.kitware.com/creating-static-executables-on-linux/

sh ${script_dir}/make.sh
cd $cwd
