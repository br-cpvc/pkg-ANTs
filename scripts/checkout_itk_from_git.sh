#!/usr/bin/env bash
set -e
set -x
script_dir=$(dirname "$0")

cwd=`pwd`
itk_dir=$1

url=https://github.com/InsightSoftwareConsortium/ITK.git
if [ ! -d $itk_dir ]; then
    githash=$(sh ${script_dir}/get_ants_matching_itk_githash.sh)
    git clone --no-checkout $url $itk_dir
    cd $itk_dir
    git checkout $githash
    cd $cwd
fi
