#!/usr/bin/env bash
set -e

itk_dir=$1
#backupdir="backup"
#mkdir -p $backupdir

# Overwrite tolerance default 1.0e-6 with 1.0e-2 to avoid
# error: "Inputs do not occupy the same physical space"
# from: https://github.com/stnava/ANTs/issues/74
# and: https://github.com/stnava/ANTs/issues/31
f="$itk_dir/Modules/Core/Common/src/itkImageToImageFilterCommon.cxx"
#cp $f $backupdir
sed -i 's/1.0e-6/1.0e-2/g' $f
