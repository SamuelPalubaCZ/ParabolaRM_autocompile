#!/bin/sh

# Download resources for Remarkable kernel compile script
# Source config.sh script
dir_base="/workspaces/ParabolaRM_autocompile/sources/base.sh"
dir_download="/workspaces/ParabolaRM_autocompile/sources/download.sh"
dir_pkg_detection="/workspaces/ParabolaRM_autocompile/sources/pkg_detection.sh"
dir_download_everything="/workspaces/ParabolaRM_autocompile/sources/download_everything.sh"
dir_config="/workspaces/ParabolaRM_autocompile/config.sh"

# Source the base.sh script
source $dir_base

# Source download.sh script
source $dir_download

# Source pkg_detection.sh script
source $dir_pkg_detection

# Source install_dependencies.sh script
source $dir_install_dependencies

# Source install_dependencies.sh script
source $dir_install_dependencies
# Install dependencies
if [ "$install_dependencies" = true ]; then
    install_dependencies $dependencies
    echo "Dependencies installed"
fi

# Download kernel source
download $kernel_url $kernel_dir 
echo "Kernel downloaded"

# Download toolchain
download $toolchain_url $toolchain_dir
echo "Toolchain source downloaded"
