#!/bin/bash
# Install dependencies for Remarkable kernel compile script

# Get the script's directory and project root
script_dir=$(dirname "$(readlink -f "$0")")
project_root=$(dirname "$script_dir")

# Define script directories
dir_base="${script_dir}/base.sh"
dir_download="${script_dir}/download.sh"
dir_download_everything="${script_dir}/download_everything.sh"
dir_extract="${script_dir}/extract.sh"
dir_extract_kernel="${script_dir}/extract_kernel.sh"
dir_pkg_detection="${script_dir}/pkg_detection.sh"
dir_install_dependencies="${script_dir}/install_dependencies.sh"

idk="true"


# Remove propriaetary software (Non Working)
remove_proprietary=${remove_proprietary:=false}

# Install dependencies automatically
install_dependencies=${install_dependencies:=false}

# List of dependencies
dependencies=${dependencies:="git wget curl aria2 pigz unzip p7zip-full"}


# Remarkable toolchain install
install_toolchain=${install_toolchain:=true}

# Remarkable toolchain download
download_toolchain=${download_toolchain:=$idk}

# Remarkable toolchain URL 
toolchain_url=${toolchain_url:="https://ipfs.eeems.website/ipfs/Qmdkdeh3bodwDLM9YvPrMoAi6dFYDDCodAnHvjG5voZxiC"}

# Remarkable toolchain download directory
toolchain_download_dir=${toolchain_download_dir:="${project_root}/downloads/toolchain"}

# Remarkable toolchain install file directory
toolchain_dir=${toolchain_dir:="${project_root}/toolchain"}

# Remarkable toolchain env config file directory
toolchain_env_dir=${toolchain_env_dir:="${project_root}/toolchain/env.sh"}


# Remarkable kernel Extract
extract_kernel=${extract_kernel:=true}

# Remarkable kernel download
download_kernel=${download_kernel:=$idk}

# Remarkable kernel source URL
kernel_url=${kernel_url:="https://codeload.github.com/reMarkable/linux/zip/refs/heads/lars/zero-gravitas_4.9"}

# Remarkable kernel download directory
kernel_download_dir=${kernel_download_dir:="${project_root}/downloads/kernel"}

# Remarkable kernel directory
kernel_dir=${kernel_dir:="${project_root}/linux-kernel"}



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
extract_dir=${extract_dir:="${project_root}/extracted"}


remove_junk_before() {
    # Remove $kernel_dir $kernel_download_dir $toolchain_dir $toolchain_download_dir
    rm -rf $*
}

remove_downlands() {
    # Remove $kernel_download_dir $toolchain_download_dir
    rm -rf $kernel_download_dir $toolchain_download_dir
}

remove_extracted() {
    # Remove $extract_dir/kernel $extract_dir/toolchain
    rm -rf $extract_dir
}

remove_toolchain() {
    # Remove $toolchain_dir
    rm -rf $toolchain_dir
}

remove_kernel() {
    # Remove $kernel_dir
    rm -rf $kernel_dir
}
