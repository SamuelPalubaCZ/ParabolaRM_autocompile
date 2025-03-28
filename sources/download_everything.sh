#!/bin/bash
# Download all packages that are needed for the compilation

# Get script directory and project root
script_dir=$(dirname "$(readlink -f "$0")")
project_root=$(dirname "$script_dir")

# Source the base.sh script
. "${script_dir}/base.sh"

# Source download.sh script
. "${script_dir}/download.sh"

# Download kernel function
download_kernel() {
    download $kernel_url $kernel_download_dir
    echo "Kernel downloaded"
}

# Download toolchain function
download_toolchain() {
    download $toolchain_url $toolchain_download_dir
    echo "Toolchain downloaded"
}
