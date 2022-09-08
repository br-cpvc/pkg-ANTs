#!/usr/bin/env bash
set -e
grep "_GIT_TAG " deps/ANTs/SuperBuild/External_ITKv5.cmake | awk '{print $2}' | tr -d ")"

