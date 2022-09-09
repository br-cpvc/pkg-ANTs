#!/usr/bin/env bash
set -e
#set -x

cwd=`pwd`
itk_version=$1

itk_dir=deps/itk
itk_pkg=$itk_dir/InsightToolkit-$itk_version.tar.gz
mkdir -p $itk_dir

url=https://github.com/InsightSoftwareConsortium/ITK/archive/refs/tags
if [ ! -f $itk_pkg ]; then
	wget $url/v$itk_version.tar.gz -O $itk_pkg
fi
md5sum -c InsightToolkit-$itk_version.tar.gz.md5sum

itk_dir="InsightToolkit-$itk_version"
if [ ! -d $itk_dir ]; then
	tar -zxf ${itk_pkg}
	mv ITK-${itk_version} ${itk_dir}
fi
