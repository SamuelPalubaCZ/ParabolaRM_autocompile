#!/bin/bash
# Install dependencies for Remarkable kernel compile script

# Set project root directory
project_root="/home/samuel/remarkable/kernel/ParabolaRM_autocompile"

echo "[BASE] Project root: $project_root"

# Define script directories with absolute paths
dir_base="${project_root}/sources/base.sh"
dir_download="${project_root}/sources/download.sh"
dir_download_kernel="${project_root}/sources/download_kernel.sh"
dir_download_toolchain="${project_root}/sources/download_toolchain.sh"
dir_extract="${project_root}/sources/extract.sh"
dir_extract_kernel="${project_root}/sources/extract_kernel.sh"
dir_pkg_detection="${project_root}/sources/pkg_detection.sh"
dir_install_dependencies="${project_root}/sources/install_dependencies.sh"
echo "[BASE] Script directories defined"

# Logging configuration
# Level 0: No logs
# Level 1: Critical errors only
# Level 2: Errors and warnings
# Level 3: Basic information (moderate verbosity)
# Level 4: Detailed information (more verbose)
# Level 5: Debug level (most verbose)
log_level=${log_level:=5}
echo "[BASE] Log level set to: $log_level"

# Option to delete previous logs (true/false)
delete_previous_logs=${delete_previous_logs:=true}
echo "[BASE] Delete previous logs set to: $delete_previous_logs"

# Logs directory
logs_dir="${project_root}/logs"
echo "[BASE] Logs directory set to: $logs_dir"

# Replace idk with a more meaningful default value
default_enabled="true"
echo "[BASE] Default value set: default_enabled=$default_enabled"

# Remove propriaetary software (Non Working)
remove_proprietary=${remove_proprietary:=false}
echo "[BASE] remove_proprietary set to: $remove_proprietary"

# Install dependencies automatically
install_dependencies=${install_dependencies:=true}
echo "[BASE] install_dependencies set to: $install_dependencies"

# List of dependencies
dependencies=${dependencies:="git wget curl aria2 pigz unzip p7zip-full"}
echo "[BASE] Dependencies list: $dependencies"

# Remarkable toolchain install
install_toolchain=${install_toolchain:=true}
echo "[BASE] install_toolchain set to: $install_toolchain"

# Remarkable toolchain download
download_toolchain=${download_toolchain:=$default_enabled}
echo "[BASE] download_toolchain set to: $download_toolchain"

# Remarkable toolchain URL 
toolchain_url=${toolchain_url:="https://ipfs.eeems.website/ipfs/Qmdkdeh3bodwDLM9YvPrMoAi6dFYDDCodAnHvjG5voZxiC"}
echo "[BASE] toolchain_url set to: $toolchain_url"

# Remarkable toolchain download directory
toolchain_download_dir=${toolchain_download_dir:="${project_root}/downloads/toolchain"}
echo "[BASE] toolchain_download_dir set to: $toolchain_download_dir"

# Remarkable toolchain install file directory
toolchain_dir=${toolchain_dir:="${project_root}/toolchain"}
echo "[BASE] toolchain_dir set to: $toolchain_dir"

# Remarkable toolchain env config file directory
toolchain_env_dir=${toolchain_env_dir:="${project_root}/toolchain/env.sh"}
echo "[BASE] toolchain_env_dir set to: $toolchain_env_dir"

# Remarkable kernel Extract
extract_kernel=${extract_kernel:=true}
echo "[BASE] extract_kernel set to: $extract_kernel"

# Remarkable kernel download
download_kernel=${download_kernel:=$default_enabled}
echo "[BASE] download_kernel set to: $download_kernel"

# Remarkable kernel source URL
kernel_url=${kernel_url:="https://codeload.github.com/reMarkable/linux/zip/refs/heads/lars/zero-gravitas_4.9"}
echo "[BASE] kernel_url set to: $kernel_url"

# Remarkable kernel download directory
kernel_download_dir=${kernel_download_dir:="${project_root}/downloads/kernel"}
echo "[BASE] kernel_download_dir set to: $kernel_download_dir"

# Remarkable kernel directory
kernel_dir=${kernel_dir:="${project_root}/linux-kernel"}
echo "[BASE] kernel_dir set to: $kernel_dir"

# Download manager - changed default to wget since it's more commonly available
download_manager=${download_manager:="wget"}
echo "[BASE] download_manager set to: $download_manager"

download_segmentation=${download_segmentation:=16}
echo "[BASE] download_segmentation set to: $download_segmentation"

# Unzip manager - changed default to unzip since it's more commonly available
unzip_manager=${unzip_manager:="unzip"}
echo "[BASE] unzip_manager set to: $unzip_manager"

# Multi-threaded Unzip ture/false
unzip_multithreaded=${unzip_multithreaded:=true}
echo "[BASE] unzip_multithreaded set to: $unzip_multithreaded"

# Dir for extracted files
extract_dir=${extract_dir:="${project_root}/extracted"}
echo "[BASE] extract_dir set to: $extract_dir"

# Install with sudo (true/false)
use_sudo=${use_sudo:=true}
echo "[BASE] use_sudo set to: $use_sudo"

# Default sudo password (8 spaces by default)
sudo_password=${sudo_password:="        "}
echo "[BASE] sudo_password set (hidden for security)"

# Function to delete all previous logs
delete_logs() {
    if [ "$delete_previous_logs" = true ] && [ -d "$logs_dir" ]; then
        echo "[BASE] Deleting previous logs from: $logs_dir"
        rm -rf "$logs_dir"/*
        echo "[BASE] Previous logs deleted"
    fi
}

# Log function based on log level
log_message() {
    local level=$1
    local message=$2
    local prefix=$3
    
    if [ "$log_level" -ge "$level" ]; then
        case "$level" in
            1) echo "[$prefix] ❌ $message" ;;
            2) echo "[$prefix] ⚠️ $message" ;;
            3) echo "[$prefix] $message" ;;
            4) echo "[$prefix] $message" ;;
            5) echo "[$prefix] 🔍 $message" ;;
        esac
    fi
}

remove_junk_before() {
    log_message 3 "Removing junk: $*" "BASE"
    # Remove $kernel_dir $kernel_download_dir $toolchain_dir $toolchain_download_dir
    rm -rf $*
    log_message 3 "Junk removed" "BASE"
}

remove_downlands() {
    log_message 3 "Removing downloads: $kernel_download_dir $toolchain_download_dir" "BASE"
    # Remove $kernel_download_dir $toolchain_download_dir
    rm -rf $kernel_download_dir $toolchain_download_dir
    log_message 3 "Downloads removed" "BASE"
}

remove_extracted() {
    log_message 3 "Removing extracted files: $extract_dir" "BASE"
    # Remove $extract_dir/kernel $extract_dir/toolchain
    rm -rf $extract_dir
    log_message 3 "Extracted files removed" "BASE"
}

remove_toolchain() {
    log_message 3 "Removing toolchain: $toolchain_dir" "BASE"
    # Remove $toolchain_dir
    rm -rf $toolchain_dir
    log_message 3 "Toolchain removed" "BASE"
}

remove_kernel() {
    log_message 3 "Removing kernel: $kernel_dir" "BASE"
    # Remove $kernel_dir
    rm -rf $kernel_dir
    log_message 3 "Kernel removed" "BASE"
}

# After the existing variables, add these new configuration options

# Control whether to delete existing downloads before downloading again
delete_existing_downloads=${delete_existing_downloads:=false}
echo "[BASE] delete_existing_downloads set to: $delete_existing_downloads"

# Control whether to reuse existing downloads if they exist
reuse_existing_downloads=${reuse_existing_downloads:=true}
echo "[BASE] reuse_existing_downloads set to: $reuse_existing_downloads"

# Control whether to delete downloads after extraction
delete_after_extraction=${delete_after_extraction:=false}
echo "[BASE] delete_after_extraction set to: $delete_after_extraction"

# Control whether to verify downloads before extraction
verify_downloads=${verify_downloads:=true}
echo "[BASE] verify_downloads set to: $verify_downloads"
