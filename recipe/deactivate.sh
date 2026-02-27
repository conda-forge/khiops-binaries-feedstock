#!/usr/bin/env bash
if [[ "${CONDA_SUBDIR:-}" == osx-* ]] || [[ "$(uname -s)" == "Darwin" ]]; then
  unset FI_PROVIDER
fi
