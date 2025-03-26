#!/bin/sh
# Download toolchain for Remarkable kernel compile script

# Source the base.sh script
source sources/base.sh
echo "Base script sourced"

# Source download.sh script
source sources/download.sh
echo "Download script sourced"

# Source pkg_detection.sh script
source sources/pkg_detection.sh
echo "Package detection script sourced"

# Install dependencies
if [ "$install_dependencies" = true ]; then
    install_dependencies $dependencies
    echo "Dependencies installed"
fi

# Download toolchain
download $toolchain_url $kernel_dir
echo "Toolchain downloaded"

# Download and extract kernel source
download $kernel_url $toolchain_dir
echo "Kernel source downloaded"
