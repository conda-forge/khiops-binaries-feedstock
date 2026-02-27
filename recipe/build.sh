#!/bin/bash

# Set-up the shell to behave more like a general-purpose programming language
set -euo pipefail

# Configure project
cmake ${CMAKE_ARGS} -B build/conda -S . -D BUILD_JARS=OFF -D TESTING=OFF -D CMAKE_BUILD_TYPE=Release -G Ninja

# Build MODL and MODL_Coclustering
cmake --build build/conda --parallel --target MODL MODL_Coclustering KhiopsNativeInterface _khiopsgetprocnumber

# Move the binaries to the Conda PREFIX path
mv ./build/conda/bin/MODL* "$PREFIX/bin"
mv ./build/conda/bin/_khiopsgetprocnumber* "$PREFIX/bin"
mv ./build/conda/lib/libKhiopsNativeInterface* "$PREFIX/lib"

# Copy the scripts to the Conda PREFIX path
cp ./build/conda/tmp/khiops_env "$PREFIX/bin"
cp ./build/conda/tmp/khiops "$PREFIX/bin"
cp ./build/conda/tmp/khiops_coclustering "$PREFIX/bin"

# Copy header file
cp ./src/Learning/KhiopsNativeInterface/KhiopsNativeInterface.h "$PREFIX/include"

# Set up the activation and deactivation scripts for the Conda environment
# We always copy the scripts under the "khiops-core" basename.  The recipe
# declares those exact paths in the khiops-core output, so they will be
# packaged there during the split.  The build script only runs once for the
# entire multi‑output recipe, and $PKG_NAME refers to the top‑level package
# (khiops-binaries), so using it in the filename would put the wrong name into
# the prefix.
for CHANGE in "activate" "deactivate"
do
    mkdir -p "${PREFIX}/etc/conda/${CHANGE}.d"
    cp "${RECIPE_DIR}/${CHANGE}.sh" "${PREFIX}/etc/conda/${CHANGE}.d/khiops-core_${CHANGE}.sh"
done