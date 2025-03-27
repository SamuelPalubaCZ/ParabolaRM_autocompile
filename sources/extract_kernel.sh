#!/bin/sh

# Extract kernel for Remarkable kernel compile script


# Source extract.sh script via base.sh envs
source ${dir_base:="/workspaces/ParabolaRM_autocompile/sources/base.sh"}
source $dir_extract
# Extract kernel
extract_kernel() {
    # save default directory
    default_dir=$PWD
    
    # Find the zip file
    zip_file=$(find "$kernel_download_dir" -name "*.zip")
    
    if [ -z "$zip_file" ]; then
        echo "No zip file found in $kernel_download_dir"
        return 1
    fi
    
    # Extract the kernel
    extract "$zip_file" "$kernel_dir"
    
    echo "Kernel extracted"
}

if [ "$extract_kernel" = true ]; then
    extract_kernel
fi