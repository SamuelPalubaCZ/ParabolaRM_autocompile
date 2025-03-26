#!/bin/sh

# Download resources for Remarkable kernel compile script
# Source config.sh script
source /workspaces/ParabolaRM_autocompile/sources/config.sh

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
