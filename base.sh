#!/bin/sh
# Install dependencies for Remarkable kernel compile script

# Remove propriaetary software (Non Working)
remove_proprietary=${remove_proprietary:=false}

# Install dependencies automatically
install_dependencies=${install_dependencies:=true}

# Package Manager detection script
pkg_detection_url=${pkg_detection_url:="https://raw.githubusercontent.com/mdeacey/universal-os-detector/refs/heads/main/universal-os-detector.sh"}

# List of dependencies
dependencies=${dependencies:="git wget aria2"}

# Remarkable toolchain URL 
toolchain_url=${toolchain_url:="https://ipfs.eeems.website/ipfs/Qmdkdeh3bodwDLM9YvPrMoAi6dFYDDCodAnHvjG5voZxiC"}

# Remarkable kernel source URL
kernel_git=${kernel_git:="https://github.com/SamuelPalubaCZ/linux-kernel.git"}

# Remarkable kernel source branch
kernel_branch=${kernel_branch:="lars/zero-gravitas_4.9"}

# Remarkable kernel source directory
kernel_dir=${kernel_dir:="/home/user/Documents/linux-kernel"}

# Source the package manager detection variables with script by Michael Deacey (by default)
pkg_detection() {
source [wget -O - ${pkg_detection_url:="https://raw.githubusercontent.com/mdeacey/universal-os-detector/refs/heads/main/universal-os-detector.sh"}]
run_detection
echo $pkg_manager

}
