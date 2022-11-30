#!/usr/bin/env bash
set -e
set -x

BUILD_NUMBER=$1

script_dir=$(dirname "$0")
cd ${script_dir}/..
outputdir=output
source ${script_dir}/compile.sh ${script_dir}/build_itk.sh $outputdir

deb_root=${outputdir}/debian
rm -rf ${deb_root}/usr
mkdir -p ${deb_root}/usr/bin
builddir=${outputdir}/build/bin
cp $builddir/Atropos ${deb_root}/usr/bin
cp $builddir/ImageMath ${deb_root}/usr/bin
cp $builddir/N3BiasFieldCorrection ${deb_root}/usr/bin
cp $builddir/N4BiasFieldCorrection ${deb_root}/usr/bin

cmake_version_file=deps/ANTs/CMakeLists.txt
version_major=$(cat $cmake_version_file | grep "_VERSION_MAJOR " | awk '{print $2}' | cut -d'"' -f2 | tr -d ')')
version_minor=$(cat $cmake_version_file | grep "_VERSION_MINOR " | awk '{print $2}' | cut -d'"' -f2 | tr -d ')')
version_patch=$(cat $cmake_version_file | grep "_VERSION_PATCH " | awk '{print $2}' | cut -d'"' -f2 | tr -d ')' | tr -d v)

version="$version_major.$version_minor.$version_patch"
version="2.1.0rc2"
package="ants"
maintainer="ANTsX/ANTs <https://github.com/ANTsX/ANTs/issues>"
arch="amd64"
depends="libstdc++6, libgomp1"

#date=`date -u +%Y%m%d`
#echo "date=$date"

#gitrev=`git rev-parse HEAD | cut -b 1-8`
gitrevfull=`git rev-parse HEAD`
gitrevnum=`git log --oneline | wc -l | tr -d ' '`
#echo "gitrev=$gitrev"

buildtimestamp=`date -u +%Y%m%d-%H%M%S`
hostname=`hostname`
echo "build machine=${hostname}"
echo "build time=${buildtimestamp}"
echo "gitrevfull=$gitrevfull"
echo "gitrevnum=$gitrevnum"

debian_revision="${gitrevnum}"
upstream_version="${version}"
echo "upstream_version=$upstream_version"
echo "debian_revision=$debian_revision"

packageversion="${upstream_version}-github${debian_revision}"
packagename="${package}_${packageversion}_${arch}"
echo "packagename=$packagename"
packagefile="${packagename}.deb"
echo "packagefile=$packagefile"

description="build machine=${hostname}, build time=${buildtimestamp}, git revision=${gitrevfull}"
if [ ! -z ${BUILD_NUMBER} ]; then
    echo "build number=${BUILD_NUMBER}"
    description="$description, build number=${BUILD_NUMBER}"
fi

installedsize=`du -s ${deb_root} | awk '{print $1}'`

mkdir -p ${deb_root}/DEBIAN/
#for format see: https://www.debian.org/doc/debian-policy/ch-controlfields.html
cat > ${deb_root}/DEBIAN/control << EOF |
Section: science
Priority: extra
Maintainer: $maintainer
Version: $packageversion
Package: $package
Architecture: $arch
Depends: $depends
Installed-Size: $installedsize
Description: ANTs minimal build for brain tissue classification. This version was built with openmp, $description
EOF

echo "Creating .deb file: $packagefile"
rm -f ${package}_*.deb
fakeroot dpkg-deb --build ${deb_root} $packagefile

echo "Package info"
dpkg -I $packagefile
