#!/bin/sh
# Remarkable kernel compile script for ParabolaRM distro (Parabola GNU/Linux-libre mod)

# Source the base.sh script
source ${dir_base:="/workspaces/ParabolaRM_autocompile/sources/base.sh"}
source $dir_install_dependencies
source $dir_download_everything
source $dir_extract_kernel

remove_kernel
remove_toolchain
remove_downlands
remove_extracted

# Create required directories
mkdir -p "$kernel_dir"
mkdir -p "$kernel_download_dir"
mkdir -p "$toolchain_dir"
mkdir -p "$toolchain_download_dir"
mkdir -p "$extract_dir/kernel"
mkdir -p "$extract_dir/toolchain"

# Install dependencies
if [ "$install_dependencies" = true ]; then
    install_dependencies "$dependencies"
fi

# Download everything
if [ "$download_everything" = true ]; then
    download_kernel
    download_toolchain
fi

# Extract kernel
if [ "$extract_kernel" = true ]; then
    extract_kernel
fi