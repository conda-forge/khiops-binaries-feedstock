#!/usr/bin/env bash
# Define FI_PROVIDER for macOS to avoid MPICH issue 
# see https://github.com/conda-forge/mpich-feedstock/issues/132#issuecomment-3867319989
if [[ "${CONDA_SUBDIR:-}" == osx-* ]] || [[ "$(uname -s)" == "Darwin" ]]; then
  export FI_PROVIDER=tcp
fi
