#!/bin/sh
# Install dependencies for Remarkable kernel compile script

# Remove propriaetary software (Non Working)
remove_proprietary=${remove_proprietary:=false}

# Install dependencies automatically
install_dependencies=${install_dependencies:=true}

# Package Manager detection script
pkg_detection_url=${pkg_detection_url:="https://raw.githubusercontent.com/mdeacey/universal-os-detector/refs/heads/main/universal-os-detector.sh"}

# List of dependencies
dependencies=${dependencies:="git wget curl aria2"}

# Remarkable toolchain URL 
toolchain_url=${toolchain_url:="https://ipfs.eeems.website/ipfs/Qmdkdeh3bodwDLM9YvPrMoAi6dFYDDCodAnHvjG5voZxiC"}

# Remarkable toolchain directory
toolchain_dir=${toolchain_dir:="/workspaces/ParabolaRM_autocompile/toolchain"}

# Remarkable kernel source URL
kernel_url=${kernel_url:="https://codeload.github.com/reMarkable/linux/zip/refs/heads/lars/zero-gravitas_4.9"}


# Remarkable kernel source directory
kernel_dir=${kernel_dir:="/workspaces/ParabolaRM_autocompile/linux-kernel"}

# Download manager
download_manager=${download_manager:="aria2c"}
#download_manager=${download_manager:="wget"}
#download_manager=${download_manager:="curl"}
#download_manager=${download_manager:="axel"}

download_segmentation=${download_segmentation:=16}