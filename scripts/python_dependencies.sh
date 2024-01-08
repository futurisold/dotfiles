#!/bin/bash

# check if a conda environment is active
if [ "$CONDA_PREFIX" == "" ]; then
    echo "No conda environment active. Please activate a conda environment."
    exit 1
fi

pip install debugpy jedi-language-server ruff-lsp

