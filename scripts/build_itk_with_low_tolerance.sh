# was previous compiled against minc version 2.1.10 from the minc-registration project
set -e
set -x

cwd=`pwd`
itk_version=$1
itk="InsightToolkit-$itk_version"

if [ ! -d $itk ]; then
    tar -zxf deps/itk/${itk}.tar.gz
    mv ITK-${itk_version} ${itk}

    # version 4.8.2 requires cmake 2.8.9 by default, ubuntu 12.04 only have 2.8.7, this seems to fix the problem without errors
    backupdir="backup"
    mkdir -p $backupdir
    f="$itk/CMakeLists.txt"
    cp $f $backupdir
    sed -i 's/cmake_minimum_required(VERSION 2.8.9 FATAL_ERROR)/cmake_minimum_required(VERSION 2.8.7 FATAL_ERROR)/g' $f

    # avoids warning by disabling functionality: SystemTools.cxx:(.text+0x1b6a): warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
    f="$itk/Modules/ThirdParty/KWSys/src/KWSys/SystemTools.cxx"
    cp $f $backupdir
    sed -i 's/define HAVE_GETPWNAM 1/undef HAVE_GETPWNAM/' $f

    # Overwrite tolerance default 1.0e-6 with 1.0e-2 to avoid
    # error: "Inputs do not occupy the same physical space"
    # from: https://github.com/stnava/ANTs/issues/74
    # and: https://github.com/stnava/ANTs/issues/31
    backupdir="backup"
    mkdir -p $backupdir
    f="$itk/Modules/Core/Common/src/itkImageToImageFilterCommon.cxx"
    cp $f $backupdir
    sed -i 's/1.0e-6/1.0e-2/g' $f

    cd $itk
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
