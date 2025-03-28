#!/bin/bash
# Remarkable kernel compile script for ParabolaRM distro (Parabola GNU/Linux-libre mod)

# Get the script's directory
script_dir=$(dirname "$(readlink -f "$0")")

# Source the base.sh script and other dependencies
. "${script_dir}/sources/base.sh"
. "${script_dir}/sources/install_dependencies.sh"
. "${script_dir}/sources/download_everything.sh"
. "${script_dir}/sources/extract_kernel.sh"

# Set directory paths relative to script location
kernel_dir="${script_dir}/kernel"
kernel_download_dir="${script_dir}/downloads/kernel"
toolchain_dir="${script_dir}/toolchain"
toolchain_download_dir="${script_dir}/downloads/toolchain"
extract_dir="${script_dir}/extracted"

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
    echo "Starting kernel extraction..."
    extract_kernel
    if [ $? -eq 0 ]; then
        echo "Kernel extraction completed successfully"
    else
        echo "Kernel extraction failed"
        exit 1
    fi
fi