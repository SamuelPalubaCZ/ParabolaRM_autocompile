#!/bin/sh
# Download all packiges thata are needed for the compilation and cant be installed via package manager

# Source the base.sh script
source ${dir_base:="/workspaces/ParabolaRM_autocompile/sources/base.sh"}

# Source download.sh script
source $dir_download

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

if [ "$download_kernel" = true ]; then
    download_kernel
fi
