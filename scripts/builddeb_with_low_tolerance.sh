#!/usr/bin/env bash
set -e
set -x

BUILD_NUMBER=$1

script_dir=$(dirname "$0")
cd ${script_dir}/..
sh ${script_dir}/compile_with_low_tolerance.sh

rm -rf debian/usr
mkdir -p debian/usr/bin
builddir=build/bin
cp $builddir/Atropos debian/usr/bin/Atropos_wlt
cp $builddir/ImageMath debian/usr/bin/ImageMath_wlt
cp $builddir/N3BiasFieldCorrection debian/usr/bin/N3BiasFieldCorrection_wlt
cp $builddir/N4BiasFieldCorrection debian/usr/bin/N4BiasFieldCorrection_wlt

cmake_version_file=deps/ANTs/CMakeLists.txt
version_major=$(cat $cmake_version_file | grep "_VERSION_MAJOR " | awk '{print $2}' | cut -d'"' -f2)
version_minor=$(cat $cmake_version_file | grep "_VERSION_MINOR " | awk '{print $2}' | cut -d'"' -f2)
version_patch=$(cat $cmake_version_file | grep "_VERSION_PATCH " | awk '{print $2}' | cut -d'"' -f2 | tr -d v)

version="$version_major.$version_minor.$version_patch"
package="ants-with-low-tolerance"
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

outdir="debian"

installedsize=`du -s $outdir | awk '{print $1}'`

mkdir -p debian/DEBIAN/
#for format see: https://www.debian.org/doc/debian-policy/ch-controlfields.html
cat > debian/DEBIAN/control << EOF |
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
fakeroot dpkg-deb --build $outdir $packagefile

echo "Package info"
dpkg -I $packagefile
