#!/usr/bin/env bash


launch_devcontainer() {

    if [[ -z $1 ]] || [[ -z $2 ]]; then
        echo "Usage: $0 [CUDA version] [Host compiler]"
        echo "Example: $0 12.2 gcc12"
        return 1
    fi
    set -euo pipefail
    # Ensure we're in the repo root
    cd "$( cd "$( dirname "$(realpath -m "${BASH_SOURCE[0]}")" )" && pwd )/..";


    local cuda_version="$1"
    local host_compiler="$2"
    local workspace="$(basename "$(pwd)")";
    local tmpdir="$(mktemp -d)/${workspace}";
    local path="$(pwd)/.devcontainer/cuda${cuda_version}-${host_compiler}";
    if [[ ! -f ${path}/devcontainer.json ]]; then
        echo "Unknown CUDA [${cuda_version}] compiler [${host_compiler}] combination"
        echo "Requested devcontainer ${path}/devcontainer.json does not exist"
        return 1
    fi
    mkdir -p "${tmpdir}";
    mkdir -p "${tmpdir}/.devcontainer";
    cp -arL "$path/devcontainer.json" "${tmpdir}/.devcontainer";
    sed -i "s@\${localWorkspaceFolder}@$(pwd)@g" "${tmpdir}/.devcontainer/devcontainer.json";
    path="${tmpdir}";

    local hash="$(echo -n "${path}" | xxd -pu - | tr -d '[:space:]')";
    local url="vscode://vscode-remote/dev-container+${hash}/home/coder/cccl";

    echo "devcontainer URL: ${url}";

    local launch="";
    if type open >/dev/null 2>&1; then
        launch="open";
    elif type xdg-open >/dev/null 2>&1; then
        launch="xdg-open";
    fi

    if [ -n "${launch}" ]; then
        code --new-window "${tmpdir}";
        exec "${launch}" "${url}" >/dev/null 2>&1;
    fi
}

launch_devcontainer "$@";
