#!/bin/sh
# Install dependencies for Remarkable kernel compile script

# Define script directories
dir_base=${dir_base:="/workspaces/ParabolaRM_autocompile/sources/base.sh"}
dir_download=${dir_download:="/workspaces/ParabolaRM_autocompile/sources/download.sh"}
dir_download_everything=${dir_download_everything:="/workspaces/ParabolaRM_autocompile/sources/download_everything.sh"}
dir_extract=${dir_extract:="/workspaces/ParabolaRM_autocompile/sources/extract.sh"}
dir_extract_kernel=${dir_extract_kernel:="/workspaces/ParabolaRM_autocompile/sources/extract_kernel.sh"}
dir_pkg_detection=${dir_pkg_detection:="/workspaces/ParabolaRM_autocompile/sources/pkg_detection.sh"}
dir_install_dependencies=${dir_install_dependencies:="/workspaces/ParabolaRM_autocompile/sources/install_dependencies.sh"}


# Remove propriaetary software (Non Working)
remove_proprietary=${remove_proprietary:=false}

# Install dependencies automatically
install_dependencies=${install_dependencies:=true}

# List of dependencies
dependencies=${dependencies:="git wget curl aria2 pigz unzip p7zip-full"}


# Remarkable toolchain install
install_toolchain=${install_toolchain:=true}

# Remarkable toolchain download
download_toolchain=${download_toolchain:=true}

# Remarkable toolchain URL 
toolchain_url=${toolchain_url:="https://ipfs.eeems.website/ipfs/Qmdkdeh3bodwDLM9YvPrMoAi6dFYDDCodAnHvjG5voZxiC"}

# Remarkable toolchain download directory
toolchain_download_dir=${toolchain_download_dir:="/workspaces/ParabolaRM_autocompile/downloads/toolchain"}

# Remarkable toolchain install file directory
toolchain_dir=${toolchain_dir:="/workspaces/ParabolaRM_autocompile/toolchain"}

# Remarkable toolchain env config file directory
toolchain_env_dir=${toolchain_env_dir:="/workspaces/ParabolaRM_autocompile/toolchain/env.sh"}


# Remarkable kernel Extract
extract_kernel=${extract_kernel:=true}

# Remarkable kernel download
download_kernel=${download_kernel:=true}

# Remarkable kernel source URL
kernel_url=${kernel_url:="https://codeload.github.com/reMarkable/linux/zip/refs/heads/lars/zero-gravitas_4.9"}

# Remarkable kernel download directory
kernel_download_dir=${kernel_download_dir="/workspaces/ParabolaRM_autocompile/downloads/kernel"}

# Remarkable kernel directory
kernel_dir=${kernel_dir:="/workspaces/ParabolaRM_autocompile/linux-kernel"}



# Download manager
download_manager=${download_manager:="aria2c"}
#download_manager=${download_manager:="wget"}
#download_manager=${download_manager:="curl"}
#download_manager=${download_manager:="axel"}

download_segmentation=${download_segmentation:=16}

# Unzip manager
#unzip_manager=${unzip_manager:="unzip"}
unzip_manager=${unzip_manager:="7z"}


# Multi-threaded Unzip ture/false
unzip_multithreaded=${unzip_multithreaded:=true}

# Dir for extracted files
extract_dir=${extract_dir:="/workspaces/ParabolaRM_autocompile/extracted"}